resource "elasticstack_kibana_alerting_rule" "cluster_health" {
  name        = "Cluster health"
  consumer    = "monitoring"
  notify_when = null
  params = jsonencode({
    threshold           = 85
    duration = "1h"
    "filterQueryText": "cluster_state.status : \"red\"",
    "filterQuery": "{\"bool\":{\"should\":[{\"term\":{\"cluster_state.status\":{\"value\":\"red\"}}}],\"minimum_should_match\":1}}"
  })
  rule_type_id = "monitoring_alert_cluster_health"
  interval     = "1m"
  enabled      = true

  dynamic "actions" {
    for_each = var.alert_channels.log ? [1] : []
    content {
        id = elasticstack_kibana_action_connector.log.connector_id
        params = jsonencode({
            message = "{{context.internalShortMessage}}"
            level   = "info"
        })
        frequency  {
            notify_when = "onThrottleInterval"
            throttle    = "24h"
            summary     = false
        }
    }
  }

  dynamic "actions" {
    for_each = var.alert_channels.email ? [1] : []
    content {
      id = "elastic-cloud-email"
      params = jsonencode({
        message = "{{context.internalFullMessage}}"
        to = [
          "marco.mari@pagopa.it",
          "umberto.coppolabottazzi@pagopa.it",
          "matteo.alongi@pagopa.it"
        ],
        cc = []
        subject = "Elastic cluster health"
      })
      frequency  {
        notify_when = "onActionGroupChange"
        summary = false
      }
    }
  }

  dynamic "actions" {
    for_each = var.alert_channels.opsgenie ? [1] : []
    content {
      id = elasticstack_kibana_action_connector.opsgenie.connector_id
      params = jsonencode({
        subAction = "createAlert"
        subActionParams = {
          alias = "{{rule.id}}:{{alert.id}}"
          tags = [
            "{{rule.tags}}"
          ],
          message = "Sev2 Staging cluster health"
          priority = "P3"
          description = "Staging cluster health is red"
        }
      })
      frequency {
        notify_when = "onActionGroupChange"
        summary = false
      }
    }
  }

  dynamic "actions" {
    for_each = var.alert_channels.slack ? [1] : []
    content {
      id = elasticstack_kibana_action_connector.slack.connector_id
      params = jsonencode({
        "message": "Cluster ${var.env}:\n\n{{context.internalFullMessage}}"
      })
      frequency {
        notify_when = "onActionGroupChange"
        summary = false
      }
    }
  }
}
