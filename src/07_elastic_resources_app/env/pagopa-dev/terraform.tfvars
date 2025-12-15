prefix    = "pagopa"
env       = "dev"
env_short = "d"

deployment_name = "pagopa-s-weu-ec"

ilm = {
  nodo                 = "w5-d5-lowsize"
  nodocron             = "w5-d5-lowsize"
  nodoreplica          = "w5-d5-lowsize"
  nodocronreplica      = "w5-d5-lowsize"
  pagopastandinmanager = "w5-d5-lowsize"
  pagopawebbo          = "w5-d5-lowsize"
  pagopawfespwfesp     = "w5-d5-lowsize"
  pagopawfespwfesp     = "w5-d5-lowsize"
  pagopawispconverter  = "w5-d5-lowsize"
  tech-support         = "w5-d5-lowsize"
  wispsoapconverter    = "w5-d5-lowsize"
  ecommerce            = "w5-d5-lowsize"
  gps                  = "w5-d5-lowsize"
  pagopa               = "w5-d5-lowsize"
  paywallet            = "w5-d5-lowsize"
  printit              = "w5-d5-lowsize"
  receipts             = "w5-d5-lowsize"
  fdr                  = "w5-d5-lowsize"
  fdrnodo              = "w5-d5-lowsize"
  checkout             = "w5-d5-lowsize"
  backoffice           = "w5-d5-lowsize"
  apiconfig            = "w5-d5-lowsize"
  bizevents            = "w5-d5-lowsize"
  afm                  = "w5-d5-lowsize"
  crusc8               = "w5-d5-lowsize"
  anonymizer           = "w5-d5-lowsize"
  payopt               = "w5-d5-lowsize"
}

apm_logs_metrics_ilm = {
}

ilm_delete_wait_for_snapshot = false


app_connectors = {
  "team-core-slack" = {
    type       = "slack"
    secret_key = "team-core-slack-webhook-url"
  }
  "ecommerce-status-slack" = {
    type       = "slack"
    secret_key = "ecommerce-status-slack-webhook-url"
  }
  "cloudo-webhook" = {
    type       = "webhook"
    secret_key = "cloudo-webhook-url"
  }
}


alert_channels = {
  email    = false
  slack    = false
  opsgenie = false
  cloudo   = true
}