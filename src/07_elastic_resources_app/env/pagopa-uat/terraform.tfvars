prefix    = "pagopa"
env_short = "u"
env       = "uat"

deployment_name = "pagopa-s-weu-ec"

ilm = {
  nodo                 = "w2-c4-d5-minsize-shrink"
  nodocron             = "w2-c4-d5-minsize-shrink"
  nodoreplica          = "w2-c4-d5-minsize-shrink"
  nodocronreplica      = "w2-c4-d5-minsize-shrink"
  pagopastandinmanager = "w2-c4-d5-minsize-shrink"
  pagopawebbo          = "w2-c4-d5-minsize-shrink"
  pagopawfespwfesp     = "w2-c4-d5-minsize-shrink"
  pagopawfespwfesp     = "w2-c4-d5-minsize-shrink"
  pagopawispconverter  = "w2-c4-d5-minsize-shrink"
  tech-support         = "w2-c4-d5-minsize-shrink"
  wispsoapconverter    = "w2-c4-d5-minsize-shrink"
  ecommerce            = "w2-c4-d5-minsize-shrink"
  pagopapaymentspull   = "w2-c4-d5-minsize-shrink"
  pagopa               = "w2-c4-d5-minsize-shrink"
  paywallet            = "w2-c4-d5-minsize-shrink"
  printit              = "w2-c4-d5-minsize-shrink"
  fdr                  = "w2-c4-d5-minsize-shrink"
  fdrnodo              = "w2-c4-d5-minsize-shrink"
  checkout             = "w2-c4-d5-minsize-shrink"
  backoffice           = "w2-c4-d5-minsize-shrink"
  apiconfig            = "w2-c4-d5-minsize-shrink"
  bizevents            = "w2-c4-d5-minsize-shrink"
  afm                  = "w2-c4-d5-minsize-shrink"
  crusc8               = "w2-c4-d5-minsize-shrink"
  anonymizer           = "w2-c4-d5-minsize-shrink"

}

apm_ilm = {
}

ilm_delete_wait_for_snapshot = false
