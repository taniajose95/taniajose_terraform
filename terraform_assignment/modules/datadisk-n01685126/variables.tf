variable "humber_id" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "linux_vm_ids" {
  type = list(string)
}


variable "tags" {
  type = map(string)
}

variable "windows_vm_ids" {
  type = list(string)
}

variable "windows_vm_count" {
  type = number
}
