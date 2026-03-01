resource "azurerm_kubernetes_cluster_extension" "flux" {
  name           = var.extension_name
  cluster_id     = var.cluster_id
  extension_type = "microsoft.flux"
}

resource "azurerm_kubernetes_flux_configuration" "this" {
  for_each = var.gitops_configurations

  name       = each.key
  cluster_id = var.cluster_id
  namespace  = each.value.namespace

  git_repository {
    url             = each.value.url
    reference_type  = "branch"
    reference_value = each.value.branch
  }

  dynamic "kustomizations" {
    for_each = each.value.kustomizations
    content {
      name = kustomizations.value.name
      path = kustomizations.value.path
      
      # Předáváme zkompilované placeholdery přímo z Terraform configu!
      dynamic "post_build" {
        for_each = length(kustomizations.value.substitute) > 0 ? [1] : []
        content {
          substitute = kustomizations.value.substitute
        }
      }
    }
  }

  depends_on = [azurerm_kubernetes_cluster_extension.flux]
}
