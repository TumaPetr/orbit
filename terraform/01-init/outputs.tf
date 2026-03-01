output "resource_group_id" {
  value       = module.rg_init.id
  description = "ID of the init Resource Group"
}

output "storage_account_name" {
  value       = azurerm_storage_account.tfstate.name
  description = "Name of the Storage Account for TF state"
}

output "github_runner_client_id" {
  value       = module.github_runner_identity.client_id
  description = "Client ID of the User Assigned Managed Identity for GitHub Actions. Use this to login."
}
