data "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  resource_group_name = "${var.prefix}-aks-rg"
}

data "terraform_remote_state" "hands_on" {
  backend = "azurerm"
  config = {
    resource_group_name  = "orbit-init-rg"
    storage_account_name = "orbittfstate119d6"
    container_name       = "tfstate"
    key                  = "hands-on.tfstate"
    use_azuread_auth     = true
    subscription_id      = "f13028bb-9637-4b8b-b7f0-4da198a714bb"
  }
}

data "azurerm_client_config" "current" {}
