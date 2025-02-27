prefix    = "pagopa"
env       = "dev"
env_short = "d"

input_file = "./secret/pagopa-dev/configs.json"

azdo_iac_target_identities = [
  "0813e219-14a5-4b18-9eeb-5afc27bb70d7", # azdo-dev-pagopa-iac-deploy
  "c8afb8d6-507b-455e-a7f8-1a1672cf226e"  # azdo-dev-pagopa-iac-plan
]
