#TODO Possibilità di creare dei ruoli custom sugli indici

resource "elasticstack_elasticsearch_security_role_mapping" "kibana_admin" {
  name    = "${local.prefix_env_short}-elasticcloud-app-kibana-admin"
  enabled = true
  roles = [
    "kibana_admin"
  ]
  rules = jsonencode({
    all = [
      { field = { "realm.name" = local.prefix_env } },
      { field = { username = local.admins_email } }
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
      { field = { "realm.name" = local.prefix_env } },
      { field = { username = local.admins_email } }
    ]
  })
}

# Security role mapping
resource "elasticstack_elasticsearch_security_role_mapping" "custom_role_mappings" {
  for_each = var.role_mappings

  name    = "${local.prefix_env_short}-${each.key}"
  enabled = each.value.enabled
  roles   = [for i in each.value.roles : "${local.prefix_env}-${i}-role"]

  rules = jsonencode({
    all = [
      { field = { "realm.name" = local.prefix_env } },
      { field = { groups = data.azuread_group.adgroup[each.key].object_id } }
    ]
  })
  depends_on = [
    elasticstack_elasticsearch_security_role.admin_role,
    elasticstack_elasticsearch_security_role.editor_role,
    elasticstack_elasticsearch_security_role.viewer_role,
  ]
}

