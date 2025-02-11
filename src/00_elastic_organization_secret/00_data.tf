data "azurerm_client_config" "current" {}

# Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.prefix_env_short}-adgroup-admin"
}
