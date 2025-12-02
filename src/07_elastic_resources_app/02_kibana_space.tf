resource "elasticstack_kibana_space" "kibana_space" {
  for_each          = local.spaces
  space_id          = "${each.value}-${var.env}"
  name              = "${each.value}-${var.env}"
  description       = "Space for ${each.value}-${var.env}"
  disabled_features = []
}



resource "elasticstack_kibana_action_connector" "app_connector" {
  for_each          = local.space_connectors
  name              = each.value.connector
  connector_type_id = ".${each.value.type}"
  secrets = each.value.type != "webhook" ? jsonencode(
    each.value.type == "opsgenie" ? { apiKey = data.azurerm_key_vault_secret.app_connector_secret_key[each.value.connector].value } : { webhookUrl = data.azurerm_key_vault_secret.app_connector_secret_key[each.value.connector].value }
  ) : jsonencode({})
  config   = var.app_connectors[each.value.connector].type == "opsgenie" ? jsonencode({ apiUrl = "https://api.opsgenie.com" }) : (var.app_connectors[each.value.connector].type == "webhook" ? jsonencode({ hasAuth = true, method = "post", url = data.azurerm_key_vault_secret.app_connector_secret_key[each.value.connector].value }) : null)
  space_id = elasticstack_kibana_space.kibana_space[each.value.space_name].space_id
}