prefix         = "pagopa"
env_short      = "s"
env            = "staging"
location       = "westeurope"
location_short = "weu"

kv_name_org_ec           = "paymon-u-ec-org-kv"
kv_rg_org_ec             = "paymon-u-ec-org-sec-rg"
elastic_apikey_env_short = "u"
elastic_apikey_env       = "uat"

default_ilm_elastic            = "w5-d5-lowsize"
default_ilm_metricbeat         = "w5-d5-lowsize"
default_ilm_elastic_monitoring = "w0-d3-lowsize"

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
    lifecycle             = "w5-d5-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard@custom.json"
    total_shards_per_node = 2
  }
  traces = {
    lifecycle             = "w5-d5-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-max@custom.json"
    total_shards_per_node = 2
  }
  metrics = {
    lifecycle             = "w5-d5-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard@custom.json"
    total_shards_per_node = 2
  }
  elastic = {
    lifecycle             = "w1-d5-embeddedsnapshot-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-max@custom.json"
    total_shards_per_node = 2
  }
  metricbeat = {
    lifecycle             = "w1-d5-embeddedsnapshot-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-max@custom.json"
    total_shards_per_node = 2
  }
  elastic_monitoring = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-max@custom.json"
    total_shards_per_node = 2
  }
  monitoring_beats = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-max@custom.json"
    total_shards_per_node = 2
  }
  # kubernetes metrics customization
  "metrics-kubernetes.pod" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.container" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.apiserver" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.volume" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.state_container" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.state_replicaset" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.state_deployment" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.system" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.state_namespace" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.state_service" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.event" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.state_daemonset" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.node" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.state_node" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.state_storageclass" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.state_persistentvolume" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.state_persistentvolumeclaim" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.state_job" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.state_statefulset" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.state_cronjob" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "metrics-kubernetes.resourcequota" = {
    lifecycle             = "w0-d3-lowsize"
    primary_shard_count   = 1
    component             = "lifecycle-and-shard-noreplica@custom.json"
    total_shards_per_node = 2
  }
  "logs-system.syslog" = {
    component = "noreplica@custom.json"
  }
  "metrics-elastic_agent.filebeat_input" = {
    component = "noreplica@custom.json"
  }
}