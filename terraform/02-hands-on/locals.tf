locals {
  vnet_name = "${var.prefix}-vnet"
  db_name   = "${var.prefix}-pg-server"
  aks_name  = "${var.prefix}-aks"

  snet_backend_name = "${var.prefix}-snet-backend"
  snet_db_name      = "${var.prefix}-snet-db"

  nsg_backend_name = "${var.prefix}-nsg-backend"
  nsg_db_name      = "${var.prefix}-nsg-db"

  admin_principal_id = var.additional_admin_object_id != "" ? var.additional_admin_object_id : data.azurerm_client_config.current.object_id

  kv_suffix = substr(md5(var.prefix), 0, 5)
  kv_name   = "${var.prefix}-kv-${local.kv_suffix}"
}
