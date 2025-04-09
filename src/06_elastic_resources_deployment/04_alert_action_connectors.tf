resource "elasticstack_kibana_action_connector" "log" {
  count = var.alert_channels.log ? 1 : 0
  name = "log"
  connector_type_id = ".server-log"
}

resource "elasticstack_kibana_action_connector" "slack" {
  count =  var.alert_channels.slack ? 1 : 0
  name = "slack"
  connector_type_id = ".slack"
  secrets = jsonencode({
    webhookUrl = data.azurerm_key_vault_secret.slack_webhook_url.value
  })
}

resource "elasticstack_kibana_action_connector" "opsgenie" {
  count = var.alert_channels.opsgenie ? 1 : 0
  name = "opsgenie"
  connector_type_id = ".opsgenie"
  secrets = jsonencode({
    apiKey = data.azurerm_key_vault_secret.opsgenie_api_key.value
  })
  config = jsonencode({
    apiUrl = "https://api.opsgenie.com"
  })
}