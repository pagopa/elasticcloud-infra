prefix    = "pagopa"
env       = "dev"
env_short = "d"

ec_deployment_id = "782a6d595487581de53e0e115756957f"

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
