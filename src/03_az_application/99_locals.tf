locals {
  project = "${var.prefix}-${var.env_short}-elasticcloud"
  kibana_url      = "https://${var.deployment_name}-ec.kb.${var.location}.azure.elastic-cloud.com"
}
