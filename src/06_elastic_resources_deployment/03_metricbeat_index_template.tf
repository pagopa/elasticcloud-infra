resource "elasticstack_elasticsearch_index_template" "metricbeat_index_template" {
  depends_on = [elasticstack_elasticsearch_component_template.custom_components_default_index_lifecycle]

  name = "metricbeat-idxtpl"

  priority       = 500
  index_patterns = ["metricbeat-*"]
  composed_of    = ["metricbeat@custom"]

  data_stream {
    allow_custom_routing = false
    hidden               = false
  }

  template {
    mappings = file("${path.module}/custom_resources/index_template/metricbeat_mappings.json")
    settings = file("${path.module}/custom_resources/index_template/metricbeat_settings.json")
  }

  metadata = jsonencode({
    "description" = "Index template for metricbeat"
  })
}