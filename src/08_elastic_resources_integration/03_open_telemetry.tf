module "otel_cluster_1" {
  source = "./.terraform/modules/__v4__/open_telemetry"

  elasticsearch_api_key               = data.azurerm_key_vault_secret.elasticsearch_api_key.value
  elasticsearch_apm_host              = data.ec_deployment.deployment.integrations_server[0].https_endpoint
  opentelemetry_operator_helm_version = var.opentelemetry_operator_helm_version
  otel_kube_namespace                 = var.aks_config[0].otel.namespace
  create_namespace                    = var.aks_config[0].otel.create_ns
  grpc_receiver_port                  = var.aks_config[0].otel.receiver_port
  deployment_env                      = var.env
  elastic_namespace                   = "${var.prefix}.${var.env}"

  tail_sampling        = var.tail_sampling_configuration
  head_sampling        = var.head_sampling_configuration
  otlp_exporter_config = var.otel_exporter_config
  memory_limiter       = var.otel_collector_memory_limiter
  resources            = var.otel_collector_resources

  affinity_selector = var.aks_config[0].otel.affinity_selector

  providers = {
    kubectl = kubectl.cluster_1
    helm    = helm.cluster_1
  }
}

module "otel_cluster_2" {
  source = "./.terraform/modules/__v4__/open_telemetry"
  count  = length(var.aks_config) > 1 ? 1 : 0

  elasticsearch_api_key               = data.azurerm_key_vault_secret.elasticsearch_api_key.value
  elasticsearch_apm_host              = data.ec_deployment.deployment.integrations_server[0].https_endpoint
  opentelemetry_operator_helm_version = var.opentelemetry_operator_helm_version
  otel_kube_namespace                 = var.aks_config[1].otel.namespace
  create_namespace                    = var.aks_config[1].otel.create_ns
  grpc_receiver_port                  = var.aks_config[1].otel.receiver_port
  deployment_env                      = var.env
  elastic_namespace                   = "${var.prefix}.${var.env}"

  affinity_selector = var.aks_config[1].otel.affinity_selector

  tail_sampling        = var.tail_sampling_configuration
  head_sampling        = var.head_sampling_configuration
  otlp_exporter_config = var.otel_exporter_config
  memory_limiter       = var.otel_collector_memory_limiter
  resources            = var.otel_collector_resources

  providers = {
    kubectl = kubectl.cluster_2
    helm    = helm.cluster_2
  }
}


############

module "otel_lb_cluster_1" {
  source = "./.terraform/modules/__v4__/open_telemetry_scalable"

  elasticsearch_api_key               = data.azurerm_key_vault_secret.elasticsearch_api_key.value
  elasticsearch_apm_host              = data.ec_deployment.deployment.integrations_server[0].https_endpoint
  opentelemetry_operator_helm_version = var.opentelemetry_operator_helm_version
  operator_helm_release_name          = "opentelemetry-cloud-operator"
  otel_kube_namespace                 = var.aks_config[0].otel.namespace
  grpc_receiver_port                  = var.aks_config[0].otel.receiver_port
  deployment_env                      = var.env
  elastic_namespace                   = "${var.prefix}.${var.env}"

  # object of migration from old otel module to new scalable module
  install_operator = false
  create_namespace                    = false

  tail_sampling        = var.tail_sampling_configuration
  head_sampling        = var.head_sampling_configuration
  otlp_exporter_config = var.otel_exporter_config

  affinity_selector = var.aks_config[0].otel.affinity_selector

  load_balancer = {
    replicas = 2
    resources = {
      requests = { cpu = "100m", memory = "100Mi" }
      limits   = { cpu = "200m", memory = "200Mi" }
    }
  }

  sampling = {
    replicas = 3
    resources = {
      requests = { cpu = "100m", memory = "200Mi" }
      limits   = { cpu = "200m", memory = "200Mi" }
    }
    memory_limiter = var.otel_collector_memory_limiter
  }


  providers = {
    kubectl = kubectl.cluster_1
    helm    = helm.cluster_1
  }
}