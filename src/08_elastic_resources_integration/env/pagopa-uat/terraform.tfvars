prefix    = "pagopa"
env_short = "u"
env       = "uat"

deployment_name = "pagopa-s-weu-ec"


aks_config = [
  {
    name = "pagopa-u-weu-uat-aks"
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
    name = "pagopa-u-itn-uat-aks"
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

k8s_application_log_instance_names = {
  afm = [
    "pagopaafmcalculator-microservice-chart",
    "pagopaafmmarketplacebe-microservice-chart",
    "pagopaafmutils-microservice-chart"
  ]
  apiconfig = [
    "pagopaapiconfig-postgresql",
    "pagopaapiconfig-oracle",
    "apiconfig-selfcare-integration-microservice-chart",
    "cache-oracle",
    "cache-postgresql",
    "cache-replica-oracle",
    "cache-replica-postgresql"
  ]
  backoffice = [
    "pagopaselfcaremsbackofficebackend-microservice-chart",
    "backoffice-external"
  ]
  bizevents = [
    "pagopabizeventsdatastore-microservice-chart",
    "pagopabizeventsservice-microservice-chart",
    "pagopanegativebizeventsdatastore-microservice-chart"
  ]
  checkout = ["pagopa-checkout-auth-service"]
  ecommerce = [
    "pagopaecommerceeventdispatcherservice-microservice-chart",
    "pagopaecommercepaymentmethodsservice-microservice-chart",
    "pagopaecommercepaymentrequestsservice-microservice-chart",
    "pagopaecommercetransactionsservice-microservice-chart",
    "pagopaecommercetxschedulerservice-microservice-chart",
    "pagopanotificationsservice-microservice-chart",
    "pagopa-jwt-issuer-service",
    "pagopa-ecommerce-payment-methods-handler"
  ]
  fdr = [
    "fdr-nodo-fdrnodo",
    "pagopafdr-microservice-chart",
    "fdr-technicalsupport-microservice-chart",
    "pagopafdr-scheduler",
    "pagopafdrtoeventhub-fdr1-blobtrigger",
    "pagopafdrtoeventhub-fdr3-blobtrigger",
    "pagopafdrtoeventhub-recovery",
    "pagopa-fdr-2-event-hub",
    "pagopa-fdr-json-to-xml-functions",
    "pagopafdrxmltojson-blobtrigger",
    "pagopafdrxmltojson-httptrigger",
    "pagopafdrxmltojson-queuetrigger"
  ]
  gps = [
    "gpd-core-microservice-chart",
    "pagopagpdpayments-microservice-chart",
    "pagopareportingorgsenrollment-microservice-chart",
    "pagopaspontaneouspayments-microservice-chart",
    "gpd-payments-pull",
    "gpd-upload-microservice-chart",
    "pagopa-gpd-ingestion-manager",
    "pagopa-gpd-rtp"
  ]
  nodo              = ["nodopagamenti"]
  nodocron          = ["nodocron"]
  nodoreplica       = ["nodoreplica"]
  nodocronreplica   = ["nodocronreplica"]
  pagopawebbo       = ["pagopawebbo"]
  pagopawfespwfesp  = ["pagopawfespwfesp"]
  wispsoapconverter = ["wispsoapconverter"]
  pagopawispconverter = [
    "pagopawispconverter-microservice-chart",
    "pagopawispconverterts-microservice-chart"
  ]
  payopt = ["payment-options"]
  printit = [
    "print-payment-notice-service",
    "print-payment-notice-generator",
    "print-payment-notice-functions"
  ]
  receipts = [
    "pagopapagopareceiptpdfgenerator-microservice-chart",
    "pagopapagopareceiptpdfhelpdesk-microservice-chart",
    "pagopapagopareceiptpdfservice-microservice-chart",
    "pagopapagopareceiptpdfdatastore-microservice-chart",
    "pagopapagopareceiptpdfnotifier-microservice-chart"
  ]
  crusc8 = [ # AKS deployment names
    "pagopacruscottobackend-microservice-chart",
  ]
  anonymizer = ["pagopa-anonymizer"]
}

sampling_configuration = {
  enabled                    = true
  probes_sampling_percentage = 10
  sampling_percentage        = 50
  probe_paths                = ["/actuator/health/liveness", "/actuator/health/readiness", "/actuator/health/{*path}", "/health/liveness", "/health/readiness"]
}