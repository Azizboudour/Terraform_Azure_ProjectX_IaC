# ROOT main.tf 

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.17"  # Use the latest version compatible with 3.x
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}


resource "azurerm_resource_group" "projectX-rg" {
    name              = "projectX-rg"
    location          = "germanywestcentral"
}

module "network" {
  source              = "./modules/network"
  vnet_name           = "projectX-vnet"
  address_space       = ["128.0.0.0/16"]
  subnets             = {
    web               = "128.0.1.0/24"
    database          = "128.0.2.0/24"
    bastion           = "128.0.3.0/24"
  }
  resource_group_name = azurerm_resource_group.projectX-rg.name 
  location            = azurerm_resource_group.projectX-rg.location
}


module "compute" {
  source              = "./modules/compute"
  vm_name             = var.vm_name

  resource_group_name = azurerm_resource_group.projectX-rg.name
  location            = azurerm_resource_group.projectX-rg.location
  subnet_id           = module.network.subnet_ids["web"]
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  public_key_path     = var.public_key_path
}


# Update the security module block in root main.tf
module "security" {
  source              = "./modules/security"
  nsg_id              = module.network.nsg_id
  web_subnet_id       = module.network.subnet_ids["web"]
  resource_group_name = azurerm_resource_group.projectX-rg.name
  nsg_name           = "${var.vnet_name}-nsg"  # This matches the NSG name from network module
}