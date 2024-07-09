variable "humber_id" {
  type        = string
  description = "The last 4 digits of your Humber ID"
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be created"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the VMs will be created"
}

variable "storage_account_uri" {
  type        = string
  description = "The URI of the storage account for boot diagnostics"
}

variable "vm_names" {
  type        = map(string)
  description = "A map of VM names to create"
  default     = {
    vm1 = "vm1"
    vm2 = "vm2"
    vm3 = "vm3"
  }
}

variable "admin_username" {
  type        = string
  description = "The admin username for the VMs"
}

variable "public_key" {
  type        = string
  description = "The path to the public SSH key"
}

variable "private_key" {
  type        = string
  description = "The path to the private SSH key"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
}
