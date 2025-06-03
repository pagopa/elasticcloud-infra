prefix    = "pagopa"
env       = "dev"
env_short = "d"

deployment_name = "pagopa-s-weu-ec"

ilm = {
  nodo                 = "w2-c4-d5-minsize"
  nodocron             = "w2-c4-d5-minsize"
  nodoreplica          = "w2-c4-d5-minsize"
  nodocronreplica      = "w2-c4-d5-minsize"
  pagopastandinmanager = "w2-c4-d5-minsize"
  pagopawebbo          = "w2-c4-d5-minsize"
  pagopawfespwfesp     = "w2-c4-d5-minsize"
  pagopawfespwfesp     = "w2-c4-d5-minsize"
  pagopawispconverter  = "w2-c4-d5-minsize"
  tech-support         = "w2-c4-d5-minsize"
  wispsoapconverter    = "w2-c4-d5-minsize"
  ecommerce            = "w2-c4-d5-minsize"
  pagopapaymentspull   = "w2-c4-d5-minsize"
  pagopa               = "w2-c4-d5-minsize"
  paywallet            = "w2-c4-d5-minsize"
  printit              = "w2-c4-d5-minsize"
  fdr                  = "w2-c4-d5-minsize"
  fdrnodo              = "w2-c4-d5-minsize"
  checkout             = "w2-c4-d5-minsize"
  backoffice           = "w2-c4-d5-minsize"
  apiconfig            = "w2-c4-d5-minsize"
  bizevents            = "w2-c4-d5-minsize"
  afm                  = "w2-c4-d5-minsize"
  crusc8               = "w2-c4-d5-minsize"
}

apm_ilm = {
}

ilm_delete_wait_for_snapshot = false
