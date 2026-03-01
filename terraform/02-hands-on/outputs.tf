output "key_vault_uri" {
  value       = azurerm_key_vault.main.vault_uri
  description = "URI of the provisioned Key Vault"
}

output "postgres_fqdn" {
  value       = azurerm_postgresql_flexible_server.main.fqdn
  description = "Target address to reach the PostgreSQL DB"
}

output "public_name_servers" {
  value       = azurerm_dns_zone.public.name_servers
  description = "Name servers for delegating your domain from the registrar to Azure"
}

output "key_vault_name" {
  value       = azurerm_key_vault.main.name
  description = "KeyVault name"
}

output "dns_rg_name" {
  value       = module.resource_groups["dns"].name
  description = "Resource Group DNS Zóny"
}

output "public_domain" {
  value       = var.public_domain
  description = "Hodnota domény z variables"
}

output "eso_client_id" {
  value       = module.workload_identities["eso"].client_id
  description = "Client ID od ESO Workload Identity"
}

output "external_dns_client_id" {
  value       = module.workload_identities["external_dns"].client_id
  description = "Client ID od ExternalDNS Workload Identity"
}

output "cert_manager_client_id" {
  value       = module.workload_identities["cert_manager"].client_id
  description = "Client ID od CertManager Workload Identity"
}
