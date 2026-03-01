resource "azurerm_user_assigned_identity" "this" {
  name                = var.config.name
  resource_group_name = var.config.resource_group_name
  location            = var.config.location
}

resource "azurerm_federated_identity_credential" "this" {
  name                = var.config.federation_name
  resource_group_name = var.config.resource_group_name
  audience            = var.config.audience
  issuer              = var.config.issuer_url
  parent_id           = azurerm_user_assigned_identity.this.id
  subject             = var.config.subject
}
