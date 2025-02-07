locals {
  prefix   = "paymon"
  location = "italynorth"

  prefix_env_short = "${local.prefix}-${var.env_short}"
  project          = "${local.prefix}-${var.env_short}-ec-org"

  input_file = "./secret/${local.prefix}-${var.env}/configs.json"

  tags = {
    CreatedBy   = "Terraform"
    Environment = upper(var.env)
    Owner       = "PAY-MONITORING"
    Source      = "https://github.com/pagopa/elasticcloud-infra"
    CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
    Folder      = basename(abspath(path.module))
  }
}
