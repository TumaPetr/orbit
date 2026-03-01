locals {
  git_url = "https://github.com/${var.github_organization}/${var.github_repository}.git"

  compiled_configurations = {
    for key, cfg in var.gitops_configurations : key => {
      namespace = cfg.namespace
      url       = local.git_url
      branch    = var.gitops_branch
      kustomizations = [for k in cfg.kustomizations : {
        name = k.name
        path = k.path
        # Nahrazení placeholderů z GitOps manifestů za reálná IDčka z kroku 02 
        substitute = length(k.substitute) > 0 ? k.substitute : {
          "KV_NAME"                = data.terraform_remote_state.hands_on.outputs.key_vault_name
          "PUBLIC_DOMAIN"          = data.terraform_remote_state.hands_on.outputs.public_domain
          "ESO_CLIENT_ID"          = data.terraform_remote_state.hands_on.outputs.eso_client_id
          "CERT_MANAGER_CLIENT_ID" = data.terraform_remote_state.hands_on.outputs.cert_manager_client_id
          "AZURE_SUBSCRIPTION_ID"  = data.azurerm_client_config.current.subscription_id
          "AZURE_TENANT_ID"        = data.azurerm_client_config.current.tenant_id
          "PG_FQDN"                = data.terraform_remote_state.hands_on.outputs.postgres_fqdn
          "INFRA_RG_NAME"          = data.terraform_remote_state.hands_on.outputs.infra_rg_name
          "PUBLIC_IP_ADDRESS"      = data.terraform_remote_state.hands_on.outputs.public_ip_address
          "PUBLIC_IP_NAME"         = data.terraform_remote_state.hands_on.outputs.public_ip_name
        }
      }]
    }
  }
}

module "flux_bootstrap" {
  source                = "../modules/flux_bootstrap"
  cluster_id            = data.azurerm_kubernetes_cluster.aks.id
  gitops_configurations = local.compiled_configurations
}
