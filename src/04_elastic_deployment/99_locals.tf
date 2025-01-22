locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-ec"

  tags = {
    CreatedBy   = "Terraform"
    Environment = upper(var.env)
    Owner       = "PAY-MONITORING"
    Source      = "https://github.com/pagopa/elasticcloud-infra"
    CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  }

  default_snapshot_container_name = "snapshotblob"

  shared_env_application_id = {
    for e in var.shared_env : e => data.azuread_application.ec_application[e].application_id
  }
}



