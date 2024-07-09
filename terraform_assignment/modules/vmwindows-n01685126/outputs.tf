output "vm_hostname" {
  value = azurerm_windows_virtual_machine.windows_vm[*].name
}

output "vm_domain_name" {
  value = azurerm_public_ip.windows_pip[*].fqdn
}

output "vm_private_ip" {
  value = azurerm_network_interface.windows_nic[*].private_ip_address
}

output "vm_public_ip" {
  value = azurerm_public_ip.windows_pip[*].ip_address
}

output "windows_vm_id" {
  value = azurerm_windows_virtual_machine.windows_vm[*].id
}
