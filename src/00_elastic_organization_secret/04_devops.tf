resource "azurerm_key_vault_access_policy" "azdevops_iac_managed_identities" {
  for_each = local.iac_identities

  key_vault_id = module.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_user_assigned_identity.iac_federated_azdo[each.key].principal_id

  secret_permissions = ["Get", "List", "Set", ]
  key_permissions         = ["Get", "GetRotationPolicy", "Decrypt"]
  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get"]

  storage_permissions = []
}