locals {

  custom_lifecycle_components = { for k, v in var.default_idx_tpl_customization : k =>
    jsondecode(templatefile("${path.module}/custom_resources/index_component/${v.component}", {
      lifecycle             = try("${local.ilm_prefix}-${v.lifecycle}-ilm", ""),
      name                  = k
      primary_shard_count   = v.primary_shard_count
      total_shards_per_node = v.total_shards_per_node
      }
  )) }
}

resource "elasticstack_elasticsearch_component_template" "custom_components_default_index_lifecycle" {
  depends_on = [elasticstack_elasticsearch_index_lifecycle.deployment_index_lifecycle]
  for_each   = local.custom_lifecycle_components

  name = "${each.key}@custom"

  template {
    settings = lookup(each.value.template, "settings", null) != null ? jsonencode(lookup(each.value.template, "settings", null)) : null
    mappings = lookup(each.value.template, "mappings", null) != null ? jsonencode(lookup(each.value.template, "mappings", null)) : null
  }

  metadata = jsonencode(lookup(each.value, "_meta", null))
}
