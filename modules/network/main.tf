# modules/network/main.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.17"
    }
  }
}



resource "azurerm_virtual_network" "vnet" {
  
    name                     = var.vnet_name
    address_space            = var.address_space
    location                 = var.location
    resource_group_name      = var.resource_group_name 
}

resource "azurerm_subnet" "subnet" {
  
    for_each                 = var.subnets
    name                     = each.key
    address_prefixes         = [ each.value ]
    virtual_network_name     = azurerm_virtual_network.vnet.name 
    resource_group_name      = var.resource_group_name
}



resource "azurerm_network_security_group" "nsg" {

    name                     = "${var.vnet_name}-nsg"
    location                 = var.location
    resource_group_name      = var.resource_group_name 
  
}


