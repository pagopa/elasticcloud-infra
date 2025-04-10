data "ec_deployments" "deployments" {
  name_prefix = var.deployment_name
}

data "ec_deployment" "deployment" {
  id = data.ec_deployments.deployments.deployments[0].deployment_id
}

#
# 🔐 KV
#


data "azurerm_key_vault" "key_vault" {
  name                = "${local.subscription_prefix}-${var.elastic_apikey_env_short}-${var.prefix}-${var.elastic_apikey_env}-kv"
  resource_group_name = "${local.subscription_prefix}-${var.elastic_apikey_env_short}-${var.prefix}-${var.elastic_apikey_env}-sec-rg"
}

data "azurerm_key_vault_secret" "elasticsearch_api_key" {
  name         = "elasticsearch-api-key"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "opsgenie_api_key" {
  name         = "opsgenie-api-key"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "slack_webhook_url" {
  name         = "slack-webhook-url"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault" "key_vault_org" {
  name                = var.kv_name_org_ec
  resource_group_name = var.kv_rg_org_ec
}

data "azurerm_key_vault_secret" "elastic_cloud_api_key" {
  name         = "elastic-cloud-api-key"
  key_vault_id = data.azurerm_key_vault.key_vault_org.id
}
