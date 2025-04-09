locals {
  alerts = {
    "cluster_health" = {
      name        = "Cluster health"
      params = {
        threshold = 85
        duration = "1h"
        "filterQueryText": "cluster_state.status : \"red\"",
        "filterQuery": "{\"bool\":{\"should\":[{\"term\":{\"cluster_state.status\":{\"value\":\"red\"}}}],\"minimum_should_match\":1}}"
      }
      rule_type_id = "monitoring_alert_cluster_health"
      interval     = "1m"
      opsgenie_priority     = "P1"
      description = "${title(var.env)} cluster health is red"
    },
    node_changed = {
      name        = "Nodes changed"
      params = {
        threshold = 85
        duration = "1h"
      }
      rule_type_id = "monitoring_alert_nodes_changed"
      interval     = "5m"
      opsgenie_priority     = "P2"
      description = "${title(var.env)} cluster nodes changed"
    },
    node_cpu_usage = {
      name        = "CPU Usage"
      params = {
        threshold = 90
        duration = "10m"
      }
      rule_type_id = "monitoring_alert_cpu_usage"
      interval     = "5m"
      opsgenie_priority     = "P2"
      description = "${title(var.env)} cluster nodes CPU usage is high"
    },
    node_disk_usage = {
      name        = "Disk Usage"
      params = {
        threshold = 95
        duration = "5m"
      }
      rule_type_id = "monitoring_alert_disk_usage"
      interval     = "1m"
      opsgenie_priority     = "P2"
      description = "${title(var.env)} cluster nodes disk usage is high"
    },
    node_memory_usage = {
      name        = "Memory Usage (JVM)"
      params = {
        threshold = 85
        duration = "5m"
      }
      rule_type_id = "monitoring_alert_jvm_memory_usage"
      interval     = "1m"
      opsgenie_priority     = "P2"
      description = "${title(var.env)} cluster nodes memory usage is high"
    },
    index_shard_size = {
      name        = "Shard size"
      params = {
        indexPattern = "-.*"
        threshold = 55
      }
      rule_type_id = "monitoring_shard_size"
      interval     = "1m"
      opsgenie_priority     = "P2"
      description = "${title(var.env)} cluster shard size is high"
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
          message = "${var.env} ${each.value.name}"
          priority = each.value.opsgenie_priority
          description = each.value.description
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