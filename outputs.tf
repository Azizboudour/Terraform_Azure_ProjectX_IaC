# ROOT outputs.tf 

output "vnet_id" {
  value = module.network.vnet_id
}

output "subnet_ids" {
  value = module.network.subnet_ids
}

output "nsg_id" {
  value = module.network.nsg_id
}


output "vm_id" {
  value = module.compute.vm_id
}

output "vm_public_ip_address" {
  value = module.compute.vm_public_ip_address
}