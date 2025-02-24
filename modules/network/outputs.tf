output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  value = { for k, v in azurerm_subnet.subnet : k => v.id }
}

output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}