module "app_resources" {
  source   = "./.terraform/modules/__v4__/elastic_app_resources"
  for_each = local.configurations

  target_name   = var.prefix
  configuration = each.value.conf
  target_env    = var.env
  space_id      = elasticstack_kibana_space.kibana_space[each.value.space_name].space_id

  ilm_name = var.ilm[each.key]

  library_index_custom_path    = "${path.module}/default_library/index_component"
  library_index_package_path   = "${path.module}/default_library/index_component"
  library_ingest_pipeline_path = "${path.module}/default_library/ingest_pipeline"

  default_custom_component_name = "basic-only-lifecycle@custom"

  query_folder     = each.value.query_folder
  dashboard_folder = each.value.dashboard_folder

  application_name = each.key

  custom_index_component_parameters = {
    primary_shard_count   = var.primary_shard_count
    total_shards_per_node = var.total_shards_per_node
  }

  depends_on = [elasticstack_elasticsearch_index_lifecycle.index_lifecycle]
}

