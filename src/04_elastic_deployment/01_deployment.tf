resource "random_uuid" "uuid" {}

locals {
  deployment_name = "${local.project}-${substr(random_uuid.uuid.result, 0, 6)}"
  kibana_url      = "https://${local.deployment_name}.${var.location}.azure.elastic-cloud.com"
}

resource "ec_deployment" "elastic_cloud" {
  name                   = local.deployment_name
  alias                  = local.deployment_name
  region                 = "azure-${var.location}"
  version                = "8.17.0"
  deployment_template_id = "azure-storage-optimized"

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

  }

  kibana = {
    zone_count = var.kibana_zone_count
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


