variable "prefix" {
  type    = string
  default = "orbit"
}

variable "location" {
  type    = string
  default = "swedencentral"

  validation {
    condition     = contains(["swedencentral", "polandcentral"], var.location)
    error_message = "Zvolená lokace musí být 'swedencentral' nebo 'polandcentral', protože poskytují nejlepší ceny napříč všemi službami pro demo."
  }
}

variable "github_organization" {
  type    = string
  default = "TumaPetr"
}

variable "github_repository" {
  type    = string
  default = "orbit"
}

variable "github_token" {
  type        = string
  description = "GitHub Personal Access Token pro zápis secrets do repozitáře"
  sensitive   = true
}
