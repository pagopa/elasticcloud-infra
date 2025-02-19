data "external" "terrasops" {
  count = var.enabled_features.kv ? 1 : 0
  program = [
    "bash", "terrasops.sh"
  ]
  query = {
    env = "${local.prefix}-${var.env}"
  }

}

locals {
  all_enc_secrets_value = can(data.external.terrasops[0].result) ? flatten([
    for k, v in data.external.terrasops[0].result : {
      valore = v
      chiave = k
    }
  ]) : []

  config_secret_data = var.enabled_features.kv ? jsondecode(file(local.input_file)) : {}
  all_config_secrets_value = var.enabled_features.kv ? flatten([
    for kc, vc in local.config_secret_data : {
      valore = vc
      chiave = kc
    }
  ]) : []

  all_secrets_value = concat(local.all_config_secrets_value, local.all_enc_secrets_value)
}

## SOPS secrets

## Upload all encrypted secrets
resource "azurerm_key_vault_secret" "secret" {
  for_each = var.enabled_features.kv ? { for i, v in local.all_secrets_value : local.all_secrets_value[i].chiave => i } : {}

  key_vault_id = module.key_vault[0].id
  name         = local.all_secrets_value[each.value].chiave
  value        = local.all_secrets_value[each.value].valore

  depends_on = [
    module.key_vault[0],
    azurerm_key_vault_key.sops_key[0],
    data.external.terrasops[0],
    azurerm_key_vault_access_policy.ad_group_policy[0],
  ]

  tags = merge(
    local.tags,
    {
      "SOPS" : "True",
    }
  )
}
