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
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "orbit-init-rg"
    storage_account_name = "orbittfstate119d6"
    container_name       = "tfstate"
    key                  = "init.tfstate"
    use_azuread_auth     = true
    subscription_id      = "f13028bb-9637-4b8b-b7f0-4da198a714bb"
  }
}
provider "azurerm" {
  features {}
  storage_use_azuread = true
}

provider "github" {
  owner = var.github_organization
  token = var.github_token
}
