variable "config" {
  description = "Configuration object for Workload Identity"
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    federation_name     = string
    issuer_url          = string
    subject             = string
    audience            = optional(list(string), ["api://AzureADTokenExchange"])
  })
}
