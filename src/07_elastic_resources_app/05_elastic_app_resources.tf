locals {
  slack_connector_names   = [for connector_name, connector in var.app_connectors : connector_name if connector.type == "slack"]
  jsm_connector_names     = [for connector_name, connector in var.app_connectors : connector_name if connector.type == "jira-service-management"]
  webhook_connector_names = [for connector_name, connector in var.app_connectors : connector_name if connector.type == "webhook"]
}


module "app_resources" {
  source   = "./.terraform/modules/__v4__/elastic_app_resources"
  for_each = local.configurations

  target_name     = var.prefix
  configuration   = each.value.conf
  target_env      = var.env
  space_id        = elasticstack_kibana_space.kibana_space[each.value.space_name].space_id
  space_name      = each.value.space_name
  system_space_id = elasticstack_kibana_space.kibana_system_space.space_id
  ilm_name        = var.ilm[each.key]

  library_index_custom_path    = "${path.module}/default_library/index_component"
  library_index_package_path   = "${path.module}/default_library/index_component"
  library_ingest_pipeline_path = "${path.module}/default_library/ingest_pipeline"

  default_custom_component_name = "basic-only-lifecycle@custom"

  query_folder     = each.value.query_folder
  dashboard_folder = each.value.dashboard_folder
  alert_folder     = each.value.alert_folder

  alert_channels = {
    email = {
      enabled    = var.alert_channels.email
      recipients = var.email_recipients
    }
    slack = {
      enabled = var.alert_channels.slack
      connectors = {
        for connector_name in local.slack_connector_names : connector_name => elasticstack_kibana_action_connector.app_connector[local.space_connectors["${each.value.space_name}-${connector_name}"].key].connector_id
      }
    }
    jsm = {
      enabled = var.alert_channels.jsm
      connectors = {
        for connector_name in local.jsm_connector_names : connector_name => elasticstack_kibana_action_connector.app_connector[local.space_connectors["${each.value.space_name}-${connector_name}"].key].connector_id
      }
    }
    cloudo = {
      enabled = var.alert_channels.cloudo
      connectors = {
        for connector_name in local.webhook_connector_names : connector_name => elasticstack_kibana_action_connector.app_connector[local.space_connectors["${each.value.space_name}-${connector_name}"].key].connector_id
      }
    }
  }

  system_alert_channels = {
    email = {
      enabled    = var.infra_alert_channels.email
      recipients = var.email_recipients
    }
    slack = {
      enabled    = var.infra_alert_channels.slack
      connectors = var.infra_alert_channels.slack ? { (local.system_connector_names.slack) : elasticstack_kibana_action_connector.infra_connector_slack[each.value.space_name].connector_id } : {}
    }
    jsm = {
      enabled    = var.infra_alert_channels.jsm
      connectors = var.infra_alert_channels.jsm ? { (local.system_connector_names.jsm) : elasticstack_kibana_action_connector.infra_connector_jsm[each.value.space_name].connector_id } : {}
    }
    cloudo = {
      enabled    = var.infra_alert_channels.cloudo
      connectors = var.infra_alert_channels.cloudo ? { (local.system_connector_names.cloudo) : elasticstack_kibana_action_connector.infra_connector_cloudo[each.value.space_name].connector_id } : {}
    }
  }

  application_name = each.key

  custom_index_component_parameters = {
    primary_shard_count   = var.primary_shard_count
    total_shards_per_node = var.total_shards_per_node
    refresh_interval      = var.refresh_interval
  }

  system_alert = {
    overlog = {
      window_size_hours         = var.system_overlog_alert_configuration.window_size_hours
      threshold_percentage      = var.system_overlog_alert_configuration.threshold
      lookback_comparison_hours = var.system_overlog_alert_configuration.lookback_comparison_hours
    }
    notification_channels = {
      slack = {
        connector_name = local.system_connector_names.slack
      },
      jsm = {
        connector_name = local.system_connector_names.jsm
        priority       = "P2"
      }
    }
  }


  depends_on = [elasticstack_elasticsearch_index_lifecycle.index_lifecycle]
}
