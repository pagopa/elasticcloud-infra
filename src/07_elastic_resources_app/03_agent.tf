resource "elasticstack_fleet_agent_policy" "kubernetes_policy" {
  name            = "Elastic Agent on ECK policy ${var.prefix}-${var.env}"
  namespace       = "${var.prefix}.${var.env}"
  description     = "Kubernetes log agent policy"
  sys_monitoring  = false
  monitor_logs    = true
  monitor_metrics = true
  policy_id = "kubernetes-${var.prefix}-${var.env}"
}

resource "elasticstack_fleet_integration_policy" "kubernetes_integration_policy" {
  name                = "kubernetes-${var.prefix}-${var.env}"
  namespace           = "${var.prefix}.${var.env}"
  description         = "Integration policy for ${var.prefix}-${var.env} kube logs"
  agent_policy_id     = elasticstack_fleet_agent_policy.kubernetes_policy.policy_id
  integration_name    = data.elasticstack_fleet_integration.kubernetes.name
  integration_version = data.elasticstack_fleet_integration.kubernetes.version

  input {
    input_id = "kubelet-kubernetes/metrics"
    streams_json = file("./agent/kubernetes-metric-kubelet.json")
    enabled = true
  }
  input {
    input_id = "kube-state-metrics-kubernetes/metrics"
    streams_json = file("./agent/kubernetes-state-metric.json")
    enabled = true
  }
  input {
    input_id = "kube-apiserver-kubernetes/metrics"
    streams_json = file("./agent/kubernetes-apiserver-metric.json")
    enabled = true
  }
  input {
    input_id = "kube-proxy-kubernetes/metrics"
    streams_json = file("./agent/kubernetes-proxy-metric.json")
    enabled = true
  }
  input {
    input_id = "kube-scheduler-kubernetes/metrics"
    streams_json = file("./agent/kubernetes-scheduler-metric.json")
    enabled = true
  }
  input {
    input_id = "kube-controller-manager-kubernetes/metrics"
    streams_json = file("./agent/kubernetes-controllermanager-metric.json")
    enabled = true
  }
  input {
    input_id = "events-kubernetes/metrics"
    streams_json = file("./agent/kubernetes-events-metric.json")
    enabled = true
  }
  input {
    input_id = "container-logs-filestream"
    streams_json = file("./agent/kubernetes-containerlog.json")
    enabled = true
  }
  input {
    input_id = "audit-logs-filestream"
    streams_json = file("./agent/kubernetes-audit-log.json")
    enabled = true
  }
}


resource "elasticstack_fleet_integration_policy" "system_integration_policy" {
  name                = "system-${var.prefix}-${var.env}"
  namespace           = "${var.prefix}.${var.env}"
  description         = "Integration policy for ${var.prefix}-${var.env} system logs"
  agent_policy_id     = elasticstack_fleet_agent_policy.kubernetes_policy.policy_id
  integration_name    = data.elasticstack_fleet_integration.system.name
  integration_version = data.elasticstack_fleet_integration.system.version


  input {
    input_id = "system-logfile"
    streams_json = file("./agent/system-logfile.json")
  }
  input {
    input_id = "system-winlog"
    streams_json = file("./agent/system-winlog.json")
  }
  input {
    input_id = "system-system/metrics"
    streams_json = file("./agent/system-systemmetrics.json")
  }
  input {
    input_id = "system-httpjson"
    streams_json = file("./agent/system-http.json")
  }

}

resource "elasticstack_fleet_integration_policy" "apm_integration_policy" {
  name                = "apm-${var.prefix}-${var.env}"
  namespace           = "${var.prefix}.${var.env}"
  description         = "Integration policy for ${var.prefix}-${var.env} APM"
  agent_policy_id     = elasticstack_fleet_agent_policy.kubernetes_policy.policy_id
  integration_name    = "apm"
  integration_version = data.ec_deployment.ec_deployment.integrations_server[0].version


  # configuration derived from cloud setup
  input {
    input_id = "apmserver-apm"
    vars_json = jsonencode({
        "anonymous_allow_agent": [
            "rum-js",
            "js-base",
            "iOS/swift"
        ],
        "anonymous_allow_service": [],
        "anonymous_enabled": true,
        "anonymous_rate_limit_event_limit": 300,
        "anonymous_rate_limit_ip_limit": 1000,
        "api_key_enabled": false,
        "api_key_limit": 100,
        "capture_personal_data": true,
        "enable_rum": true,
        "expvar_enabled": false,
        "host": "localhost:8200",
        "idle_timeout": "45s",
        "java_attacher_enabled": false,
        "max_connections": 0,
        "max_event_bytes": 307200,
        "max_header_bytes": 1048576,
        "pprof_enabled": false,
        "read_timeout": "3600s",
        "rum_allow_headers": [],
        "rum_allow_origins": [
            "\"*\""
        ],
        "rum_exclude_from_grouping": "\"^/webpack\"",
        "rum_library_pattern": "\"node_modules|bower_components|~\"",
        "shutdown_timeout": "30s",
        "tail_sampling_enabled": false,
        "tail_sampling_interval": "1m",
        "tail_sampling_policies": "- sample_rate: 0.1",
        "tail_sampling_storage_limit": "3GB",
        "tls_cipher_suites": [],
        "tls_curve_types": [],
        "tls_enabled": false,
        "tls_supported_protocols": [
            "TLSv1.2",
            "TLSv1.3"
        ],
        "url": "http://localhost:8200",
        "write_timeout": "30s"
    })
  }
}

resource "kubernetes_namespace" "agent_namespace" {
  metadata {
    name = var.elastic_agent_kube_namespace
  }
}

resource "kubernetes_manifest" "config_map" {
  depends_on = [kubernetes_namespace.agent_namespace]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/configMap.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "cluster_role_binding" {
  depends_on = [kubernetes_manifest.config_map]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/clusterRoleBinding.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "elastic_agent_role_binding" {
  depends_on = [kubernetes_manifest.cluster_role_binding]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/elasticAgentRoleBinding.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "elastic_agent_kubeadmin_role_binding" {
  depends_on = [kubernetes_manifest.elastic_agent_role_binding]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/elasticAgentKubeAdminRoleBinding.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "cluster_role" {
  depends_on = [kubernetes_manifest.elastic_agent_kubeadmin_role_binding]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/clusterRole.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "elastic_agent_role" {
  depends_on = [kubernetes_manifest.cluster_role]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/elasticAgentRole.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "elastic_agent_kubeadmin_role" {
  depends_on = [kubernetes_manifest.elastic_agent_role]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/elasticAgentKubeAdminRole.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "service_account" {
  depends_on = [kubernetes_manifest.elastic_agent_kubeadmin_role]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/serviceAccount.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "secret_api_key" {
  depends_on = [kubernetes_manifest.service_account]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/secret.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "daemon_set" {
  depends_on = [kubernetes_manifest.secret_api_key]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/daemonSet.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources", "metadata.annotations"]
}