locals {
  opsgenie_message_priority_mapping = {
    P1 = "Sev0"
    P2 = "Sev1"
    P3 = "Sev2"
    P4 = "Sev3"
    P5 = "Sev4"
  }

  alerts = {
    "cluster_health_red" = {
      name        = "Cluster health red"
      description = "${title(var.env)} cluster health is red"
      params = {
        threshold = var.alert_configuration.cluster_health.threshold
        duration  = var.alert_configuration.cluster_health.duration
        "filterQueryText" : "cluster_state.status : \"red\"",
        "filterQuery" : "{\"bool\":{\"should\":[{\"term\":{\"cluster_state.status\":{\"value\":\"red\"}}}],\"minimum_should_match\":1}}"
      }
      rule_type_id      = "monitoring_alert_cluster_health"
      interval          = "5m"
      opsgenie_priority = "P1"
      consecutive_runs  = 3
    },
    # "cluster_health_yellow" = {
    #   name        = "Cluster health yellow"
    #   description = "${title(var.env)} cluster health is yellow"
    #   params = {
    #     threshold = var.alert_configuration.cluster_health.threshold
    #     duration  = var.alert_configuration.cluster_health.duration
    #     "filterQueryText" : "cluster_state.status : \"yellow\"",
    #     "filterQuery" : "{\"bool\":{\"should\":[{\"term\":{\"cluster_state.status\":{\"value\":\"yellow\"}}}],\"minimum_should_match\":1}}"
    #   }
    #   rule_type_id      = "monitoring_alert_cluster_health"
    #   interval          = "5m"
    #   opsgenie_priority = "P4"
    #   consecutive_runs  = 3
    # }
    node_changed = {
      name        = "Nodes changed"
      description = "${title(var.env)} cluster nodes changed"
      params = {
        threshold = var.alert_configuration.node_changed.threshold
        duration  = var.alert_configuration.node_changed.duration
      }
      rule_type_id      = "monitoring_alert_nodes_changed"
      interval          = "5m"
      opsgenie_priority = "P3"
    },
    node_cpu_usage = {
      name        = "CPU Usage"
      description = "${title(var.env)} cluster nodes CPU usage is high"
      params = {
        threshold = var.alert_configuration.node_cpu_usage.threshold
        duration  = var.alert_configuration.node_cpu_usage.duration
      }
      rule_type_id      = "monitoring_alert_cpu_usage"
      interval          = "10m"
      opsgenie_priority = "P3"
    },
    node_disk_usage = {
      name        = "Disk Usage"
      description = "${title(var.env)} cluster nodes disk usage is high"
      params = {
        threshold = var.alert_configuration.node_disk_usage.threshold
        duration  = var.alert_configuration.node_disk_usage.duration
      }
      rule_type_id      = "monitoring_alert_disk_usage"
      interval          = "5m"
      opsgenie_priority = "P2"
      consecutive_runs  = 3
    },
    node_memory_usage = {
      name        = "Memory Usage (JVM)"
      description = "${title(var.env)} cluster nodes memory usage is high"
      params = {
        threshold = var.alert_configuration.node_memory_usage.threshold
        duration  = var.alert_configuration.node_memory_usage.duration
      }
      rule_type_id      = "monitoring_alert_jvm_memory_usage"
      interval          = "5m"
      opsgenie_priority = "P3"
    },
    index_shard_size = {
      name        = "Shard size"
      description = "${title(var.env)} cluster shard size is high"
      params = {
        indexPattern = "-.*"
        threshold    = var.alert_configuration.index_shard_size.threshold
      }
      rule_type_id      = "monitoring_shard_size"
      interval          = "60m"
      opsgenie_priority = "P3"
      consecutive_runs  = 3
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

  alert_delay = lookup(each.value, "consecutive_runs", null)


  #serverlog
  dynamic "actions" {
    for_each = var.alert_channels.log ? [1] : []
    content {
      id = elasticstack_kibana_action_connector.log[0].connector_id
      params = jsonencode({
        message = "{{context.internalShortMessage}}"
        level   = "info"
      })
      frequency {
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
        to      = local.alert_notification_emails,
        cc      = []
        subject = "Elastic ${var.env} ${each.value.name}"
      })
      frequency {
        notify_when = "onActionGroupChange"
        summary     = false
      }
    }
  }

  #email close
  dynamic "actions" {
    for_each = var.alert_channels.email ? [1] : []
    content {
      group = "recovered"
      id    = "elastic-cloud-email"
      params = jsonencode({
        message = "Recovered ${each.key}"
        to      = local.alert_notification_emails,
        cc      = []
        subject = "Elastic ${var.env} ${each.value.name} recovered"
      })
      frequency {
        notify_when = "onActionGroupChange"
        summary     = false
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
          message     = "[ ${upper(var.prefix)} ][ infra ][ Elastic ${local.opsgenie_message_priority_mapping[each.value.opsgenie_priority]} ] ${var.env} ${each.value.name}"
          priority    = each.value.opsgenie_priority
          description = "{{context.internalFullMessage}}"
        }
      })
      frequency {
        notify_when = "onActionGroupChange"
        summary     = false
      }
    }
  }

  #opsgenie close alert
  dynamic "actions" {
    for_each = var.alert_channels.opsgenie ? [1] : []
    content {
      group = "recovered"
      id    = elasticstack_kibana_action_connector.opsgenie[0].connector_id
      params = jsonencode({
        subAction = "closeAlert"
        subActionParams = {
          alias = "{{rule.id}}:{{alert.id}}"
        }
      })
      frequency {
        notify_when = "onActionGroupChange"
        summary     = false
      }
    }
  }

  #slack
  dynamic "actions" {
    for_each = var.alert_channels.slack ? [1] : []
    content {
      id = elasticstack_kibana_action_connector.slack[0].connector_id
      params = jsonencode({
        "message" : "Cluster ${var.env}:\n\n{{context.internalFullMessage}}"
      })
      frequency {
        notify_when = "onActionGroupChange"
        summary     = false
      }
    }
  }

  #slack close
  dynamic "actions" {
    for_each = var.alert_channels.slack ? [1] : []
    content {
      group = "recovered"
      id    = elasticstack_kibana_action_connector.slack[0].connector_id
      params = jsonencode({
        "message" : "Cluster ${var.env}:\n\n${each.key} recovered"
      })
      frequency {
        notify_when = "onActionGroupChange"
        summary     = false
      }
    }
  }
}