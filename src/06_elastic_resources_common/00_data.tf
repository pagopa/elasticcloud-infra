data "ec_deployments" "deployments" {
  name_prefix = var.deployment_name
}

data "ec_deployment" "deployment" {
  id = data.ec_deployments.deployments.deployments[0].deployment_id
}

# AD GROUP
data "azuread_group" "adgroup" {
  for_each = var.role_mappings

  display_name = each.key
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

data "azurerm_key_vault" "key_vault_org" {
  name                = "${local.subscription_product}-ec-org-kv"
  resource_group_name = "${local.subscription_product}-ec-org-sec-rg"
}

data "azurerm_key_vault_secret" "elastic_cloud_api_key" {
  name         = "elastic-cloud-api-key"
  key_vault_id = data.azurerm_key_vault.key_vault_org.id
}
