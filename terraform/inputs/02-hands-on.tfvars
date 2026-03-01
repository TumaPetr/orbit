prefix        = "orbit"
location      = "swedencentral"
domain_name_label = "demo-orbit-petrtuma"

resource_groups = {
  infra = {
    name_suffix = "infra"
    tags        = { Environment = "Demo", Workload = "Infrastructure" }
  }
  aks = {
    name_suffix = "aks"
    tags        = { Environment = "Demo", Workload = "AKS Cluster" }
  }
}

db_config = {
  version    = "14"
  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768
  databases  = ["appdb", "authdb"]
}

aks_config = {
  sku_tier        = "Free"
  node_count      = 2
  vm_size         = "Standard_B2s_v2"
  os_disk_size_gb = 50
}

workload_identities = {
  eso = {
    ns = "external-secrets"
    sa = "external-secrets"
  }
  cert_manager = {
    ns = "cert-manager"
    sa = "cert-manager"
  }
}
