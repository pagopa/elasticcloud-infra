resource "elasticstack_elasticsearch_security_role" "admin_role" {
  name    = "${local.prefix_env}-admin-role"
  cluster = null

  indices {
    names = ["*-${local.elastic_namespace}"]
    privileges = [
      "auto_configure", "create", "create_doc", "create_index", "delete",
      "index", "maintenance", "manage", "manage_follow_index", "manage_leader_index",
      "monitor", "read", "view_index_metadata", "write"
    ]
  }


  dynamic "applications" {
    for_each = toset([
      { application = "kibana-.kibana",
        privileges = [
          "feature_visualize.all", "feature_discover.all", "feature_dashboard.all",
          "feature_canvas.all", "feature_ml.all", "feature_graph.all", "feature_maps.all",
          "feature_logs.all", "feature_infrastructure.all", "feature_apm.all", "feature_uptime.all",
        "feature_slo.all", "feature_dev_tools.all", "feature_indexPatterns.read", "feature_savedObjectsManagement.read"],
      resources = ["space:default", "space:*-${var.env}"] }
    ])
    content {
      application = applications.value.application
      privileges  = applications.value.privileges
      resources   = applications.value.resources
    }
  }

  metadata = jsonencode(local.tags)
}

resource "elasticstack_elasticsearch_security_role" "editor_role" {
  name    = "${local.prefix_env}-editor-role"
  cluster = null

  indices {
    names = ["*-${replace(local.prefix_env, "-", ".")}"]
    privileges = [
      "auto_configure", "create", "create_doc", "create_index", "delete",
      "index", "maintenance", "monitor", "read", "view_index_metadata", "write"
    ]
  }


  dynamic "applications" {
    for_each = toset([
      {
        application = "kibana-.kibana",
        privileges = [
          "feature_visualize.all", "feature_discover.all", "feature_dashboard.all",
          "feature_canvas.all", "feature_ml.all", "feature_graph.all", "feature_maps.all",
          "feature_logs.all", "feature_infrastructure.all", "feature_apm.all", "feature_uptime.all",
          "feature_slo.all", "feature_dev_tools.all", "feature_indexPatterns.read", "feature_savedObjectsManagement.read"
        ],
        resources = ["space:default", "space:*-${var.env}"]
      }
    ])
    content {
      application = applications.value.application
      privileges  = applications.value.privileges
      resources   = applications.value.resources
    }
  }

  metadata = jsonencode(local.tags)
}

resource "elasticstack_elasticsearch_security_role" "viewer_role" {
  name    = "${local.prefix_env}-viewer-role"
  cluster = null

  indices {
    names = ["*-${local.elastic_namespace}"]
    privileges = [
      "monitor", "read", "view_index_metadata",
    ]
  }


  dynamic "applications" {
    for_each = toset([
      {
        application = "kibana-.kibana",
        privileges  = ["space_read"],
        resources   = ["space:default", "space:*-${var.env}"]
      }
    ])
    content {
      application = applications.value.application
      privileges  = applications.value.privileges
      resources   = applications.value.resources
    }
  }

  metadata = jsonencode(local.tags)
}
