resource "azurerm_availability_set" "linux_avset" {
  name                = "${var.humber_id}-linux-avset"
  location            = var.location
  resource_group_name = var.resource_group_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
  tags                = var.tags
}

resource "azurerm_public_ip" "linux_pip" {
  for_each            = var.vm_names
  name                = "${var.humber_id}-pip-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  domain_name_label   = "vm-${lower(var.humber_id)}${each.key}"
  tags                = var.tags
}

resource "azurerm_network_interface" "linux_nic" {
  for_each            = var.vm_names
  name                = "${var.humber_id}-nic-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux_pip[each.key].id
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  for_each            = var.vm_names
  name                = "${var.humber_id}-vm-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_B1ms"
  admin_username      = var.admin_username
  availability_set_id = azurerm_availability_set.linux_avset.id
  network_interface_ids = [
    azurerm_network_interface.linux_nic[each.key].id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_2"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = var.storage_account_uri
  }

  tags = var.tags
}


resource "azurerm_virtual_machine_extension" "network_watcher" {
  for_each             = var.vm_names
  name                 = "NetworkWatcherAgent"
  virtual_machine_id   = azurerm_linux_virtual_machine.linux_vm[each.key].id
  publisher            = "Microsoft.Azure.NetworkWatcher"
  type                 = "NetworkWatcherAgentLinux"
  type_handler_version = "1.4"

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "azure_monitor" {
  for_each             = var.vm_names
  name                 = "AzureMonitorLinuxAgent"
  virtual_machine_id   = azurerm_linux_virtual_machine.linux_vm[each.key].id
  publisher            = "Microsoft.Azure.Monitor"
  type                 = "AzureMonitorLinuxAgent"
  type_handler_version = "1.21"

  tags = var.tags
}
