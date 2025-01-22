prefix         = "pagopa"
env_short      = "s"
env            = "staging"
location       = "westeurope"
location_short = "weu"

shared_env = ["pagopa-dev", "pagopa-uat"]

# TODO riguardare insieme ai ragazzi
hot_config = {
  size       = "100g"
  zone_count = 2
}

warm_config = {
  size       = "100g"
  zone_count = 2
}

cold_config = {
  size       = "100g"
  zone_count = 2
}

elk_snapshot_sa = {
  blob_versioning_enabled    = false
  blob_delete_retention_days = 0
  backup_enabled             = false
  advanced_threat_protection = true
  replication_type           = "ZRS"
}
