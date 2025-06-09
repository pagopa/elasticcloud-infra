prefix    = "pagopa"
env_short = "p"
env       = "prod"

deployment_name = "pagopa-p-weu-ec"

ilm = {
  nodo                 = "w2-c4-d7-shrink"
  nodocron             = "w2-c4-d7-shrink"
  nodoreplica          = "w2-c4-d7-shrink"
  nodocronreplica      = "w2-c4-d7-shrink"
  pagopastandinmanager = "w2-c4-d7-shrink"
  pagopawebbo          = "w2-c4-d7-shrink"
  pagopawfespwfesp     = "w2-c4-d7-shrink"
  pagopawfespwfesp     = "w2-c4-d7-shrink"
  pagopawispconverter  = "w2-c4-d7-shrink"
  tech-support         = "w2-c4-d7-shrink"
  wispsoapconverter    = "w2-c4-d7-shrink"
  ecommerce            = "w2-c4-d7-shrink"
  pagopapaymentspull   = "w2-c4-d7-shrink"
  pagopa               = "w2-c4-d7-shrink"
  paywallet            = "w2-c4-d7-shrink"
  printit              = "w2-c4-d7-shrink"
  fdr                  = "w2-c4-d7-shrink"
  fdrnodo              = "w2-c4-d7-shrink"
  checkout             = "w2-c4-d7-shrink"
  backoffice           = "w2-c8-d30-shrink"
  apiconfig            = "w2-c4-d7-shrink"
  bizevents            = "w2-c4-d7-shrink"
  afm                  = "w2-c4-d7-shrink"
  crusc8               = "w2-c4-d7-shrink"

}

apm_ilm = {
  pagopa-ecommerce-payment-methods-service        = "w2-c8-d90-shrink"
  pagopa-ecommerce-transactions-service           = "w2-c8-d90-shrink"
  pagopa-ecommerce-payment-requests-service       = "w2-c8-d90-shrink"
  pagopa-ecommerce-user-stats-service             = "w2-c8-d90-shrink"
  pagopa-ecommerce-event-dispatcher-service       = "w2-c8-d90-shrink"
  pagopa-ecommerce-helpdesk-service               = "w2-c8-d90-shrink"
  pagopa-ecommerce-transactions-scheduler-service = "w2-c8-d90-shrink"
  pagopa-wallet-service                           = "w2-c8-d90-shrink"
  pagopa-payment-wallet-cdc-service               = "w2-c8-d90-shrink"
  pagopa-payment-wallet-event-dispatcher-service  = "w2-c8-d90-shrink"
}

ilm_delete_wait_for_snapshot = true
primary_shard_count          = 3