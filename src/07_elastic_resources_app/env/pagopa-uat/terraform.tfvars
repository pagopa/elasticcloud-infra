prefix    = "pagopa"
env_short = "u"
env       = "uat"

deployment_name = "pagopa-s-weu-ec"

ilm = {
  nodo                 = "w1-d5"
  nodocron             = "w1-d5"
  nodoreplica          = "w1-d5"
  nodocronreplica      = "w1-d5"
  pagopastandinmanager = "w1-d5"
  pagopawebbo          = "w1-d5"
  pagopawfespwfesp     = "w1-d5"
  pagopawfespwfesp     = "w1-d5"
  pagopawispconverter  = "w1-d5"
  tech-support         = "w1-d5"
  wispsoapconverter    = "w1-d5"
  ecommerce            = "w1-d5"
  gps                  = "w1-d5"
  pagopa               = "w1-d5"
  paywallet            = "w1-d5"
  printit              = "w1-d5"
  fdr                  = "w1-d5"
  fdrnodo              = "w1-d5"
  checkout             = "w1-d5"
  backoffice           = "w1-d5"
  apiconfig            = "w1-d5"
  bizevents            = "w1-d5"
  afm                  = "w1-d5"
  crusc8               = "w1-d5"
  anonymizer           = "w1-d5"

}

apm_ilm = {
}

ilm_delete_wait_for_snapshot = false
