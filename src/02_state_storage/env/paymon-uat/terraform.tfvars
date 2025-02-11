env_short = "u"
env       = "uat"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "PAY-MONITORING"
  Source      = "https://github.com/pagopa/elasticcloud-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

targets = ["pagopa", "arc", "p4pa"]
