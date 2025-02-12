prefix    = "pagopa"
env       = "dev"
env_short = "d"

deployment_name = "pagopa-s-weu-ec"

aks_config = [
  {
    name = "pagopa-d-weu-dev-aks"
    elastic_agent = {
      namespace = "elastic-cloud-agent"
      create_ns = true
    }
    otel = {
      namespace = "otel"
      create_ns = true
      affinity_selector = {
        key   = "elastic"
        value = "eck"
      }
    }
  },
  {
    name = "pagopa-d-itn-dev-aks"
    elastic_agent = {
      namespace = "elastic-cloud-agent"
      create_ns = true
    }
    otel = {
      namespace = "otel"
      create_ns = true
    }
  }
]
k8s_application_log_instance_names = [
  /* nodo */ "nodo", "nodoreplica", "nodocron", "nodocronreplica", "pagopawebbo", "pagopawfespwfesp", "pagopafdr", "pagopafdrnodo", "wispsoapconverter", "pagopawispconverter",
  /* afm */ "pagopaafmcalculator-microservice-chart", "pagopaafmmarketplacebe-microservice-chart", "pagopaafmutils-microservice-chart",
  /* bizevents */ "pagopabizeventsdatastore-microservice-chart", "pagopabizeventsservice-microservice-chart", "pagopanegativebizeventsdatastore-microservice-chart",
  /* apiconfig */ "pagopaapiconfig-postgresql", "pagopaapiconfig-oracle", "apiconfig-selfcare-integration-microservice-chart", "cache-oracle", "cache-postgresql", "cache-replica-oracle", "cache-replica-postgresql",
  /* ecommerce */ "pagopaecommerceeventdispatcherservice-microservice-chart", "pagopaecommercepaymentmethodsservice-microservice-chart", "pagopaecommercepaymentrequestsservice-microservice-chart", "pagopaecommercetransactionsservice-microservice-chart", "pagopaecommercetxschedulerservice-microservice-chart", "pagopanotificationsservice-microservice-chart",
  /* selfcare */ "pagopaselfcaremsbackofficebackend-microservice-chart", "backoffice-external",
  /* gps */ "gpd-core-microservice-chart", "pagopagpdpayments-microservice-chart", "pagopareportingorgsenrollment-microservice-chart", "pagopaspontaneouspayments-microservice-chart", "gpd-payments-pull", "gpd-upload-microservice-chart", "pagopapagopagpdingestionmanager-microservice-chart",
  /* fdr */ "fdr-nodo-fdrnodo", "pagopafdr-microservice-chart", "fdr-technicalsupport-microservice-chart"
]

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
  pagopafdr            = "w2-c4-d5"

}

ilm_delete_wait_for_snapshot = false


