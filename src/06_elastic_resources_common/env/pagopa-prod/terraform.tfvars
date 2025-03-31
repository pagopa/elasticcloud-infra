prefix    = "pagopa"
env_short = "p"
env       = "prod"


deployment_name = "pagopa-p-weu-ec"

role_mappings = {
  pagopa-p-adgroup-admin      = ["admin"]
  pagopa-p-adgroup-developers = ["editor"]
  pagopa-p-adgroup-externals  = ["viewer"]
  pagopa-p-adgroup-operations = ["viewer"]
}

default_snapshot_policy = {
  enabled = true
}



