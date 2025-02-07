data "ec_deployment" "ec_deployment" {
  id = var.ec_deployment_id
}

# AD GROUP
data "azuread_group" "adgroup" {
  for_each     = var.role_mappings
  display_name = "${local.prefix_env_short}-${each.key}"
}

#
# 🔐 KV
#

data "azurerm_key_vault" "key_vault" {
  name                = "${local.subscription_product}-${local.prefix_env}-kv"
  resource_group_name = "${local.subscription_product}-${local.prefix_env}-sec-rg"
}

data "azurerm_key_vault_secret" "elasticsearch_api_key" {
  name         = "elasticsearch-api-key"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}
