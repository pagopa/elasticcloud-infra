resource "azurerm_key_vault_key" "sops_key" {
  name         = "${local.subscription_product}-${var.prefix}-sops-key"
  key_vault_id = module.key_vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
  ]

  depends_on = [
    azurerm_key_vault_access_policy.ad_group_policy,
  ]

}
