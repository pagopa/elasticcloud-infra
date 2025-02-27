data "azurerm_client_config" "current" {}

# Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.prefix_env_short}-adgroup-admin"
}




data "azurerm_user_assigned_identity" "iac_federated_azdo" {
  for_each            = local.azdo_iac_managed_identities.names
  name                = each.value
  resource_group_name = local.azdo_iac_managed_identities.rg_name
}