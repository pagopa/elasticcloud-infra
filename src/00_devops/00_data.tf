data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

# Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.prefix_env_short}-adgroup-admin"
}
