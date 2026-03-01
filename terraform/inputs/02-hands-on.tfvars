prefix        = "orbit"
location      = "swedencentral"
public_domain = "moje-demo-adresa.cz"

resource_groups = {
  infra = {
    name_suffix = "infra"
    tags        = { Environment = "Demo", Workload = "Infrastructure" }
  }
  aks = {
    name_suffix = "aks"
    tags        = { Environment = "Demo", Workload = "AKS Cluster" }
  }
  dns = {
    name_suffix = "dns"
    tags        = { Environment = "Demo", Workload = "Public DNS" }
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
  node_count      = 1
  vm_size         = "Standard_B2s"
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
  external_dns = {
    ns = "external-dns"
    sa = "external-dns"
  }
}
