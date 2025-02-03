prefix    = "pagopa"
env       = "dev"
env_short = "d"

ec_deployment_id = "782a6d595487581de53e0e115756957f"


aks_names = ["pagopa-d-weu-dev-aks", "pagopa-d-itn-dev-aks"]
# aks_name  = "pagopa-d-weu-dev-aks"
dedicated_log_instance_name = [
  /* nodo */ "nodo", "nodoreplica", "nodocron", "nodocronreplica", "pagopawebbo", "pagopawfespwfesp", "pagopafdr", "pagopafdrnodo", "wispsoapconverter", "pagopawispconverter",
  /* afm */ "pagopaafmcalculator-microservice-chart", "pagopaafmmarketplacebe-microservice-chart", "pagopaafmutils-microservice-chart",
  /* bizevents */ "pagopabizeventsdatastore-microservice-chart", "pagopabizeventsservice-microservice-chart", "pagopanegativebizeventsdatastore-microservice-chart",
  /* apiconfig */ "pagopaapiconfig-postgresql", "pagopaapiconfig-oracle", "apiconfig-selfcare-integration-microservice-chart", "cache-oracle", "cache-postgresql", "cache-replica-oracle", "cache-replica-postgresql",
  /* ecommerce */ "pagopaecommerceeventdispatcherservice-microservice-chart", "pagopaecommercepaymentmethodsservice-microservice-chart", "pagopaecommercepaymentrequestsservice-microservice-chart", "pagopaecommercetransactionsservice-microservice-chart", "pagopaecommercetxschedulerservice-microservice-chart", "pagopanotificationsservice-microservice-chart",
  /* selfcare */ "pagopaselfcaremsbackofficebackend-microservice-chart", "backoffice-external",
  /* gps */ "gpd-core-microservice-chart", "pagopagpdpayments-microservice-chart", "pagopareportingorgsenrollment-microservice-chart", "pagopaspontaneouspayments-microservice-chart", "gpd-payments-pull", "gpd-upload-microservice-chart", "pagopapagopagpdingestionmanager-microservice-chart"
]

elastic_agent_kube_namespace = "elastic-cloud-system"

ilm = {
  nodo                 = "2-4-6-8"
  nodocron             = "2-4-6-8"
  nodocronreplica      = "2-4-6-8"
  nodocronreplica      = "2-4-6-8"
  pagopastandinmanager = "2-4-6-8"
  pagopawebbo          = "2-4-6-8"
  pagopawfespwfesp     = "2-4-6-8"
  pagopawfespwfesp     = "2-4-6-8"
  pagopawispconverter  = "2-4-6-8"
  tech-support         = "2-4-6-8"
  wispsoapconverter    = "2-4-6-8"
  ecommerce            = "2-4-6-8"
  fdr                  = "2-4-6-8"
  pagopapaymentspull   = "2-4-6-8"
  pagopa               = "2-4-6-8"
  paywallet            = "2-4-6-8"
  printit              = "2-4-6-8"


}


