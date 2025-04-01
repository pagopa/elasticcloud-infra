locals {
  custom_licecycle_idx = {
    logs : var.default_ilm_logs,
    traces : var.default_ilm_traces,
    metrics : var.default_ilm_metrics
    elastic : var.default_ilm_elastic
  }

  custom_lifecycle_components = { for k, v in local.custom_licecycle_idx : k =>
    jsondecode(templatefile("${path.module}/custom_resources/index_component/basic-only-lifecycle@custom.json", {
      lifecycle = "${local.ilm_prefix}-${v}-ilm",
      name      = k
      }
  )) }
}

resource "elasticstack_elasticsearch_component_template" "custom_components_default_index_lifecycle" {
  depends_on = [elasticstack_elasticsearch_index_lifecycle.index_lifecycle, elasticstack_elasticsearch_index_lifecycle.deployment_index_lifecycle]
  for_each   = local.custom_lifecycle_components

  name = "${each.key}@custom"

  template {
    settings = lookup(each.value.template, "settings", null) != null ? jsonencode(lookup(each.value.template, "settings", null)) : null
    mappings = lookup(each.value.template, "mappings", null) != null ? jsonencode(lookup(each.value.template, "mappings", null)) : null
  }

  metadata = jsonencode(lookup(each.value, "_meta", null))
}
