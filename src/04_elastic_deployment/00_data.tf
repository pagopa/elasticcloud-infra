#
# 🔐 KV
#

data "azurerm_key_vault" "key_vault" {
  name                = var.kv_name_org_ec
  resource_group_name = var.kv_rg_org_ec
}

data "azurerm_key_vault_secret" "elastic_cloud_api_key" {
  name         = "elastic-cloud-api-key"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azuread_application" "ec_application" {
  for_each = toset(var.shared_env)

  #display_name = "${each.key}-elasticcloud-app"
  display_name = "ElasticCloud"
}
