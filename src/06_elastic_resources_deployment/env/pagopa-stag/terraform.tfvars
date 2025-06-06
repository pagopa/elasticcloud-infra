prefix         = "pagopa"
env_short      = "s"
env            = "staging"
location       = "westeurope"
location_short = "weu"

kv_name_org_ec           = "paymon-u-ec-org-kv"
kv_rg_org_ec             = "paymon-u-ec-org-sec-rg"
elastic_apikey_env_short = "u"
elastic_apikey_env       = "uat"

default_ilm_elastic            = "w1-c3-d5-minsize-shrink"
default_ilm_metricbeat         = "w1-c3-d5-minsize-shrink"
default_ilm_elastic_monitoring = "w0-d3-minsize"

ilm_delete_wait_for_snapshot = false

deployment_name = "pagopa-s-weu-ec"

alert_channels = {
  log      = true
  slack    = true
  email    = false
  opsgenie = false
}


default_idx_tpl_customization = {
  logs = {
    lifecycle             = "w1-c3-d5-minsize-shrink"
    primary_shard_count   = 2
    component             = "lifecycle-and-shard@custom.json"
    total_shards_per_node = 2

  }
  traces = {
    lifecycle             = "w1-c3-d5-minsize-shrink"
    primary_shard_count   = 2
    component             = "lifecycle-and-shard-max@custom.json"
    total_shards_per_node = 2
  }
  metrics = {
    lifecycle             = "w1-c3-d5-minsize-shrink"
    primary_shard_count   = 2
    component             = "lifecycle-and-shard@custom.json"
    total_shards_per_node = 2
  }
  elastic = {
    lifecycle             = "elastic" #custom lifecycle name, uses the embedded snapshot policy
    primary_shard_count   = 2
    component             = "lifecycle-and-shard-max@custom.json"
    total_shards_per_node = 2
  }
  metricbeat = {
    lifecycle             = "metricbeat" #custom lifecycle name, uses the embedded snapshot policy
    primary_shard_count   = 2
    component             = "lifecycle-and-shard-max@custom.json"
    total_shards_per_node = 2
  }
  elastic_monitoring = {
    lifecycle             = "elastic_monitoring" #custom lifecycle name, uses the embedded snapshot policy
    primary_shard_count   = 2
    component             = "lifecycle-and-shard-max@custom.json"
    total_shards_per_node = 2
  }
}