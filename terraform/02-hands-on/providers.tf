terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.62.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  backend "azurerm" {
    resource_group_name  = "orbit-init-rg"
    storage_account_name = "orbittfstate119d6"
    container_name       = "tfstate"
    key                  = "hands-on.tfstate"
    use_azuread_auth     = true
    subscription_id      = "f13028bb-9637-4b8b-b7f0-4da198a714bb"
  }
}
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  storage_use_azuread = true
}
