prefix          = "pagopa"
env_short       = "p"
env             = "prod"
location        = "westeurope"
location_short  = "weu"
location_string = "West Europe"

kv_name_org_ec = "paymon-p-ec-org-kv"
kv_rg_org_ec   = "paymon-p-ec-org-sec-rg"

shared_env = ["pagopa-prod"]


hot_config = {
  size       = "8g"
  zone_count = 3
}

warm_config = {
  size       = "4g"
  zone_count = 3
}
cold_config = {
  size       = "8g"
  zone_count = 3
}
kibana_config = {
  size       = "2g"
  zone_count = 3
}
integration_server = {
  size                  = "1g"
  zones                 = 3
  configuration_version = "3"
}
master_config = {
  size       = "2g"
  zone_count = 3
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



