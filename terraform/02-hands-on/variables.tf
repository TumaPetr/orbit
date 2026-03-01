variable "prefix" {
  type        = string
  description = "Prefix for all resources"
}

variable "location" {
  type        = string
  description = "Azure Region"
  default     = "swedencentral"

  validation {
    condition     = contains(["swedencentral", "polandcentral"], var.location)
    error_message = "Zvolená lokace musí být 'swedencentral' nebo 'polandcentral'."
  }
}

variable "domain_name_label" {
  type        = string
  description = "Label for the Azure Cloudapp FQDN."
}

variable "resource_groups" {
  type = map(object({
    name_suffix = string
    tags        = map(string)
  }))
  description = "Map of resource groups to create via for_each"
}

variable "db_config" {
  description = "Postgres DB parameters"
  type = object({
    version    = string
    sku_name   = string
    storage_mb = number
    databases  = list(string)
  })
}

variable "aks_config" {
  description = "AKS Node Pool config"
  type = object({
    sku_tier        = string
    node_count      = number
    vm_size         = string
    os_disk_size_gb = number
  })
  validation {
    condition     = var.aks_config.node_count >= 1 && var.aks_config.node_count <= 5
    error_message = "Maximální velikost pro demo je 5 nodů."
  }
}

variable "workload_identities" {
  type = map(object({
    ns = string
    sa = string
  }))
  description = "Map of Workload Identities and their Service Accounts"
}

variable "additional_admin_object_id" {
  type        = string
  description = "Admin ID pre extra access"
  default     = ""
}
