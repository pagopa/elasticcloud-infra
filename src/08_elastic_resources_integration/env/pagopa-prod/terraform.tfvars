prefix    = "pagopa"
env_short = "p"
env       = "prod"

deployment_name = "pagopa-p-weu-ec"


aks_config = [
  {
    name = "pagopa-p-weu-prod-aks"
    elastic_agent = {
      namespace        = "elastic-cloud-agent"
      create_ns        = true
      tolerated_taints = [{ key = "dedicated" }]
    }
    otel = {
      namespace = "elastic-system"
      create_ns = false
    }
  },
  {
    name = "pagopa-p-itn-prod-aks"
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
  /* selfcare backoffice*/ "pagopaselfcaremsbackofficebackend-microservice-chart", "backoffice-external",
  /* gps */ "gpd-core-microservice-chart", "pagopagpdpayments-microservice-chart", "pagopareportingorgsenrollment-microservice-chart", "pagopaspontaneouspayments-microservice-chart", "gpd-payments-pull", "gpd-upload-microservice-chart", "pagopapagopagpdingestionmanager-microservice-chart",
  /* fdr */ "fdr-nodo-fdrnodo", "pagopafdr-microservice-chart", "fdr-technicalsupport-microservice-chart", "pagopafdr-scheduler", "pagopafdrtoeventhub-fdr1-blobtrigger", "pagopafdrtoeventhub-fdr3-blobtrigger", "pagopafdrtoeventhub-recovery", "pagopa-fdr-2-event-hub"
  /* printit */ "print-payment-notice-service", "print-payment-notice-generator", "print-payment-notice-functions",
  /* checkout */ "pagopa-checkout-auth-service"
]
