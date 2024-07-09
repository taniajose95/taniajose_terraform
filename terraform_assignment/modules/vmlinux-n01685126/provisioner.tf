resource "null_resource" "linux_provisioner" {
  for_each = var.vm_names

  depends_on = [
    azurerm_linux_virtual_machine.linux_vm,
  ]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.linux_pip[each.key].ip_address
      user        = var.admin_username
      private_key = file(var.private_key)
    }

    inline = [
      "hostname"
    ]
  }
}
