output "vm_hostnames" {
  value = { for k, v in azurerm_linux_virtual_machine.linux_vm : k => v.name }
}

output "vm_domain_names" {
  value = { for k, v in azurerm_linux_virtual_machine.linux_vm : k => azurerm_public_ip.linux_pip[k].fqdn }
}

output "vm_private_ips" {
  value = { for k, v in azurerm_linux_virtual_machine.linux_vm : k => azurerm_network_interface.linux_nic[k].private_ip_address }
}

output "vm_public_ips" {
  value = { for k, v in azurerm_linux_virtual_machine.linux_vm : k => azurerm_public_ip.linux_pip[k].ip_address }
}

output "linux_vm_ids" {
  value = [for vm in azurerm_linux_virtual_machine.linux_vm : vm.id]
}

output "linux_vm_nic_ids" {
  value = [for nic in azurerm_network_interface.linux_nic : nic.id]
}
