prefix    = "pagopa"
env       = "dev"
env_short = "d"

deployment_name = "pagopa-s-weu-ec"

role_mappings = {
  adgroup-admin = {
    roles   = ["admin"]
    enabled = true
  }
  adgroup-developers = {
    roles   = ["editor"]
    enabled = true
  }
  adgroup-operations = {
    roles   = ["viewer"]
    enabled = true
  }
  adgroup-externals = {
    roles   = ["viewer"]
    enabled = true
  }
}
