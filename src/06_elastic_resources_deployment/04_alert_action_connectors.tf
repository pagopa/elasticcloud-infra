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

resource "elasticstack_kibana_action_connector" "jsm" {
  count             = var.alert_channels.jsm ? 1 : 0
  name              = "infra-jsm"
  connector_type_id = ".jira-service-management"
  secrets = jsonencode({
    apiKey = data.azurerm_key_vault_secret.jsm_api_key.value
  })
  config = jsonencode({
    apiUrl = "https://api.atlassian.com"
  })
}

resource "elasticstack_kibana_action_connector" "cloudo" {
  count             = var.alert_channels.cloudo ? 1 : 0
  name              = "infra-cloudo"
  connector_type_id = ".webhook"
  secrets           = jsonencode({ webhookUrl = data.azurerm_key_vault_secret.cloudo_webhook_url.value })
  config = jsonencode(
    {
      hasAuth = false,
      method  = "post",
      headers = {
        "ocp-apim-subscription-key" = data.azurerm_key_vault_secret.cloudo_subscription_key.value
        "x-cloudo-key"              = data.azurerm_key_vault_secret.cloudo_api_key.value
      },
      url = data.azurerm_key_vault_secret.cloudo_webhook_url.value
    }
  )
}

