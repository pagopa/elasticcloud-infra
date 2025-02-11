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

# TODO Potrebbe avere senso strutturare gli env in questo modo al posto di targets
# target_deployment = ["pagopa", "arp4pa"]
