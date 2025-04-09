resource "elasticstack_kibana_action_connector" "log" {
  name = "log"
  connector_type_id = ".server-log"
}

resource "elasticstack_kibana_action_connector" "slack" {
  name = "slack"
  connector_type_id = ".slack"
  secrets = jsonencode({
    webhookUrl = data.azurerm_key_vault_secret.slack_webhook_url.value
  })
}

resource "elasticstack_kibana_action_connector" "opsgenie" {
  name = "opsgenie"
  connector_type_id = ".opsgenie"
  secrets = jsonencode({
    apiKey = data.azurerm_key_vault_secret.opsgenie_api_key.value
  })
  config = jsonencode({
    apiUrl = "https://api.opsgenie.com"
  })
}