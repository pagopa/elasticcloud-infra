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

locals {
  /*
    produces a map of <rg-name> => {rg: "", name: ""} to be used in for_each
   */
  iac_identities = {for item in flatten([
    for k, v in {
      for target, conf in local.azdo_iac_managed_identities : target => [for name in conf.names : { rg = conf.rg_name, name = name}]
    } : v
  ]) : "${item.rg}-${item.name}" => item}
}

data "azurerm_user_assigned_identity" "iac_federated_azdo" {
  for_each            = local.iac_identities
  name                = each.value.name
  resource_group_name = each.value.rg
}