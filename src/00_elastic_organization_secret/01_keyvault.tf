resource "azurerm_resource_group" "sec_rg" {
  name     = "${local.project}-sec-rg"
  location = local.location

  tags = local.tags
}

module "key_vault" {
  source = "./.terraform/modules/__v4__/key_vault"

  name                       = "${local.project}-kv"
  location                   = azurerm_resource_group.sec_rg.location
  resource_group_name        = azurerm_resource_group.sec_rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 90

  tags = local.tags
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "ad_group_policy" {
  key_vault_id = module.key_vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_admin.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Encrypt", "Decrypt", "Backup", "Purge", "Recover", "Restore", "GetRotationPolicy", "SetRotationPolicy"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Backup", "Purge", "Recover", "Restore"]
  storage_permissions     = []
  certificate_permissions = []
}



