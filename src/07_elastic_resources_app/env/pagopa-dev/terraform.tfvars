prefix    = "pagopa"
env       = "dev"
env_short = "d"

deployment_name = "pagopa-s-weu-ec"

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
  fdr                  = "w2-c4-d5"
  fdrnodo              = "w2-c4-d5"
  checkout             = "w2-c4-d5"
  backoffice           = "w2-c4-d5"
  apiconfig            = "w2-c4-d5"
  bizevents            = "w2-c4-d5"
  afm                  = "w2-c4-d5"
  crusc8               = "w2-c4-d5"
}

apm_ilm = {
}

ilm_delete_wait_for_snapshot = false
