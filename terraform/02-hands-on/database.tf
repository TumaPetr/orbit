resource "azurerm_postgresql_flexible_server" "main" {
  name                = local.db_name
  resource_group_name = module.resource_groups["infra"].name
  location            = module.resource_groups["infra"].location

  version    = var.db_config.version
  storage_mb = var.db_config.storage_mb
  sku_name   = var.db_config.sku_name

  delegated_subnet_id    = azurerm_subnet.db.id
  private_dns_zone_id    = azurerm_private_dns_zone.postgres.id
  administrator_login    = "pgadmin"
  administrator_password = random_password.pg_admin.result
  zone                   = "1"

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.postgres
  ]
}

resource "azurerm_postgresql_flexible_server_database" "databases" {
  for_each  = toset(var.db_config.databases)
  name      = each.key
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.utf8"
  charset   = "utf8"
}
