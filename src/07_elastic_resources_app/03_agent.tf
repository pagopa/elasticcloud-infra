resource "elasticstack_fleet_agent_policy" "kubernetes_policy" {
  name            = "Elastic Agent on ECK policy ${var.prefix}-${var.env}"
  namespace       = "${var.prefix}.${var.env}"
  description     = "Kubernetes log agent policy"
  sys_monitoring  = false
  monitor_logs    = true
  monitor_metrics = true
  policy_id       = "kubernetes-${var.prefix}-${var.env}"
}

resource "elasticstack_fleet_integration_policy" "kubernetes_integration_policy" {
  name                = "kubernetes-${var.prefix}-${var.env}"
  namespace           = "${var.prefix}.${var.env}"
  description         = "Integration policy for ${var.prefix}-${var.env} kube logs"
  agent_policy_id     = elasticstack_fleet_agent_policy.kubernetes_policy.policy_id
  integration_name    = data.elasticstack_fleet_integration.kubernetes.name
  integration_version = data.elasticstack_fleet_integration.kubernetes.version

  input {
    input_id     = "kubelet-kubernetes/metrics"
    streams_json = file("./agent/kubernetes-metric-kubelet.json")
    enabled      = true
  }
  input {
    input_id     = "kube-state-metrics-kubernetes/metrics"
    streams_json = file("./agent/kubernetes-state-metric.json")
    enabled      = true
  }
  input {
    input_id     = "kube-apiserver-kubernetes/metrics"
    streams_json = file("./agent/kubernetes-apiserver-metric.json")
    enabled      = true
  }
  input {
    input_id     = "kube-proxy-kubernetes/metrics"
    streams_json = file("./agent/kubernetes-proxy-metric.json")
    enabled      = true
  }
  input {
    input_id     = "kube-scheduler-kubernetes/metrics"
    streams_json = file("./agent/kubernetes-scheduler-metric.json")
    enabled      = true
  }
  input {
    input_id     = "kube-controller-manager-kubernetes/metrics"
    streams_json = file("./agent/kubernetes-controllermanager-metric.json")
    enabled      = true
  }
  input {
    input_id     = "events-kubernetes/metrics"
    streams_json = file("./agent/kubernetes-events-metric.json")
    enabled      = true
  }
  input {
    input_id     = "container-logs-filestream"
    streams_json = file("./agent/kubernetes-containerlog.json")
    enabled      = true
  }
  input {
    input_id     = "audit-logs-filestream"
    streams_json = file("./agent/kubernetes-audit-log.json")
    enabled      = true
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
    input_id     = "system-logfile"
    streams_json = file("./agent/system-logfile.json")
  }
  input {
    input_id     = "system-winlog"
    streams_json = file("./agent/system-winlog.json")
  }
  input {
    input_id     = "system-system/metrics"
    streams_json = file("./agent/system-systemmetrics.json")
  }
  input {
    input_id     = "system-httpjson"
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
      "anonymous_allow_agent" : [
        "rum-js",
        "js-base",
        "iOS/swift"
      ],
      "anonymous_allow_service" : [],
      "anonymous_enabled" : true,
      "anonymous_rate_limit_event_limit" : 300,
      "anonymous_rate_limit_ip_limit" : 1000,
      "api_key_enabled" : false,
      "api_key_limit" : 100,
      "capture_personal_data" : true,
      "enable_rum" : true,
      "expvar_enabled" : false,
      "host" : "localhost:8200",
      "idle_timeout" : "45s",
      "java_attacher_enabled" : false,
      "max_connections" : 0,
      "max_event_bytes" : 307200,
      "max_header_bytes" : 1048576,
      "pprof_enabled" : false,
      "read_timeout" : "3600s",
      "rum_allow_headers" : [],
      "rum_allow_origins" : [
        "\"*\""
      ],
      "rum_exclude_from_grouping" : "\"^/webpack\"",
      "rum_library_pattern" : "\"node_modules|bower_components|~\"",
      "shutdown_timeout" : "30s",
      "tail_sampling_enabled" : false,
      "tail_sampling_interval" : "1m",
      "tail_sampling_policies" : "- sample_rate: 0.1",
      "tail_sampling_storage_limit" : "3GB",
      "tls_cipher_suites" : [],
      "tls_curve_types" : [],
      "tls_enabled" : false,
      "tls_supported_protocols" : [
        "TLSv1.2",
        "TLSv1.3"
      ],
      "url" : "http://localhost:8200",
      "write_timeout" : "30s"
    })
  }
}


module "install_agent_cluster_1" {
  source = "./tf_module/agent"

  providers = {
    kubernetes = kubernetes.cluster_1
  }

  apm_integration_policy = {
    name = elasticstack_fleet_integration_policy.apm_integration_policy.name
    id   = elasticstack_fleet_integration_policy.apm_integration_policy.id
  }
  apm_package_version = data.ec_deployment.ec_deployment.integrations_server[0].version
  system_integration_policy = {
    name = elasticstack_fleet_integration_policy.system_integration_policy.name
    id   = elasticstack_fleet_integration_policy.system_integration_policy.id
  }
  system_package_version = data.elasticstack_fleet_integration.system.version
  k8s_integration_policy = {
    name = elasticstack_fleet_integration_policy.kubernetes_integration_policy.name
    id   = elasticstack_fleet_integration_policy.kubernetes_integration_policy.id
  }
  k8s_package_version = data.elasticstack_fleet_integration.kubernetes.version

  dedicated_log_instance_name  = var.dedicated_log_instance_name
  elastic_agent_kube_namespace = var.elastic_agent_kube_namespace
  elasticsearch_api_key        = data.azurerm_key_vault_secret.elasticsearch_api_key.value
  elasticsearch_host           = replace(data.ec_deployment.ec_deployment.elasticsearch[0].https_endpoint, ".es.", ".")
  # use the first aks name configured in the list
  k8s_kube_config_file_path = "${var.k8s_kube_config_path_prefix}/config-${var.aks_names[0]}"
  target                    = "${var.prefix}-${var.env}"
  target_namespace          = "${var.prefix}.${var.env}"
}


module "install_agent_cluster_2" {
  source = "./tf_module/agent"

  count = length(var.aks_names) > 1 ? 1 : 0

  providers = {
    kubernetes = kubernetes.cluster_2
  }

  apm_integration_policy = {
    name = elasticstack_fleet_integration_policy.apm_integration_policy.name
    id   = elasticstack_fleet_integration_policy.apm_integration_policy.id
  }
  apm_package_version = data.ec_deployment.ec_deployment.integrations_server[0].version
  system_integration_policy = {
    name = elasticstack_fleet_integration_policy.system_integration_policy.name
    id   = elasticstack_fleet_integration_policy.system_integration_policy.id
  }
  system_package_version = data.elasticstack_fleet_integration.system.version
  k8s_integration_policy = {
    name = elasticstack_fleet_integration_policy.kubernetes_integration_policy.name
    id   = elasticstack_fleet_integration_policy.kubernetes_integration_policy.id
  }
  k8s_package_version = data.elasticstack_fleet_integration.kubernetes.version

  dedicated_log_instance_name  = var.dedicated_log_instance_name
  elastic_agent_kube_namespace = var.elastic_agent_kube_namespace
  elasticsearch_api_key        = data.azurerm_key_vault_secret.elasticsearch_api_key.value
  elasticsearch_host           = replace(data.ec_deployment.ec_deployment.elasticsearch[0].https_endpoint, ".es.", ".")
  # use the second aks name configured in the list
  k8s_kube_config_file_path = "${var.k8s_kube_config_path_prefix}/config-${var.aks_names[1]}"
  target                    = "${var.prefix}-${var.env}"
  target_namespace          = "${var.prefix}.${var.env}"
}
