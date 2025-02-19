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

}
