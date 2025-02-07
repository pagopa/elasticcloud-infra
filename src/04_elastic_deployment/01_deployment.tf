
locals {
  deployment_name = "${local.project}"
  kibana_url      = "https://${local.deployment_name}.kb.${var.location}.azure.elastic-cloud.com"
  apm_url         = "https://${local.deployment_name}.apm.${var.location}.azure.elastic-cloud.com"
  fleet_url       = "https://${local.deployment_name}.fleet.${var.location}.azure.elastic-cloud.com"
}

resource "ec_deployment" "elastic_cloud" {
  name                   = local.deployment_name
  alias                  = local.deployment_name
  region                 = "azure-${var.location}"
  version                = var.elasticsearch_version
  deployment_template_id = "azure-storage-optimized"

  integrations_server = {
    elasticsearch_cluster_ref_id = "main-elasticsearch"
    endpoints = {
      apm       = local.apm_url
      fleet     = local.fleet_url
      profiling = null
      symbols   = null
    }
    instance_configuration_id      = "azure.integrationsserver.fsv2"
    instance_configuration_version = 2
    size                           = var.integration_server.size
    size_resource                  = var.integration_server.size_resource
    zone_count                     = var.integration_server.zones
  }

  elasticsearch = {
    hot = {
      autoscaling = {}
      size        = var.hot_config.size
      zone_count  = var.hot_config.zone_count
    }

    warm = var.warm_config != null ? {
      autoscaling = {}
      size        = var.warm_config.size
      zone_count  = var.warm_config.zone_count
    } : null

    cold = var.cold_config != null ? {
      autoscaling = {}
      size        = var.cold_config.size
      zone_count  = var.cold_config.zone_count
    } : null


    config = {
      user_settings_yaml = templatefile("./configs/es.yml.tpl", {
        kibana_url = local.kibana_url
        tenant_id  = data.azurerm_subscription.current.tenant_id
        shared_env = local.shared_env_application_id
      })
    }

    master = var.master_config != null ? {
      autoscaling = {}
      size        = var.master_config.size
      zone_count  = var.master_config.zone_count
    } : null

    coordinating = var.coordinating_config != null ? {
      autoscaling = {}
      size        = var.coordinating_config.size
      zone_count  = var.coordinating_config.zone_count
    } : null

  }

  kibana = {
    zone_count = var.kibana_config.zone_count
    size       = var.kibana_config.size
    config = {
      user_settings_yaml = templatefile("./configs/kb.yml.tpl", {
        shared_env = local.shared_env_application_id
      })
    }
  }

  observability = {
    deployment_id = "self"
  }

  tags = local.tags
}

