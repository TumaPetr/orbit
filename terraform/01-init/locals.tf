locals {
  storage_account_name = "${var.prefix}tfstate${substr(md5(var.prefix), 0, 5)}"
}
