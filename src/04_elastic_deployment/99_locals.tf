locals {
  subscription_prefix  = "paymon"
  subscription_product = "${local.subscription_prefix}-${var.env_short}"

  project = "${var.prefix}-${var.env_short}-${var.location_short}-ec"

  tags = {
    CreatedBy   = "Terraform"
    Environment = upper(var.env)
    Owner       = "PAY-MONITORING"
    Source      = "https://github.com/pagopa/elasticcloud-infra"
    CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  }

  default_snapshot_container_name = "snapshotblob"

  shared_env_application_id = zipmap(
    var.shared_env,
    [for idx, env in var.shared_env : {
      client_id = data.azuread_application.ec_application[env].client_id
      index     = idx
    }]
  )
}
