# modules/compute/variables.tf

variable "vm_name" {
  type        = string
  description = "Name of the Virtual Machine"
}



variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group"
}

variable "location" {
  type        = string
  description = "Azure region for the resources"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet where the VM will be deployed"
}

variable "vm_size" {
  type        = string
  description = "Size of the Virtual Machine"
  default     = "Standard_B1s"  # Default to a small VM size
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VM"
  default     = "adminuser"
}

variable "public_key_path" {
  type        = string
  description = "Path to the public SSH key for the VM"
}

variable "custom_data" {
  type        = string
  description = "Base64-encoded custom data script to run on the VM"
  default     = null
}