prefix    = "pagopa"
env_short = "p"
env       = "prod"

deployment_name = "pagopa-p-weu-ec"

ilm = {
  nodo                 = "w1-d7-shrink"
  nodocron             = "w1-d7-shrink"
  nodoreplica          = "w1-d7-shrink"
  nodocronreplica      = "w1-d7-shrink"
  pagopastandinmanager = "w1-d7-shrink"
  pagopawebbo          = "w1-d7-shrink"
  pagopawfespwfesp     = "w1-d7-shrink"
  pagopawfespwfesp     = "w1-d7-shrink"
  pagopawispconverter  = "w1-d7-shrink"
  tech-support         = "w1-d7-shrink"
  wispsoapconverter    = "w1-d7-shrink"
  ecommerce            = "w1-d7-shrink"
  gps                  = "w1-d7-shrink"
  pagopa               = "w1-d7-shrink"
  paywallet            = "w1-d7-shrink"
  printit              = "w1-d7-shrink"
  receipts             = "w1-d7-shrink"
  fdr                  = "w1-d7-shrink"
  fdrnodo              = "w1-d7-shrink"
  checkout             = "w1-d7-shrink"
  apiconfig            = "w1-d7-shrink"
  bizevents            = "w1-d7-shrink"
  afm                  = "w1-d7-shrink"
  crusc8               = "w1-d7-shrink"
  anonymizer           = "w1-d7-shrink"
  backoffice           = "w1-d7-shrink"
  payopt               = "w1-d7-shrink"
}

apm_logs_metrics_ilm = {
  pagopa-ecommerce-payment-methods-service        = "w1-d7-shrink"
  pagopa-ecommerce-transactions-service           = "w1-d7-shrink"
  pagopa-ecommerce-payment-requests-service       = "w1-d7-shrink"
  pagopa-ecommerce-user-stats-service             = "w1-d7-shrink"
  pagopa-ecommerce-event-dispatcher-service       = "w1-d7-shrink"
  pagopa-ecommerce-helpdesk-service               = "w1-d7-shrink"
  pagopa-ecommerce-transactions-scheduler-service = "w1-d7-shrink"
  pagopa-wallet-service                           = "w1-d7-shrink"
  pagopa-payment-wallet-cdc-service               = "w1-d7-shrink"
  pagopa-payment-wallet-event-dispatcher-service  = "w1-d7-shrink"
}

ilm_delete_wait_for_snapshot = true
primary_shard_count          = 3
total_shards_per_node        = 3


app_connectors = {
  "team-core-opsgenie" = {
    type       = "opsgenie"
    secret_key = "team-core-opsgenie-api-key"
  }
  "team-touchpoint-opsgenie" = {
    type       = "opsgenie"
    secret_key = "team-touchpoint-opsgenie-api-key"
  }
  "team-core-slack" = {
    type       = "slack"
    secret_key = "team-core-slack-webhook-url"
  }
  "ecommerce-status-slack" = {
    type       = "slack"
    secret_key = "ecommerce-status-slack-webhook-url"
  }
}

email_recipients = {
  "team-core-emails" = [
  ]
  "team-touchpoint-emails" = [
  ]
}

alert_channels = {
  email    = false
  slack    = true
  opsgenie = true
}