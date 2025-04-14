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

}

apm_ilm = {
  service_name = "w2-c4-d7"
}

ilm_delete_wait_for_snapshot = true
