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

  azdo_iac_managed_identities   = {
    # "pagopa" = {
    #   names = ["azdo-${var.env}-pagopa-iac-deploy", "azdo-${var.env}-pagopa-iac-plan"]
    #   rg_name = "pagopa-${var.env_short}-identity-rg"
    # },
    "paymon" = {
      names = ["azdo-${var.env}-paymon-iac-plan", "azdo-${var.env}-paymon-iac-deploy"]
      rg_name = "paymon-${var.env_short}-itn-azdo-identity-rg"
    }

  }
}
