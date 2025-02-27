locals {
  subscription_prefix  = "paymon"
  subscription_product = "${local.subscription_prefix}-${var.env_short}"

  tags = {
    CreatedBy      = "Terraform"
    Environment    = upper(var.env)
    Owner          = "PAY-MONITORING"
    SecondaryOwner = var.prefix
    Source         = "https://github.com/pagopa/elasticcloud-infra"
    CostCenter     = "TS310 - PAGAMENTI & SERVIZI"
    Domain         = basename(abspath(path.module))
  }

  input_file = "./secret/${var.prefix}-${var.env}/configs.json"


  azdo_iac_managed_identities = {
    names   = toset(["azdo-${var.env}-paymon-iac-plan", "azdo-${var.env}-paymon-iac-deploy"])
    rg_name = "paymon-${var.env_short}-itn-azdo-identity-rg"
  }
}
