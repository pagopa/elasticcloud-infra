#TODO Possibilità di creare dei ruoli custom sugli indici

# all users in realm as kibana admin
resource "elasticstack_elasticsearch_security_role_mapping" "application_users_as_kibana_admin" {
  name    = "${local.prefix_env_short}-elasticcloud-app-kibana-admin"
  enabled = true
  roles = [
    "kibana_admin"
  ]
  rules = jsonencode({
    all = [
      { field = { "realm.name" = local.prefix_env_short } },
    ]
  })
}

# admin users in realm as kibana superusers
resource "elasticstack_elasticsearch_security_role_mapping" "admins_as_superuser" {
  name    = "${local.prefix_env_short}-admins-as-superusers"
  enabled = true
  roles = [
    "superuser"
  ]
  rules = jsonencode({
    all = [
      { field = { "realm.name" = local.prefix_env_short } },
      { field = { username = local.admins_email } }
    ]
  })
}
