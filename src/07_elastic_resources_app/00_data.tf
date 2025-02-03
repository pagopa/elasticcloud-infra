data "ec_deployment" "ec_deployment" {
  id = var.ec_deployment_id
}

data "elasticstack_fleet_integration" "kubernetes" {
  name = "kubernetes"
}

data "elasticstack_fleet_integration" "system" {
  name = "system"
}

data "azurerm_key_vault" "target_key_vault" {
  name                = "${local.subscription_prefix}-${var.prefix}-${var.env}-kv"
  resource_group_name = "${local.subscription_prefix}-${var.prefix}-${var.env}-sec-rg"
}

data "azurerm_key_vault_secret" "elasticsearch_api_key" {
  key_vault_id = data.azurerm_key_vault.target_key_vault.id
  name         = "elasticsearch-api-key"

}
