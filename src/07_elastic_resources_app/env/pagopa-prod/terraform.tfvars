prefix    = "pagopa"
env_short = "p"
env       = "prod"

deployment_name = "pagopa-p-weu-ec"

ilm = {
  nodo                 = "w1-c6-d7-shrink"
  nodocron             = "w1-c6-d7-shrink"
  nodoreplica          = "w1-c6-d7-shrink"
  nodocronreplica      = "w1-c6-d7-shrink"
  pagopastandinmanager = "w1-c6-d7-shrink"
  pagopawebbo          = "w1-c6-d7-shrink"
  pagopawfespwfesp     = "w1-c6-d7-shrink"
  pagopawfespwfesp     = "w1-c6-d7-shrink"
  pagopawispconverter  = "w1-c6-d7-shrink"
  tech-support         = "w1-c6-d7-shrink"
  wispsoapconverter    = "w1-c6-d7-shrink"
  ecommerce            = "w1-c6-d7-shrink"
  gps                  = "w1-c6-d7-shrink"
  pagopa               = "w1-c6-d7-shrink"
  paywallet            = "w1-c6-d7-shrink"
  printit              = "w1-c6-d7-shrink"
  fdr                  = "w1-c6-d7-shrink"
  fdrnodo              = "w1-c6-d7-shrink"
  checkout             = "w1-c6-d7-shrink"
  apiconfig            = "w1-c6-d7-shrink"
  bizevents            = "w1-c6-d7-shrink"
  afm                  = "w1-c6-d7-shrink"
  crusc8               = "w1-c6-d7-shrink"
  anonymizer           = "w1-c6-d7-shrink"
  backoffice           = "w2-c8-d30-shrink"

}

apm_ilm = {
  pagopa-ecommerce-payment-methods-service        = "w2-c15-d90-shrink"
  pagopa-ecommerce-transactions-service           = "w2-c15-d90-shrink"
  pagopa-ecommerce-payment-requests-service       = "w2-c15-d90-shrink"
  pagopa-ecommerce-user-stats-service             = "w2-c15-d90-shrink"
  pagopa-ecommerce-event-dispatcher-service       = "w2-c15-d90-shrink"
  pagopa-ecommerce-helpdesk-service               = "w2-c15-d90-shrink"
  pagopa-ecommerce-transactions-scheduler-service = "w2-c15-d90-shrink"
  pagopa-wallet-service                           = "w2-c15-d90-shrink"
  pagopa-payment-wallet-cdc-service               = "w2-c15-d90-shrink"
  pagopa-payment-wallet-event-dispatcher-service  = "w2-c15-d90-shrink"
}

ilm_delete_wait_for_snapshot = true
primary_shard_count          = 3
total_shards_per_node        = 3