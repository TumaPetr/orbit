module "rg_init" {
  source = "../modules/resource_group"
  config = {
    name     = "${var.prefix}-init-rg"
    location = var.location
    tags = {
      Environment = "Init"
      Purpose     = "Terraform State & Identities"
    }
  }
}

resource "azurerm_storage_account" "tfstate" {
  name                          = local.storage_account_name
  resource_group_name           = module.rg_init.name
  location                      = module.rg_init.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  shared_access_key_enabled     = false
  public_network_access_enabled = true
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"

  depends_on = [
    azurerm_role_assignment.tfstate_me
  ]
}

module "github_runner_identity" {
  source = "../modules/workload_identity"
  config = {
    name                = "${var.prefix}-github-runner"
    resource_group_name = module.rg_init.name
    location            = module.rg_init.location
    federation_name     = "${var.prefix}-github-federation"
    issuer_url          = "https://token.actions.githubusercontent.com"
    subject             = "repo:${var.github_organization}/${var.github_repository}:ref:refs/heads/main"
  }
}

resource "azurerm_role_assignment" "tfstate_me" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "tfstate_runner" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.github_runner_identity.principal_id
}

resource "azurerm_role_assignment" "subscription_contributor_runner" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = module.github_runner_identity.principal_id
}

resource "azurerm_role_assignment" "subscription_rbac_admin_runner" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Role Based Access Control Administrator"
  principal_id         = module.github_runner_identity.principal_id
}

# --- Uložení parametrů identity do GitHub Secrets pro GitHub Actions ---

resource "github_actions_secret" "azure_client_id" {
  repository      = var.github_repository
  secret_name     = "AZURE_CLIENT_ID"
  plaintext_value = module.github_runner_identity.client_id
}

resource "github_actions_secret" "azure_tenant_id" {
  repository      = var.github_repository
  secret_name     = "AZURE_TENANT_ID"
  plaintext_value = data.azurerm_client_config.current.tenant_id
}

resource "github_actions_secret" "azure_subscription_id" {
  repository      = var.github_repository
  secret_name     = "AZURE_SUBSCRIPTION_ID"
  plaintext_value = data.azurerm_client_config.current.subscription_id
}
