# modules/security/main.tf 

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {

    subnet_id = var.web_subnet_id
    network_security_group_id = var.nsg_id
  
}