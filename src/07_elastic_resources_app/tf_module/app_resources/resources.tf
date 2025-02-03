locals {
  data_streams    = { for d in var.configuration.dataStream : d => d }
  application_id  = "${var.configuration.id}-${var.env}"
  dashboards      = { for df in fileset("${var.dashboard_folder}", "/*.ndjson") : trimsuffix(basename(df), ".ndjson") => "${var.dashboard_folder}/${df}" }
  queries         = { for df in fileset("${var.query_folder}", "/*.ndjson") : trimsuffix(basename(df), ".ndjson") => "${var.query_folder}/${df}" }
  ilm             = lookup(var.configuration, "ilm", var.default_ilm_conf)

  index_custom_component = lookup(var.configuration, "customComponent", null) == null ? null : jsondecode(templatefile("${var.library_index_custom_path}/${var.configuration.customComponent}.json", {
    name = local.application_id
    pipeline = elasticstack_elasticsearch_ingest_pipeline.ingest_pipeline.name
    lifecycle = elasticstack_elasticsearch_index_lifecycle.index_lifecycle.name
  }))

  index_package_component = lookup(var.configuration, "packageComponent", null) == null ? null : jsondecode(templatefile("${var.library_index_package_path}/${var.configuration.packageComponent}.json", {
    name = local.application_id
  }))

  runtime_fields = { for field in lookup(var.configuration.dataView, "runtimeFields", {}) : field.name => {
    type          = field.runtimeField.type
    script_source = field.runtimeField.script.source
    }
  }

  #  default_component_package = jsondecode(templatefile(var.default_component_package_template, {
  #    name = local.application_id
  #  }))
  #  default_component_custom = jsondecode(templatefile(var.default_component_custom_template, {
  #    name      = local.application_id
  #    lifecycle = elasticstack_elasticsearch_index_lifecycle.index_lifecycle.name
  #    pipeline  = elasticstack_elasticsearch_ingest_pipeline.ingest_pipeline.name
  #  }))
}

resource "elasticstack_elasticsearch_ingest_pipeline" "ingest_pipeline" {
  name        = "${local.application_id}-pipeline"
  description = "Ingest pipeline for ${var.configuration.displayName}"

  processors = [for p in lookup(var.configuration, "ingestPipeline", var.default_ingest_pipeline_conf).processors : jsonencode(p)]
  on_failure = length(lookup(lookup(var.configuration, "ingestPipeline", var.default_ingest_pipeline_conf), "onFailure", [])) > 0 ? [for p in lookup(lookup(var.configuration, "ingestPipeline", var.default_ingest_pipeline_conf), "onFailure", []) : jsonencode(p)] : null
}

resource "elasticstack_elasticsearch_index_lifecycle" "index_lifecycle" {
  name = "${local.application_id}-ilm"

  hot {
    min_age = lookup(lookup(local.ilm, "hot", var.default_ilm_conf.hot), "minAge", var.default_ilm_conf.hot.minAge)
    rollover {
      max_age                = lookup(lookup(lookup(local.ilm, "hot", var.default_ilm_conf.hot), "rollover", var.default_ilm_conf.hot.rollover), "maxAge", var.default_ilm_conf.hot.rollover.maxAge)
      max_primary_shard_size = lookup(lookup(lookup(local.ilm, "hot", var.default_ilm_conf.hot), "rollover", var.default_ilm_conf.hot.rollover), "maxPrimarySize", var.default_ilm_conf.hot.rollover.maxPrimarySize)
    }
  }

  warm {
    min_age = lookup(lookup(local.ilm, "warm", var.default_ilm_conf.warm), "minAge", var.default_ilm_conf.warm.minAge)
    set_priority {
      priority = lookup(lookup(local.ilm, "warm", var.default_ilm_conf.warm), "setPriority", var.default_ilm_conf.warm.setPriority)
    }
  }

  cold {
    min_age = lookup(lookup(local.ilm, "cold", var.default_ilm_conf.cold), "minAge", var.default_ilm_conf.cold.minAge)
    set_priority {
      priority = lookup(lookup(local.ilm, "cold", var.default_ilm_conf.cold), "setPriority", var.default_ilm_conf.cold.setPriority)
    }
  }

  delete {
    min_age = lookup(lookup(local.ilm, "delete", var.default_ilm_conf.delete), "minAge", var.default_ilm_conf.delete.minAge)

    dynamic "wait_for_snapshot" {
      for_each = lookup(lookup(local.ilm, "delete", var.default_ilm_conf.delete), "waitForSnapshot", var.default_ilm_conf.delete.waitForSnapshot) ? [1] : []
      content {
        policy = var.default_snapshot_policy_name
      }
    }
    delete {
      delete_searchable_snapshot = lookup(lookup(local.ilm, "delete", var.default_ilm_conf.delete), "deleteSearchableSnapshot", var.default_ilm_conf.delete.deleteSearchableSnapshot)
    }
  }

  metadata = jsonencode({
    "managedBy" = "Terraform"
  })
}


resource "elasticstack_elasticsearch_component_template" "custom_index_component_default" {
  count = lookup(var.configuration, "customComponent", null) != null ? 1 : 0

  name = "${local.application_id}@custom"
  template {

    settings = jsonencode(lookup(local.index_custom_component.template, "settings", null))
    mappings = jsonencode(lookup(local.index_custom_component.template, "mappings", null))
  }

  metadata = jsonencode(lookup(local.index_custom_component, "_meta", null))
}

resource "elasticstack_elasticsearch_component_template" "package_index_component_default" {
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
    (lookup(var.configuration, "packageComponent", null) == "default" ? [elasticstack_elasticsearch_component_template.package_index_component_default[0].name] : []),
    (lookup(var.configuration, "customComponent", null) == "default" ? [elasticstack_elasticsearch_component_template.custom_index_component_default[0].name] : []),
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

    runtime_field_map = local.runtime_fields
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


