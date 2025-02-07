prefix    = "pagopa"
env       = "dev"
env_short = "d"

ec_deployment_id = "782a6d595487581de53e0e115756957f"


aks_names = [
  {
    name = "pagopa-d-weu-dev-aks"
    affinity_selector = {
      key   = "elastic"
      value = "eck"
    }
  },
  {
    name = "pagopa-d-itn-dev-aks"
  }
]
k8s_application_log_instance_names = [
  /* nodo */ "nodo", "nodoreplica", "nodocron", "nodocronreplica", "pagopawebbo", "pagopawfespwfesp", "pagopafdr", "pagopafdrnodo", "wispsoapconverter", "pagopawispconverter",
  /* afm */ "pagopaafmcalculator-microservice-chart", "pagopaafmmarketplacebe-microservice-chart", "pagopaafmutils-microservice-chart",
  /* bizevents */ "pagopabizeventsdatastore-microservice-chart", "pagopabizeventsservice-microservice-chart", "pagopanegativebizeventsdatastore-microservice-chart",
  /* apiconfig */ "pagopaapiconfig-postgresql", "pagopaapiconfig-oracle", "apiconfig-selfcare-integration-microservice-chart", "cache-oracle", "cache-postgresql", "cache-replica-oracle", "cache-replica-postgresql",
  /* ecommerce */ "pagopaecommerceeventdispatcherservice-microservice-chart", "pagopaecommercepaymentmethodsservice-microservice-chart", "pagopaecommercepaymentrequestsservice-microservice-chart", "pagopaecommercetransactionsservice-microservice-chart", "pagopaecommercetxschedulerservice-microservice-chart", "pagopanotificationsservice-microservice-chart",
  /* selfcare */ "pagopaselfcaremsbackofficebackend-microservice-chart", "backoffice-external",
  /* gps */ "gpd-core-microservice-chart", "pagopagpdpayments-microservice-chart", "pagopareportingorgsenrollment-microservice-chart", "pagopaspontaneouspayments-microservice-chart", "gpd-payments-pull", "gpd-upload-microservice-chart", "pagopapagopagpdingestionmanager-microservice-chart"
]

elastic_agent_kube_namespace = "elastic-cloud-system"
otel_kube_namespace          = "elastic-cloud-system"

ilm = {
  nodo                 = "w2-c4-d5"
  nodocron             = "w2-c4-d5"
  nodoreplica          = "w2-c4-d5"
  nodocronreplica      = "w2-c4-d5"
  pagopastandinmanager = "w2-c4-d5"
  pagopawebbo          = "w2-c4-d5"
  pagopawfespwfesp     = "w2-c4-d5"
  pagopawfespwfesp     = "w2-c4-d5"
  pagopawispconverter  = "w2-c4-d5"
  tech-support         = "w2-c4-d5"
  wispsoapconverter    = "w2-c4-d5"
  ecommerce            = "w2-c4-d5"
  pagopapaymentspull   = "w2-c4-d5"
  pagopa               = "w2-c4-d5"
  paywallet            = "w2-c4-d5"
  printit              = "w2-c4-d5"
  pagopafdrnodo        = "w2-c4-d5"

}

ilm_delete_wait_for_snapshot = false


