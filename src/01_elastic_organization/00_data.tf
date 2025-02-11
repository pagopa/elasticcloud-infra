#
# 🔐 KV
#

data "azurerm_key_vault" "key_vault" {
  name                = "${local.project}-kv"
  resource_group_name = "${local.project}-sec-rg"
}

data "azurerm_key_vault_secret" "elastic_cloud_api_key" {
  name         = "elastic-cloud-api-key"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}
