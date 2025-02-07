prefix    = "pagopa"
env       = "dev"
env_short = "d"

ec_deployment_id = "40aa630967df5cec1062507ad080cc6b"

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
