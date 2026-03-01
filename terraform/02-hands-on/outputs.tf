output "key_vault_uri" {
  value       = azurerm_key_vault.main.vault_uri
  description = "URI of the provisioned Key Vault"
}

output "postgres_fqdn" {
  value       = azurerm_postgresql_flexible_server.main.fqdn
  description = "Target address to reach the PostgreSQL DB"
}

output "key_vault_name" {
  value       = azurerm_key_vault.main.name
  description = "KeyVault name"
}

output "public_domain" {
  value       = azurerm_public_ip.envoy_pip.fqdn
  description = "Vygenerované FQDN z Public IP"
}

output "public_ip_address" {
  value       = azurerm_public_ip.envoy_pip.ip_address
  description = "Statická IP adresa Envoy Gateway LoadBalanceru"
}

output "public_ip_name" {
  value       = azurerm_public_ip.envoy_pip.name
  description = "Název Statické IP adresy Envoy Gateway LoadBalanceru"
}

output "infra_rg_name" {
  value       = module.resource_groups["infra"].name
  description = "Resource group infrastructure"
}

output "eso_client_id" {
  value       = module.workload_identities["eso"].client_id
  description = "Client ID od ESO Workload Identity"
}

output "cert_manager_client_id" {
  value       = module.workload_identities["cert_manager"].client_id
  description = "Client ID od CertManager Workload Identity"
}
