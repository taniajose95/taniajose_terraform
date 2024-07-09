resource "azurerm_availability_set" "windows_avset" {
  name                = "${var.humber_id}-windows-avset"
  location            = var.location
  resource_group_name = var.resource_group_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
  tags                = var.tags
}

resource "azurerm_public_ip" "windows_pip" {
  count               = var.windows_vm_count
  name                = "${var.humber_id}-windows-pip-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  domain_name_label   = "win-${lower(var.humber_id)}-${count.index + 1}"
  tags                = var.tags
}

resource "azurerm_network_interface" "windows_nic" {
  count               = var.windows_vm_count
  name                = "${var.humber_id}-windows-nic-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows_pip[count.index].id
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  count               = var.windows_vm_count
  name                = "${var.humber_id}-windows-vm-${count.index + 1}"
  computer_name       = "win${var.humber_id}${count.index + 1}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1ms"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  availability_set_id = azurerm_availability_set.windows_avset.id
  network_interface_ids = [
    azurerm_network_interface.windows_nic[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = var.storage_account_uri
  }

  tags = var.tags

}

resource "azurerm_virtual_machine_extension" "antimalware" {
  count                = var.windows_vm_count
  name                 = "IaaSAntimalware"
  virtual_machine_id   = azurerm_windows_virtual_machine.windows_vm[count.index].id
  publisher            = "Microsoft.Azure.Security"
  type                 = "IaaSAntimalware"
  type_handler_version = "1.3"
  settings = <<SETTINGS
    {
        "AntimalwareEnabled": true
    }
SETTINGS

  tags = var.tags
}
