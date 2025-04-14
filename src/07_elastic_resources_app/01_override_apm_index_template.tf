locals {

  custom_lifecycle_components = { for k, v in var.apm_ilm : k =>
    jsondecode(templatefile("${path.module}/default_library/index_component/basic-only-lifecycle@custom.json", {
      lifecycle = "${local.prefix_env}-${v}-ilm",
      name      = k
      }
  )) }

}

resource "elasticstack_elasticsearch_component_template" "apm_components_logs_custom_index_lifecycle" {
  for_each = local.custom_lifecycle_components

  name = "logs-apm.app.${each.key}-${local.prefix_env}@custom"

  template {
    settings = lookup(each.value.template, "settings", null) != null ? jsonencode(lookup(each.value.template, "settings", null)) : null
    mappings = lookup(each.value.template, "mappings", null) != null ? jsonencode(lookup(each.value.template, "mappings", null)) : null
  }

  metadata = jsonencode(lookup(each.value, "_meta", null))
}

resource "elasticstack_elasticsearch_component_template" "apm_components_metrics_custom_index_lifecycle" {
  for_each = local.custom_lifecycle_components

  name = "metrics-apm.app.${each.key}-${local.prefix_env}@custom"

  template {
    settings = lookup(each.value.template, "settings", null) != null ? jsonencode(lookup(each.value.template, "settings", null)) : null
    mappings = lookup(each.value.template, "mappings", null) != null ? jsonencode(lookup(each.value.template, "mappings", null)) : null
  }

  metadata = jsonencode(lookup(each.value, "_meta", null))
}


resource "elasticstack_elasticsearch_index_template" "logs_apm_index_template" {
  depends_on = [elasticstack_elasticsearch_component_template.apm_components_logs_custom_index_lifecycle]
  for_each = var.apm_ilm

  name = "${local.prefix_env}-apm-logs-${each.key}-idxtpl"

  priority       = 500 # default template has priority 120
  index_patterns = ["logs-apm.app.${replace(each.key, "-", "_")}-${local.prefix_env}"]
  # does not use logs@custom, uses "logs-apm.app.${local.prefix_env}-${each.value}@custom" instead to customize specific ilm
  composed_of    = [
    "logs@mappings",
    "apm@mappings",
    "apm@settings",
    "apm-10d@lifecycled",
    "logs-apm@settings",
    "logs-apm.app-fallback@ilm",
    "ecs@mappings",
    "logs-apm.app@custom",
    "logs-apm.app.${each.key}-${local.prefix_env}@custom",
  ]

  data_stream {
    allow_custom_routing = false
    hidden               = false
  }

  template {
    mappings = file("${path.module}/default_library/index_template/logs_apm_mappings.json")
    settings = file("${path.module}/default_library/index_template/logs_apm_settings.json")
  }

  metadata = jsonencode({
    "description" = "Index template for ${local.prefix_env} logs-apm.app custom"
  })
}

resource "elasticstack_elasticsearch_index_template" "metrics_apm_index_template" {
  depends_on = [elasticstack_elasticsearch_component_template.apm_components_metrics_custom_index_lifecycle]
  for_each = var.apm_ilm

  name = "${local.prefix_env}-apm-metrics-${each.key}-idxtpl"

  priority       = 500 # default template has priority 120
  index_patterns = ["metrics-apm.app.${replace(each.key, "-", "_")}-${local.prefix_env}"]
  # does not use logs@custom, uses "logs-apm.app.${local.prefix_env}-${each.value}@custom" instead to customize specific ilm
  composed_of    = [
    "metrics@mappings",
    "apm@mappings",
    "apm@settings",
    "apm-90d@lifecycle",
    "metrics-apm@mappings",
    "metrics-apm@settings",
    "metrics-apm.app-fallback@ilm",
    "ecs@mappings",
    "metrics-apm.app@custom",
    "metrics-apm.app.${each.key}-${local.prefix_env}@custom",
  ]

  data_stream {
    allow_custom_routing = false
    hidden               = false
  }

  template {
    mappings = file("${path.module}/default_library/index_template/logs_apm_mappings.json")
    settings = file("${path.module}/default_library/index_template/logs_apm_settings.json")
  }

  metadata = jsonencode({
    "description" = "Index template for ${local.prefix_env} logs-apm.app custom"
  })
}