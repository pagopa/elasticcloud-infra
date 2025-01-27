data "azuread_application" "ec_application" {
  for_each = toset(var.shared_env)

  #display_name = "${each.key}-elasticcloud-app"
  display_name = "ElasticCloud"
}
