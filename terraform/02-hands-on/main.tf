module "resource_groups" {
  source   = "../modules/resource_group"
  for_each = var.resource_groups

  config = {
    name     = "${var.prefix}-${each.value.name_suffix}-rg"
    location = var.location
    tags     = each.value.tags
  }
}


resource "azurerm_virtual_network" "main" {
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = module.resource_groups["infra"].location
  resource_group_name = module.resource_groups["infra"].name
}

resource "azurerm_subnet" "backend" {
  name                 = local.snet_backend_name
  resource_group_name  = module.resource_groups["infra"].name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "db" {
  name                 = local.snet_db_name
  resource_group_name  = module.resource_groups["infra"].name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "fs"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_network_security_group" "backend" {
  name                = local.nsg_backend_name
  location            = module.resource_groups["infra"].location
  resource_group_name = module.resource_groups["infra"].name
}

resource "azurerm_network_security_group" "db" {
  name                = local.nsg_db_name
  location            = module.resource_groups["infra"].location
  resource_group_name = module.resource_groups["infra"].name
}

resource "azurerm_network_security_rule" "allow_postgres_from_backend" {
  name                        = "AllowPostgresFromBackend"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5432"
  source_address_prefix       = "10.0.1.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = module.resource_groups["infra"].name
  network_security_group_name = azurerm_network_security_group.db.name
}

resource "azurerm_subnet_network_security_group_association" "backend" {
  subnet_id                 = azurerm_subnet.backend.id
  network_security_group_id = azurerm_network_security_group.backend.id
}

resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.db.id
}

# Public DNS Zone
resource "azurerm_dns_zone" "public" {
  name                = var.public_domain
  resource_group_name = module.resource_groups["dns"].name
}


# Private DNS Zones
resource "azurerm_private_dns_zone" "postgres" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = module.resource_groups["infra"].name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                  = "postgres-dns-link"
  resource_group_name   = module.resource_groups["infra"].name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = azurerm_virtual_network.main.id
}

resource "azurerm_private_dns_zone" "kv" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = module.resource_groups["infra"].name
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv" {
  name                  = "kv-dns-link"
  resource_group_name   = module.resource_groups["infra"].name
  private_dns_zone_name = azurerm_private_dns_zone.kv.name
  virtual_network_id    = azurerm_virtual_network.main.id
}
