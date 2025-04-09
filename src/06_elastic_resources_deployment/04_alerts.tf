locals {
  opsgenie_message_priority_mapping = {
    P1 = "Sev0"
    P2 = "Sev1"
    P3 = "Sev2"
    P4 = "Sev3"
    P5 = "Sev4"
  }

  alerts = {
    "cluster_health" = {
      name        = "Cluster health"
      description = "${title(var.env)} cluster health is red"
      params = {
        threshold = 85
        duration = "1h"
        "filterQueryText": "cluster_state.status : \"red\"",
        "filterQuery": "{\"bool\":{\"should\":[{\"term\":{\"cluster_state.status\":{\"value\":\"red\"}}}],\"minimum_should_match\":1}}"
      }
      rule_type_id = "monitoring_alert_cluster_health"
      interval     = "1m"
      opsgenie_priority     = "P1"
    },
    node_changed = {
      name        = "Nodes changed"
      description = "${title(var.env)} cluster nodes changed"
      params = {
        threshold = 85
        duration = "1h"
      }
      rule_type_id = "monitoring_alert_nodes_changed"
      interval     = "5m"
      opsgenie_priority     = "P2"
    },
    node_cpu_usage = {
      name        = "CPU Usage"
      description = "${title(var.env)} cluster nodes CPU usage is high"
      params = {
        threshold = 90
        duration = "10m"
      }
      rule_type_id = "monitoring_alert_cpu_usage"
      interval     = "5m"
      opsgenie_priority     = "P2"
    },
    node_disk_usage = {
      name        = "Disk Usage"
      description = "${title(var.env)} cluster nodes disk usage is high"
      params = {
        threshold = 95
        duration = "5m"
      }
      rule_type_id = "monitoring_alert_disk_usage"
      interval     = "1m"
      opsgenie_priority     = "P2"
    },
    node_memory_usage = {
      name        = "Memory Usage (JVM)"
      description = "${title(var.env)} cluster nodes memory usage is high"
      params = {
        threshold = 70
        duration = "10m"
      }
      rule_type_id = "monitoring_alert_jvm_memory_usage"
      interval     = "5m"
      opsgenie_priority     = "P2"
    },
    index_shard_size = {
      name        = "Shard size"
      description = "${title(var.env)} cluster shard size is high"
      params = {
        indexPattern = "-.*"
        threshold = 55
      }
      rule_type_id = "monitoring_shard_size"
      interval     = "1m"
      opsgenie_priority     = "P2"
    }
    # Add other alerts here...
  }
}

resource "elasticstack_kibana_alerting_rule" "alert" {
  for_each = local.alerts

  name         = each.value.name
  consumer     = "monitoring"
  notify_when  = null
  params       = jsonencode(each.value.params)
  rule_type_id = each.value.rule_type_id
  interval     = each.value.interval
  enabled      = true

  #serverlog
  dynamic "actions" {
    for_each = var.alert_channels.log ? [1] : []
    content {
        id = elasticstack_kibana_action_connector.log[0].connector_id
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

  #email
  dynamic "actions" {
    for_each = var.alert_channels.email ? [1] : []
    content {
      id = "elastic-cloud-email"
      params = jsonencode({
        message = "{{context.internalFullMessage}}"
        to = local.alert_notification_emails,
        cc = []
        subject = "Elastic ${var.env} ${each.value.name}"
      })
      frequency  {
        notify_when = "onActionGroupChange"
        summary = false
      }
    }
  }

  #opsgenie create
  dynamic "actions" {
    for_each = var.alert_channels.opsgenie ? [1] : []
    content {
      id = elasticstack_kibana_action_connector.opsgenie[0].connector_id
      params = jsonencode({
        subAction = "createAlert"
        subActionParams = {
          alias = "{{rule.id}}:{{alert.id}}"
          tags = [
            "{{rule.tags}}"
          ],
          message = "[PAGOPA-infra][Elastic ${local.opsgenie_message_priority_mapping[each.value.opsgenie_priority]}] ${var.env} ${each.value.name}"
          priority = each.value.opsgenie_priority
          description = "{{context.internalFullMessage}}"
        }
      })
      frequency {
        notify_when = "onActionGroupChange"
        summary = false
      }
    }
  }

  #opsgenie close alert
  dynamic "actions" {
    for_each = var.alert_channels.opsgenie ? [1] : []
    content {
      group = "recovered"
      id = elasticstack_kibana_action_connector.opsgenie[0].connector_id
      params = jsonencode({
        subAction = "closeAlert"
        subActionParams = {
          alias = "{{rule.id}}:{{alert.id}}"
        }
      })
      frequency {
        notify_when = "onActionGroupChange"
        summary = false
      }
    }
  }

  #slack
  dynamic "actions" {
    for_each = var.alert_channels.slack ? [1] : []
    content {
      id = elasticstack_kibana_action_connector.slack[0].connector_id
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