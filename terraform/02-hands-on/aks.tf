resource "azurerm_kubernetes_cluster" "main" {
  name                = local.aks_name
  location            = module.resource_groups["aks"].location
  resource_group_name = module.resource_groups["aks"].name
  dns_prefix          = local.aks_name

  sku_tier = var.aks_config.sku_tier

  default_node_pool {
    name            = "default"
    node_count      = var.aks_config.node_count
    vm_size         = var.aks_config.vm_size
    os_disk_size_gb = var.aks_config.os_disk_size_gb
    vnet_subnet_id  = azurerm_subnet.backend.id
  }

  identity {
    type = "SystemAssigned"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.1.0.0/16"
    dns_service_ip = "10.1.0.10"
  }
}


