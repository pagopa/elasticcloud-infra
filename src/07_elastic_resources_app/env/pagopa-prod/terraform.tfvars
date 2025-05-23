prefix    = "pagopa"
env_short = "p"
env       = "prod"

deployment_name = "pagopa-p-weu-ec"

ilm = {
  nodo                 = "w2-c4-d7"
  nodocron             = "w2-c4-d7"
  nodoreplica          = "w2-c4-d7"
  nodocronreplica      = "w2-c4-d7"
  pagopastandinmanager = "w2-c4-d7"
  pagopawebbo          = "w2-c4-d7"
  pagopawfespwfesp     = "w2-c4-d7"
  pagopawfespwfesp     = "w2-c4-d7"
  pagopawispconverter  = "w2-c4-d7"
  tech-support         = "w2-c4-d7"
  wispsoapconverter    = "w2-c4-d7"
  ecommerce            = "w2-c4-d7"
  pagopapaymentspull   = "w2-c4-d7"
  pagopa               = "w2-c4-d7"
  paywallet            = "w2-c4-d7"
  printit              = "w2-c4-d7"
  fdr                  = "w2-c4-d7"
  fdrnodo              = "w2-c4-d7"
  checkout             = "w2-c4-d7"
  backoffice           = "w2-c8-d30"
  apiconfig            = "w2-c4-d7"
  bizevents            = "w2-c4-d7"
  afm                  = "w2-c4-d7"
  crusc8               = "w2-c4-d7"

}

apm_ilm = {
  pagopa-ecommerce-payment-methods-service        = "w2-c8-d90"
  pagopa-ecommerce-transactions-service           = "w2-c8-d90"
  pagopa-ecommerce-payment-requests-service       = "w2-c8-d90"
  pagopa-ecommerce-user-stats-service             = "w2-c8-d90"
  pagopa-ecommerce-event-dispatcher-service       = "w2-c8-d90"
  pagopa-ecommerce-helpdesk-service               = "w2-c8-d90"
  pagopa-ecommerce-transactions-scheduler-service = "w2-c8-d90"
  pagopa-wallet-service                           = "w2-c8-d90"
  pagopa-payment-wallet-cdc-service               = "w2-c8-d90"
  pagopa-payment-wallet-event-dispatcher-service  = "w2-c8-d90"
}

ilm_delete_wait_for_snapshot = true
primary_shard_count          = 3