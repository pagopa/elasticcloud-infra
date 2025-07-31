prefix         = "pagopa"
env_short      = "s"
env            = "staging"
location       = "westeurope"
location_short = "weu"

kv_name_org_ec = "paymon-u-ec-org-kv"
kv_rg_org_ec   = "paymon-u-ec-org-sec-rg"

shared_env = ["pagopa-dev", "pagopa-uat"]

hot_config = {
  size       = "8g"
  zone_count = 2
}

warm_config = {
  size       = "2g"
  zone_count = 2
}

kibana_config = {
  size       = "2g"
  zone_count = 2
}


coordinating_config = null

elk_snapshot_sa = {
  blob_versioning_enabled    = false
  blob_delete_retention_days = 0
  backup_enabled             = false
  advanced_threat_protection = true
  replication_type           = "ZRS"
}

elasticsearch_version = "8.17.0"

integration_server = {
  size  = "1g"
  zones = 1
}

hardware_profile = "azure-general-purpose"
