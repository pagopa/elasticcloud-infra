locals {
  subscription_prefix  = "paymon"
  subscription_product = "${local.subscription_prefix}-${var.env_short}"

  prefix_env       = "${var.prefix}-${var.env}"
  prefix_env_short = "${var.prefix}-${var.env_short}"

  ilm_prefix = "${var.prefix}-${var.env_short}-deployment"

  alert_notification_emails = [
    "marco.mari@pagopa.it",
    "umberto.coppolabottazzi@pagopa.it",
    "matteo.alongi@pagopa.it",
    "fabio.felici@pagopa.it",
    "diego.lagosmorales@pagopa.it"
  ]

  tags = {
    CreatedBy   = "Terraform"
    Environment = upper(var.env)
    Owner       = "PAY-MONITORING"
    Source      = "https://github.com/pagopa/elasticcloud-infra"
    CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  }



}
