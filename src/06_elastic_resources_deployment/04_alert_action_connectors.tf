resource "elasticstack_kibana_action_connector" "log" {
  count             = var.alert_channels.log ? 1 : 0
  name              = "log"
  connector_type_id = ".server-log"
}

resource "elasticstack_kibana_action_connector" "slack" {
  count             = var.alert_channels.slack ? 1 : 0
  name              = "slack"
  connector_type_id = ".slack"
  secrets = jsonencode({
    webhookUrl = data.azurerm_key_vault_secret.slack_webhook_url.value
  })
}

resource "elasticstack_kibana_action_connector" "opsgenie" {
  count             = var.alert_channels.opsgenie ? 1 : 0
  name              = "opsgenie"
  connector_type_id = ".opsgenie"
  secrets = jsonencode({
    apiKey = data.azurerm_key_vault_secret.opsgenie_api_key.value
  })
  config = jsonencode({
    apiUrl = "https://api.opsgenie.com"
  })
}


resource "elasticstack_kibana_action_connector" "app_connector" {
  for_each          = var.app_connectors
  name              = each.key
  connector_type_id = ".${each.value.type}"
  secrets = jsonencode(
    each.value.type == "opsgenie" ? { apiKey = data.azurerm_key_vault_secret.app_connector_secret_key[each.key].value } : { webhookUrl = data.azurerm_key_vault_secret.app_connector_secret_key[each.key].value }
  )
  config = each.value.type == "opsgenie" ? jsonencode({ apiUrl = "https://api.opsgenie.com" }) : null
}