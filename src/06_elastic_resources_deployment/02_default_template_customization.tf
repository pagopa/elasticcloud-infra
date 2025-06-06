locals {
  custom_licecycle_idx = {
    logs : { lifecycle : "${local.ilm_prefix}-${var.default_ilm_logs}-ilm", primary_shard_count = var.primary_shard_count, component = "lifecycle-and-shard@custom.json" },
    traces : { lifecycle : "${local.ilm_prefix}-${var.default_ilm_traces}-ilm", primary_shard_count = var.primary_shard_count, component = "lifecycle-and-shard@custom.json" },
    metrics : { lifecycle : "${local.ilm_prefix}-${var.default_ilm_metrics}-ilm", primary_shard_count = var.primary_shard_count, component = "lifecycle-and-shard@custom.json" },
    elastic : { lifecycle : "${local.ilm_prefix}-elastic-ilm", primary_shard_count = var.primary_shard_count, component = "lifecycle-and-shard@custom.json" },
    metricbeat : { lifecycle : "${local.ilm_prefix}-metricbeat-ilm", primary_shard_count = var.primary_shard_count, component = "lifecycle-and-shard@custom.json" },
    elastic_monitoring : { lifecycle : "${local.ilm_prefix}-elastic_monitoring-ilm", primary_shard_count = var.primary_shard_count, component = "lifecycle-and-shard@custom.json" }
  }

  custom_lifecycle_components = { for k, v in local.custom_licecycle_idx : k =>
    jsondecode(templatefile("${path.module}/custom_resources/index_component/${v.component}", {
      lifecycle           = v.lifecycle,
      name                = k
      primary_shard_count = try(v.primary_shard_count, 1)
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
