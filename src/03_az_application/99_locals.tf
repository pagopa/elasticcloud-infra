locals {
  project = "${var.prefix}-${var.env_short}-elasticcloud"
  kibana_url      = "https://${var.prefix}-${var.env_short}-${var.location_short}-ec.kb.${var.location}.azure.elastic-cloud.com"
}
