prefix    = "pagopa"
env       = "dev"
env_short = "d"

deployment_name = "pagopa-s-weu-ec"

ilm = {
  nodo                 = "w1-d5-lowsize"
  nodocron             = "w1-d5-lowsize"
  nodoreplica          = "w1-d5-lowsize"
  nodocronreplica      = "w1-d5-lowsize"
  pagopastandinmanager = "w1-d5-lowsize"
  pagopawebbo          = "w1-d5-lowsize"
  pagopawfespwfesp     = "w1-d5-lowsize"
  pagopawfespwfesp     = "w1-d5-lowsize"
  pagopawispconverter  = "w1-d5-lowsize"
  tech-support         = "w1-d5-lowsize"
  wispsoapconverter    = "w1-d5-lowsize"
  ecommerce            = "w1-d5-lowsize"
  gps                  = "w1-d5-lowsize"
  pagopa               = "w1-d5-lowsize"
  paywallet            = "w1-d5-lowsize"
  printit              = "w1-d5-lowsize"
  fdr                  = "w1-d5-lowsize"
  fdrnodo              = "w1-d5-lowsize"
  checkout             = "w1-d5-lowsize"
  backoffice           = "w1-d5-lowsize"
  apiconfig            = "w1-d5-lowsize"
  bizevents            = "w1-d5-lowsize"
  afm                  = "w1-d5-lowsize"
  crusc8               = "w1-d5-lowsize"
  anonymizer           = "w1-d5-lowsize"
  payopt               = "w1-d5-lowsize"
}

apm_logs_metrics_ilm = {
}

ilm_delete_wait_for_snapshot = false
