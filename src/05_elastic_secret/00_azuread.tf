# Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.subscription_product}-adgroup-admin"
}

data "azuread_group" "adgroup_developers" {
  display_name = "${local.subscription_product}-adgroup-developers"
}

data "azuread_group" "adgroup_externals" {
  display_name = "${local.subscription_product}-adgroup-externals"
}

data "azuread_group" "adgroup_security" {
  display_name = "${local.subscription_product}-adgroup-security"
}



data "azurerm_user_assigned_identity" "iac_federated_azdo" {
  for_each            = local.azdo_iac_managed_identities.names
  name                = each.value
  resource_group_name = local.azdo_iac_managed_identities.rg_name
}