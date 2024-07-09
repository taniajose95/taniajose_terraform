output "resource_group_name" {
  value = module.rgroup.resource_group_name
}

output "virtual_network_name" {
  value = module.network.virtual_network_name
}

output "subnet_name" {
  value = module.network.subnet_name
}

output "log_analytics_workspace_name" {
  value = module.common.log_analytics_workspace_name
}

output "recovery_services_vault_name" {
  value = module.common.recovery_services_vault_name
}

output "storage_account_name" {
  value = module.common.storage_account_name
}

output "linux_vm_hostnames" {
  value = module.vmlinux.vm_hostnames
}

output "linux_vm_domain_names" {
  value = module.vmlinux.vm_domain_names
}

output "linux_vm_private_ips" {
  value = module.vmlinux.vm_private_ips
}

output "linux_vm_public_ips" {
  value = module.vmlinux.vm_public_ips
}

output "windows_vm_hostname" {
  value = module.vmwindows.vm_hostname
}

output "windows_vm_domain_name" {
  value = module.vmwindows.vm_domain_name
}

output "windows_vm_private_ip" {
  value = module.vmwindows.vm_private_ip
}

output "windows_vm_public_ip" {
  value = module.vmwindows.vm_public_ip
}

output "load_balancer_name" {
  value = module.loadbalancer.load_balancer_name
}

output "database_name" {
  value = module.database.database_name
}
