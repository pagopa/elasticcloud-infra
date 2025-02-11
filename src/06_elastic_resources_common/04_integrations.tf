resource "elasticstack_fleet_integration" "kubernetes_package" {
  name         = "kubernetes"
  version      = "1.70.1"
  force        = true
  skip_destroy = true
}

resource "elasticstack_fleet_integration" "system_package" {
  name         = "system"
  version      = "1.64.0"
  force        = true
  skip_destroy = true
}