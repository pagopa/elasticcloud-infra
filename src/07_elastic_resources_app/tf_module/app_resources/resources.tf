locals {
  data_streams   = { for d in var.configuration.dataStream : d => d }
  application_id = "${var.application_name}-${var.env}"
  dashboards     = { for df in fileset("${var.dashboard_folder}", "/*.ndjson") : trimsuffix(basename(df), ".ndjson") => "${var.dashboard_folder}/${df}" }
  queries        = { for df in fileset("${var.query_folder}", "/*.ndjson") : trimsuffix(basename(df), ".ndjson") => "${var.query_folder}/${df}" }

  index_custom_component =  jsondecode(templatefile("${var.library_index_custom_path}/${lookup(var.configuration, "customComponent", var.default_custom_component_name)}.json", {
    name      = local.application_id
    pipeline  = elasticstack_elasticsearch_ingest_pipeline.ingest_pipeline.name
    lifecycle = "${var.prefix}-${var.env}-${var.ilm_name}-ilm"
  }))

  index_package_component = lookup(var.configuration, "packageComponent", null) == null ? null : jsondecode(templatefile("${var.library_index_package_path}/${var.configuration.packageComponent}.json", {
    name = local.application_id
  }))

  runtime_fields = { for field in lookup(var.configuration.dataView, "runtimeFields", {}) : field.name => {
    type          = field.runtimeField.type
    script_source = field.runtimeField.script.source
    }
  }

  ingest_pipeline = jsondecode(file("${var.library_ingest_pipeline_path}/${var.configuration.ingestPipeline}.json"))

}

resource "elasticstack_elasticsearch_ingest_pipeline" "ingest_pipeline" {
  name        = "${local.application_id}-pipeline"
  description = "Ingest pipeline for ${var.configuration.displayName}"

  processors = [for p in local.ingest_pipeline.processors : jsonencode(p)]
  on_failure = length(lookup(local.ingest_pipeline, "onFailure", [])) > 0 ? [for p in lookup(local.ingest_pipeline, "onFailure", []) : jsonencode(p)] : null
}

resource "elasticstack_elasticsearch_component_template" "custom_index_component" {
  name = "${local.application_id}@custom"
  template {

    settings = lookup(local.index_custom_component.template, "settings", null) != null ? jsonencode(lookup(local.index_custom_component.template, "settings", null)) : null
    mappings = lookup(local.index_custom_component.template, "mappings", null) != null ? jsonencode(lookup(local.index_custom_component.template, "mappings", null)) : null
  }

  metadata = jsonencode(lookup(local.index_custom_component, "_meta", null))
}

resource "elasticstack_elasticsearch_component_template" "package_index_component" {
  count = lookup(var.configuration, "packageComponent", null) != null ? 1 : 0

  name = "${local.application_id}@package"

  template {

    settings = jsonencode(lookup(local.index_package_component.template, "settings", null))
    mappings = jsonencode(lookup(local.index_package_component.template, "mappings", null))
  }

  metadata = jsonencode(lookup(local.index_package_component, "_meta", null))
}

resource "elasticstack_elasticsearch_index_template" "index_template" {
  name = "${local.application_id}-idxtpl"

  priority       = 500
  index_patterns = [var.configuration.indexTemplate.indexPattern]
  composed_of = concat(
    (lookup(var.configuration, "packageComponent", null) != null ? [elasticstack_elasticsearch_component_template.package_index_component[0].name] : []),
    [elasticstack_elasticsearch_component_template.custom_index_component.name]
  )

  data_stream {
    allow_custom_routing = false
    hidden               = false
  }

  template {
    mappings = jsonencode({
      "_meta" : {
        "package" : {
          "name" : "kubernetes"
        }
      }
    })
  }

  metadata = jsonencode({
    "description" = "Index template for ${local.application_id}"
  })
}


resource "elasticstack_elasticsearch_data_stream" "data_stream" {
  for_each = local.data_streams
  name     = each.value

  // make sure that template is created before the data stream
  depends_on = [
    elasticstack_elasticsearch_index_template.index_template
  ]
}


resource "elasticstack_kibana_data_view" "kibana_data_view" {
  space_id = var.space_id
  data_view = {
    id              = "log_${var.configuration.dataView.indexIdentifier}_${var.prefix}_${var.env}"
    name            = "Log ${var.configuration.dataView.indexIdentifier} ${var.prefix} ${var.env}"
    title           = "logs-${var.configuration.dataView.indexIdentifier}-*-${var.prefix}.${var.env}"
    time_field_name = "@timestamp"

    runtime_field_map = length(local.runtime_fields) != 0 ? local.runtime_fields : null
  }
}

resource "elasticstack_kibana_import_saved_objects" "dashboard" {
  for_each   = local.dashboards
  depends_on = [elasticstack_kibana_data_view.kibana_data_view]
  overwrite  = true
  space_id   = var.space_id
  file_contents = templatefile(each.value, {
    data_view = elasticstack_kibana_data_view.kibana_data_view.data_view.id
  })
}



resource "elasticstack_kibana_import_saved_objects" "query" {
  for_each   = local.queries
  depends_on = [elasticstack_kibana_data_view.kibana_data_view]

  overwrite = true
  space_id  = var.space_id

  file_contents = file(each.value)
}


