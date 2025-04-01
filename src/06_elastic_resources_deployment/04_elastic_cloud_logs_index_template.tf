resource "elasticstack_elasticsearch_index_template" "elastic_index_template" {
  depends_on = [elasticstack_elasticsearch_component_template.custom_components_default_index_lifecycle]

  name = "elastic-cloud-logs-idxtpl"

  priority       = 1500 #defalt template has priority 1000
  index_patterns = ["elastic-cloud-logs-8*"]
  composed_of    = ["elastic@custom"]

  data_stream {
    allow_custom_routing = false
    hidden               = false
  }

  template {
    mappings = file("${path.module}/custom_resources/index_template/elastic_cloud_logs_mappings.json")
    settings = file("${path.module}/custom_resources/index_template/elastic_cloud_logs_settings.json")
    alias {
      name = "filebeat-elastic-cloud-logs-8"
    }
  }

  metadata = jsonencode({
    "description" = "Index template for elastic cloud logs"
  })
}