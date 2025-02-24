# modules/compute/main.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.17"
    }
  }
}

# Add Public IP Address
resource "azurerm_public_ip" "vm_public_ip" {
  name = "${var.vm_name}-pip"
  location = var.location
  resource_group_name = var.resource_group_name
  allocation_method = "Dynamic"
  sku = "Basic"
}

resource "azurerm_network_interface" "vm_nic" {
  name                  = "${var.vm_name}-nic"
  location              = var.location
  resource_group_name   = var.resource_group_name

  ip_configuration {
    name                             = "vm_ip"
    subnet_id                        = var.subnet_id
    private_ip_address_allocation    = "Dynamic"
    public_ip_address_id = azurerm_public_ip.vm_public_ip.id # Associate public IP
  }

}


resource "azurerm_linux_virtual_machine" "vm" {

    name              = var.vm_name
    computer_name = "webvm"
    resource_group_name = var.resource_group_name
    location = var.location
    size = var.vm_size
    admin_username = var.admin_username
    network_interface_ids = [azurerm_network_interface.vm_nic.id]
    custom_data = base64encode(file("${path.module}/scripts/setup_webserver.sh"))

    admin_ssh_key {
        username = var.admin_username
        public_key = file(var.public_key_path)
    }

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"    

    }  

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }
}


# Create a managed disk

resource "azurerm_managed_disk" "web_data_disk" {
  name = "${var.vm_name}-data-disk"
  location = var.location
  resource_group_name = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb = 50
}


# Attach the managed disk to the VM

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachement" {
  managed_disk_id = azurerm_managed_disk.web_data_disk.id 
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  lun = "10"
  caching = "ReadWrite" 
}



