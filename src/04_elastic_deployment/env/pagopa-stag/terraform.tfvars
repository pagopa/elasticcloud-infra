prefix         = "pagopa"
env_short      = "s"
env            = "staging"
location       = "westeurope"
location_short = "weu"

shared_env = ["pagopa-dev", "pagopa-uat"]

# TODO riguardare insieme ai ragazzi
hot_config = {
  size       = "4g"
  zone_count = 2
}

warm_config = null
cold_config = null

#warm_config = {
#  size       = null
#  zone_count = null
#}
#
#cold_config = {
#  size       = null
#  zone_count = null
#}

elk_snapshot_sa = {
  blob_versioning_enabled    = false
  blob_delete_retention_days = 0
  backup_enabled             = false
  advanced_threat_protection = true
  replication_type           = "ZRS"
}

elasticsearch_version = "8.17.0"

integration_server = {
    size = "1g"
    zones = 1
}