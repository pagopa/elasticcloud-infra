locals {
  custom_licecycle_idx = ["logs", "traces", "metrics"]
  custom_lifecycle_components = { for idx in local.custom_licecycle_idx : idx =>
    jsondecode(templatefile("${path.module}/custom_resources/index_component/basic-only-lifecycle@custom.json", {
      lifecycle = "${var.prefix}-${var.env}-${var.default_ilm}-ilm",
      name      = idx
      }
  )) }
}

resource "elasticstack_elasticsearch_component_template" "custom_components_default_index_lifecycle" {
  depends_on = [elasticstack_elasticsearch_index_lifecycle.index_lifecycle]
  for_each   = local.custom_lifecycle_components

  name = "${each.key}@custom"

  template {
    settings = lookup(each.value.template, "settings", null) != null ? jsonencode(lookup(each.value.template, "settings", null)) : null
    mappings = lookup(each.value.template, "mappings", null) != null ? jsonencode(lookup(each.value.template, "mappings", null)) : null
  }

  metadata = jsonencode(lookup(each.value, "_meta", null))
}
