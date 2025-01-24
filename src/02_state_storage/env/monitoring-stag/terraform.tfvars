env_short = "s"
env       = "stag"

tags = {
  CreatedBy   = "Terraform"
  Environment = "STAG"
  Owner       = "PAY-MONITORING"
  Source      = "https://github.com/pagopa/elasticcloud-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

targets = ["pagopa", "arp4pa"]


# TODO Potrebbe avere senso strutturare gli env in questo modo
# target_deployment = ["pagopa", "arp4pa"]
# target_dev        = ["pagopa", "arc", "p4pa]
# target_uat        = ["pagopa", "arc", "p4pa]





# Le folder degli env dovrebbero essere:
# ec-stag --> deve avere i provider settati con gli alias per lavorare su dev-monitoring e uat-monitoring
# target_deployment = ["pagopa", "arp4pa"]
# target_dev        = ["pagopa", "arc", "p4pa"]
# target_uat        = ["pagopa", "arc", "p4pa"]
# Per stag avrò tre storage account diversi


{
        "pagopa" = {

}
}



ec-prod
