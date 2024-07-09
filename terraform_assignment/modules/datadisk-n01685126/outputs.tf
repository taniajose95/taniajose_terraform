output "linux_vm_data_disk_ids" {
  value = { for k, v in azurerm_virtual_machine_data_disk_attachment.linux_disk_attach : k => v.id }
}

output "windows_vm_data_disk_id" {
  value = azurerm_virtual_machine_data_disk_attachment.windows_disk_attach[*].id
}
