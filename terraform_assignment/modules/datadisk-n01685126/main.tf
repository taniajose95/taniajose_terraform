locals {
  total_vms = length(var.linux_vm_ids) + var.windows_vm_count
}

resource "azurerm_managed_disk" "data_disk" {
  count                = local.total_vms
  name                 = "${var.humber_id}-datadisk-${count.index + 1}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "linux_disk_attach" {
  count              = length(var.linux_vm_ids)
  managed_disk_id    = azurerm_managed_disk.data_disk[count.index].id
  virtual_machine_id = var.linux_vm_ids[count.index]
  lun                = count.index
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_data_disk_attachment" "windows_disk_attach" {
  count              = var.windows_vm_count
  managed_disk_id    = azurerm_managed_disk.data_disk[length(var.linux_vm_ids) + count.index].id
  virtual_machine_id = var.windows_vm_ids[count.index]
  lun                = length(var.linux_vm_ids) + count.index
  caching            = "ReadWrite"
}
