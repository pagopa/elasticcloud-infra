resource "elasticstack_kibana_space" "kibana_space" {
  for_each          = local.spaces
  space_id          = "${each.value}-${var.env}"
  name              = "${each.value}-${var.env}"
  description       = "Space for ${each.value}-${var.env}"
  disabled_features = []
}


module "app_resources" {
  source   = "./tf_module/app_resources"
  for_each = local.configurations

  prefix                       = var.prefix
  configuration                = each.value.conf
  env                          = var.env
  env_short                    = var.env_short
  space_id                     = elasticstack_kibana_space.kibana_space[each.value.space_name].space_id

  ilm_name                     = var.ilm[each.key]

  library_index_custom_path  = "${path.module}/default_library/index_component"
  library_index_package_path = "${path.module}/default_library/index_component"
  library_ingest_pipeline_path = "${path.module}/default_library/ingest_pipeline"

  default_custom_component_name = "basic-only-lifecycle@custom"
  elastic_namespace = "${var.prefix}.${var.env}"

  query_folder     = each.value.query_folder
  dashboard_folder = each.value.dashboard_folder

  application_name = each.key

  depends_on = [elasticstack_elasticsearch_index_lifecycle.index_lifecycle]
}




