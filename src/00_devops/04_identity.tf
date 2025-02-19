resource "azurerm_resource_group" "managed_identities_rg" {
  name     = "${local.project}-identity-rg"
  location = local.location
  tags     = local.tags
}

resource "azurerm_resource_group" "default_roleassignment_rg" {
  #Important: do not create any resource inside this resource group
  name     = "default-roleassignment-rg"
  location = local.location
  tags     = local.tags
}
