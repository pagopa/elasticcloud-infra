env_short = "s"
env       = "stag"

tags = {
  CreatedBy   = "Terraform"
  Environment = "STAG"
  Owner       = "PAY-MONITORING"
  Source      = "https://github.com/pagopa/elasticcloud-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

targets = ["pagopa", "arc", "p4pa"]
