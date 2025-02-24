# ROOT terraform variables.tf 

variable "vnet_name" {
   description = "Name of the Virtual Network"
   type        = string 
  
}

variable "subscription_id" {

  type = string
  
}

variable "address_space" {

  description = "VNet address space = ['128.0.0.0/16']"
  type        = list(string)  
  
}

variable "subnets" {
  
  description = "Subnet names and CIDR blocks"
  type        = map(string)
}


variable "resource_group_name" {

    type = string
  
}

variable "location" {

    type = string
  
}


variable "vm_name" {
  type        = string
  description = "Name of the Virtual Machine"
}





variable "vm_size" {
  type        = string
  description = "Size of the Virtual Machine"
  default     = "Standard_B1s"  # Default to a small VM size
}

variable "public_key_path" {
  type        = string
  description = "Path to the public SSH key for the VM"
}


variable "admin_username" {
  type        = string
  description = "Admin username for the VM"
  default     = "adminuser"
}

