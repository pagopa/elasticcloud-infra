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
  "team-core-opsgenie" = {
    type       = "opsgenie"
    secret_key = "team-core-opsgenie-api-key"
  }
  "team-touchpoint-opsgenie" = {
    type       = "opsgenie"
    secret_key = "team-touchpoint-opsgenie-api-key"
  }
}


default_idx_tpl_customization = {
  logs = {
    lifecycle             = "w2-c4-d7-minsize-shrink"
    primary_shard_count   = 3
    component             = "lifecycle-and-shard@custom.json"
    total_shards_per_node = 3
  }
  traces = {
    lifecycle             = "w2-c8-d90-shrink"
    primary_shard_count   = 3
    component             = "lifecycle-and-shard-max@custom.json"
    total_shards_per_node = 3
  }
  metrics = {
    lifecycle             = "w2-c4-d7-minsize-shrink"
    primary_shard_count   = 3
    component             = "lifecycle-and-shard@custom.json"
    total_shards_per_node = 3
  }
  elastic = {
    lifecycle             = "elastic" #custom lifecycle name, uses the embedded snapshot policy
    primary_shard_count   = 3
    component             = "lifecycle-and-shard-max@custom.json"
    total_shards_per_node = 3
  }
  metricbeat = {
    lifecycle             = "metricbeat" #custom lifecycle name, uses the embedded snapshot policy
    primary_shard_count   = 3
    component             = "lifecycle-and-shard-max@custom.json"
    total_shards_per_node = 3
  }
  elastic_monitoring = {
    lifecycle             = "elastic_monitoring" #custom lifecycle name, uses the embedded snapshot policy
    primary_shard_count   = 3
    component             = "lifecycle-and-shard-max@custom.json"
    total_shards_per_node = 3
  }
}


