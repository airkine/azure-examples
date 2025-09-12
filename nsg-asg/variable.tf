variable "prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = "nsgasg"
}

variable "location" {
  type        = string
  description = "Azure location"
  default     = "eastus"
}

variable "vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "app_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "db_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "admin_ssh_public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..."
}

variable "image_publisher" {
  type    = string
  default = "Canonical"
}

variable "image_offer" {
  type    = string
  default = "UbuntuServer"
}

variable "image_sku" {
  type    = string
  default = "18.04-LTS"
}

variable "image_version" {
  type    = string
  default = "latest"
}
