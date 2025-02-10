data "ec_deployments" "deployments" {
  name_prefix = var.deployment_name
}

data "ec_deployment" "deployment" {
  id = data.ec_deployments.deployments.deployments[0].deployment_id
}

data "elasticstack_fleet_integration" "kubernetes" {
  name = "kubernetes"
}

data "elasticstack_fleet_integration" "system" {
  name = "system"
}

data "azurerm_key_vault" "target_key_vault" {
  name                = "${local.subscription_product}-${local.prefix_env}-kv"
  resource_group_name = "${local.subscription_product}-${local.prefix_env}-sec-rg"
}

data "azurerm_key_vault_secret" "elasticsearch_api_key" {
  key_vault_id = data.azurerm_key_vault.target_key_vault.id
  name         = "elasticsearch-api-key"

}

data "azurerm_key_vault" "key_vault_org" {
  name                = "${local.subscription_product}-ec-org-kv"
  resource_group_name = "${local.subscription_product}-ec-org-sec-rg"
}

data "azurerm_key_vault_secret" "elastic_cloud_api_key" {
  name         = "elastic-cloud-api-key"
  key_vault_id = data.azurerm_key_vault.key_vault_org.id
}
