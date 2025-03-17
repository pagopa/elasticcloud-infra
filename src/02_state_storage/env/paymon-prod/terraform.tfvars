env       = "prod"
env_short = "p"

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "PAY-MONITORING"
  Source      = "https://github.com/pagopa/elasticcloud-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

targets = ["pagopa", "arc", "p4pa"]