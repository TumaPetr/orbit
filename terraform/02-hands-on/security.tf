resource "random_password" "pg_admin" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>?"
}

resource "azurerm_key_vault" "main" {
  name                       = local.kv_name
  location                   = module.resource_groups["infra"].location
  resource_group_name        = module.resource_groups["infra"].name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
}

resource "azurerm_private_endpoint" "kv" {
  name                = "${local.kv_name}-pe"
  location            = module.resource_groups["infra"].location
  resource_group_name = module.resource_groups["infra"].name
  subnet_id           = azurerm_subnet.backend.id

  private_service_connection {
    name                           = "${local.kv_name}-privateserviceconnection"
    private_connection_resource_id = azurerm_key_vault.main.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "kv-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.kv.id]
  }
}

resource "azurerm_role_assignment" "tf_kv_admin" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = local.admin_principal_id
}

resource "azurerm_role_assignment" "tf_runner_kv_admin" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "pg_admin_password" {
  name         = "postgres-admin-password"
  value        = random_password.pg_admin.result
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [
    azurerm_role_assignment.tf_runner_kv_admin
  ]
}
# Workload Identities as a map
module "workload_identities" {
  source   = "../modules/workload_identity"
  for_each = var.workload_identities

  config = {
    name                = "${var.prefix}-${each.key}-uami"
    resource_group_name = module.resource_groups["aks"].name
    location            = module.resource_groups["aks"].location
    federation_name     = "${var.prefix}-${each.key}-federation"
    issuer_url          = azurerm_kubernetes_cluster.main.oidc_issuer_url
    subject             = "system:serviceaccount:${each.value.ns}:${each.value.sa}"
  }
}

resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = module.resource_groups["infra"].id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

resource "azurerm_role_assignment" "eso_kv_officer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = module.workload_identities["eso"].principal_id
}

