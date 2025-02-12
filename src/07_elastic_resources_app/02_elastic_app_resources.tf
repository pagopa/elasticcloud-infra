resource "elasticstack_kibana_space" "kibana_space" {
  for_each          = local.spaces
  space_id          = "${each.value}-${var.env}"
  name              = "${each.value}-${var.env}"
  description       = "Space for ${each.value}-${var.env}"
  disabled_features = []
}

resource "elasticstack_kibana_data_view" "kibana_apm_data_view" {
  for_each = local.spaces

  space_id = elasticstack_kibana_space.kibana_space[each.key].id
  data_view = {
    id              = "apm_${each.key}"
    name            = "APM ${each.key}"
    title           = "traces-apm*,apm-*,traces-*.otel-*,logs-apm*,apm-*,logs-*.otel-*,metrics-apm*,apm-*,metrics-*.otel-*"
    time_field_name = "@timestamp"
  }
}



module "app_resources" {
  source   = "./tf_module/app_resources"
  for_each = local.configurations

  target_name      = var.prefix
  configuration    = each.value.conf
  target_env       = var.env
  space_id         = elasticstack_kibana_space.kibana_space[each.value.space_name].space_id
  apm_data_view_id = elasticstack_kibana_data_view.kibana_apm_data_view[each.value.space_name].data_view.id

  ilm_name = var.ilm[each.key]

  library_index_custom_path    = "${path.module}/default_library/index_component"
  library_index_package_path   = "${path.module}/default_library/index_component"
  library_ingest_pipeline_path = "${path.module}/default_library/ingest_pipeline"

  default_custom_component_name = "basic-only-lifecycle@custom"

  query_folder     = each.value.query_folder
  dashboard_folder = each.value.dashboard_folder

  application_name = each.key

  depends_on = [elasticstack_elasticsearch_index_lifecycle.index_lifecycle]
}




