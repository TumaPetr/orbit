variable "prefix" {
  type        = string
  description = "Prefix resources"
  default     = "orbit"
}

variable "github_organization" {
  type        = string
  description = "Github organization"
  default     = "TumaPetr"
}

variable "github_repository" {
  type        = string
  description = "Github repository"
  default     = "orbit"
}

variable "gitops_branch" {
  type    = string
  default = "main"
}

variable "gitops_configurations" {
  description = "Map of Flux Kustomizations to deploy"
  type = map(object({
    namespace = string
    kustomizations = list(object({
      name       = string
      path       = string
      substitute = optional(map(string), {})
    }))
  }))
}
