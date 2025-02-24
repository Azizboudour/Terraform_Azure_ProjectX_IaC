# modules/compute/outputs.tf
output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}

output "vm_public_ip_address" {
  value = azurerm_public_ip.vm_public_ip.ip_address
  description = "The public IP address of the VM"
  depends_on  = [azurerm_public_ip.vm_public_ip]
}

output "vm_private_ip" {
  value = azurerm_network_interface.vm_nic.private_ip_address
  description = "The private IP address of the VM"
}


