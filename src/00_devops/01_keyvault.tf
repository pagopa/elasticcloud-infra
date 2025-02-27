resource "azurerm_resource_group" "sec_rg" {
  count    = var.enabled_features.kv ? 1 : 0
  name     = "${local.project}-sec-rg"
  location = local.location

  tags = local.tags
}

module "key_vault" {
  source = "./.terraform/modules/__v4__/key_vault"
  count  = var.enabled_features.kv ? 1 : 0

  name                       = "${local.project}-kv"
  location                   = azurerm_resource_group.sec_rg[0].location
  resource_group_name        = azurerm_resource_group.sec_rg[0].name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 90

  tags = local.tags
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "ad_group_policy" {
  count        = var.enabled_features.kv ? 1 : 0
  key_vault_id = module.key_vault[0].id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_admin.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Encrypt", "Decrypt", "Backup", "Purge", "Recover", "Restore", "GetRotationPolicy", "SetRotationPolicy"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Backup", "Purge", "Recover", "Restore"]
  storage_permissions     = []
  certificate_permissions = []
}
