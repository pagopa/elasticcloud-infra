prefix          = "pagopa"
env_short       = "p"
env             = "prod"
location        = "westeurope"
location_short  = "weu"
location_string = "West Europe"

kv_name_org_ec = "paymon-p-ec-org-kv"
kv_rg_org_ec   = "paymon-p-ec-org-sec-rg"

elastic_apikey_env_short = "p"
elastic_apikey_env       = "prod"


default_ilm_logs    = "w2-c4-d7"
default_ilm_traces  = "w2-c8-d30"
default_ilm_metrics = "w2-c8-d90"

deployment_name = "pagopa-p-weu-ec"

ilm_delete_wait_for_snapshot = true