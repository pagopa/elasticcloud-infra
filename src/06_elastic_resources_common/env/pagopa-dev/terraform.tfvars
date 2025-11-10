prefix    = "pagopa"
env       = "dev"
env_short = "d"

deployment_name = "pagopa-s-weu-ec"

role_mappings = {
  pagopa-d-adgroup-admin      = ["admin"]
  pagopa-d-adgroup-developers = ["admin"]
  pagopa-d-adgroup-externals  = ["viewer"]
  pagopa-d-adgroup-operations = ["viewer"]
}

default_snapshot_policy = {
  enabled = false
}


