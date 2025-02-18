resource "azurerm_resource_group" "managed_identities_rg" {
  name     = "${local.project}-identity-rg"
  location = local.location
  tags     = local.tags
}
