prefix         = "arp4pa"
env_short      = "s"
env            = "staging"
location       = "westeurope"
location_short = "weu"

kv_name_org_ec = "paymon-u-ec-org-kv"
kv_rg_org_ec   = "paymon-u-ec-org-sec-rg"

shared_env = ["p4pa-dev", "p4pa-uat", "arc-dev", "arc-uat"]

elk_snapshot_sa = {
  blob_versioning_enabled    = false
  blob_delete_retention_days = 0
  backup_enabled             = false
  advanced_threat_protection = true
  replication_type           = "ZRS"
}
