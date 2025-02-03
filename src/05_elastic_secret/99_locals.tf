locals {
  subscription_prefix  = "paymon"
  subscription_product = "${local.subscription_prefix}-${var.env_short}"

  azdo_managed_identity_rg_name = "${local.subscription_prefix}-${var.env_short}-identity-rg"
  azdo_iac_managed_identities   = toset(["azdo-${var.env}-${local.subscription_prefix}-iac-deploy", "azdo-${var.env}-${local.subscription_prefix}-iac-plan"])

}
