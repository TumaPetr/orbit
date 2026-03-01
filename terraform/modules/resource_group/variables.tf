variable "config" {
  description = "Configuration object for Resource Group"
  type = object({
    name     = string
    location = string
    tags     = optional(map(string), {})
  })
}
