resource "azurerm_postgresql_server" "db_server" {
  name                = "${var.humber_id}-postgres"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = "B_Gen5_1"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  version                      = "11"
  ssl_enforcement_enabled      = true

  tags = var.tags
}

resource "azurerm_postgresql_database" "db" {
  name                = "db${var.humber_id}"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.db_server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}
