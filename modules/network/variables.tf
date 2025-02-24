# modules/network/variables.tf 

variable "vnet_name" {
   description = "Name of the Virtual Network"
   type        = string 
  
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