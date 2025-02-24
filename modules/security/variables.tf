# modules/security/variables.tf 

variable "nsg_id" {
  type = string
  description = "The ID of the Network Security Group"
}

variable "web_subnet_id" {
  type = string
  description = "The ID of the web subnet"
}

variable "resource_group_name" {
  type = string
  description = "Name of the resource group"
}

variable "nsg_name" {
  type = string
  description = "Name of the Network Security Group"
}