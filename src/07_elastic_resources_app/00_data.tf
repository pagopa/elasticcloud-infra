data "ec_deployment" "ec_deployment" {
  id = var.ec_deployment_id
}

data "elasticstack_fleet_integration" "kubernetes" {
  name = "kubernetes"
}

data "elasticstack_fleet_integration" "system" {
  name = "system"
}