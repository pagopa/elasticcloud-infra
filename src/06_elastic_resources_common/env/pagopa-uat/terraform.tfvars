prefix    = "pagopa"
env_short = "u"
env       = "uat"

deployment_name = "pagopa-s-weu-ec"

role_mappings = {
  pagopa-u-adgroup-admin      = ["admin"]
  pagopa-u-adgroup-developers = ["admin"]
  pagopa-u-adgroup-externals  = ["viewer"]
  pagopa-u-adgroup-operations = ["viewer"]
}

default_snapshot_policy = {
  enabled = false
}



