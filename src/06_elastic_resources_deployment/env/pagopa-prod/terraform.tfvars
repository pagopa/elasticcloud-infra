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


default_ilm_logs               = "w2-c4-d7-minsize-shrink"
default_ilm_traces             = "w2-c8-d90-shrink"
default_ilm_metrics            = "w2-c4-d7-minsize-shrink"
default_ilm_elastic            = "w1-c3-d5-shrink"
default_ilm_metricbeat         = "w1-c3-d5-shrink"
default_ilm_elastic_monitoring = "w0-d3"

deployment_name = "pagopa-p-weu-ec"

ilm_delete_wait_for_snapshot = true

alert_channels = {
  log      = true
  slack    = false
  email    = true
  opsgenie = true
}

app_connectors = {
  "team-core-opsgenie" : {
    type       = "opsgenie"
    secret_key = "team-core-opsgenie-api-key"
  },
  "team-touchpoint-opsgenie" : {
    type       = "opsgenie"
    secret_key = "team-touchpoint-opsgenie-api-key"
  }
}

primary_shard_count = 3



