resource "azurerm_key_vault_access_policy" "azdevops_iac_managed_identities" {
  for_each = local.azdo_iac_managed_identities.names

  key_vault_id = module.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_user_assigned_identity.iac_federated_azdo[each.key].principal_id

  secret_permissions = ["Get", "List", "Set", ]

  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get"]
  key_permissions         = ["Get", "GetRotationPolicy", "Decrypt"]
  storage_permissions     = []
}

resource "azurerm_key_vault_access_policy" "azdevops_iac_target_managed_identities" {
  for_each = var.azdo_iac_target_identities

  key_vault_id = module.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.value

  secret_permissions = ["Get", "List", "Set", ]

  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get"]
  key_permissions         = ["Get", "GetRotationPolicy", "Decrypt"]
  storage_permissions     = []
}