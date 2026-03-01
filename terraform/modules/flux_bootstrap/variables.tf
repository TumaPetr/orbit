variable "cluster_id" {
  type        = string
  description = "The ID of the AKS Cluster"
}

variable "extension_name" {
  type        = string
  default     = "flux"
  description = "Name of the Flux extension resource"
}

variable "gitops_configurations" {
  description = "Map of Flux Configurations. Allows multiple repos or multiple kustomizations to be managed cleanly."
  type = map(object({
    namespace = string
    url       = string
    branch    = string
    kustomizations = list(object({
      name       = string
      path       = string
      substitute = optional(map(string), {})
      depends_on = optional(list(string), [])
    }))
  }))
}
