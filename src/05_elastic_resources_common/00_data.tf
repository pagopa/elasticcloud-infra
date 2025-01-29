data "ec_deployment" "ec_deployment" {
  id = var.ec_deployment_id
}

# AD GROUP
data "azuread_group" "adgroup" {
  for_each     = var.role_mappings
  display_name = "${local.prefix_env_short}-${each.key}"
}
