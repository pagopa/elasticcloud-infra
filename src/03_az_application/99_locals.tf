locals {
  project    = "${var.prefix}-${var.env}-elasticcloud"
  kibana_url = "https://${var.deployment_name}.kb.${var.location}.azure.elastic-cloud.com"
}
