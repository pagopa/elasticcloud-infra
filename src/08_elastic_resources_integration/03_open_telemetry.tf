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
  labels = {
    domain = "core" # Icinga Business Process domain (continuos-platform-monitoring-app)
  }
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
  labels = {
    domain = "core" # Icinga Business Process domain (continuos-platform-monitoring-app)
  }

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
# OpenTelemetry Load Balancer module
############


# FIXME temporary locals, revert to var.aks_config[0].otel when migration completed
locals {
  otel_lb_namespace_aks1        = "otel"
  otel_lb_create_namespace_aks1 = true
}

module "otel_lb_cluster_1" {
  source = "./.terraform/modules/__v4__/open_telemetry_scalable"

  count = var.otel_lb_enabled ? 1 : 0

  elasticsearch_api_key               = data.azurerm_key_vault_secret.elasticsearch_api_key.value
  elasticsearch_apm_host              = data.ec_deployment.deployment.integrations_server[0].https_endpoint
  opentelemetry_operator_helm_version = var.opentelemetry_operator_helm_version
  operator_helm_release_name          = "opentelemetry-cloud-operator"
  otel_kube_namespace                 = local.otel_lb_namespace_aks1 # FIXME var.aks_config[0].otel.namespace
  grpc_receiver_port                  = var.aks_config[0].otel.receiver_port
  deployment_env                      = var.env
  elastic_namespace                   = "${var.prefix}.${var.env}"
  labels = {
    domain = "core" # Icinga Business Process domain (continuos-platform-monitoring-app)
  }
  tail_sampling        = var.tail_sampling_configuration
  head_sampling        = var.head_sampling_configuration
  otlp_exporter_config = var.otel_exporter_config
  affinity_selector    = var.aks_config[0].otel.affinity_selector
  load_balancer        = var.otel_lb_cl1_load_balancer
  sampling = {
    replicas       = var.otel_lb_cl1_sampling.replicas
    resources      = var.otel_lb_cl1_sampling.resources
    memory_limiter = var.otel_collector_memory_limiter
  }

  # object of migration from old otel module to new scalable module
  install_operator = false                               # FIXME true
  create_namespace = local.otel_lb_create_namespace_aks1 # FIXME var.aks_config[0].otel.create_ns

  providers = {
    kubectl = kubectl.cluster_1
    helm    = helm.cluster_1
  }
}

module "otel_lb_cluster_2" {
  source = "./.terraform/modules/__v4__/open_telemetry_scalable"
  count  = length(var.aks_config) > 1 && var.otel_lb_enabled ? 1 : 0

  elasticsearch_api_key               = data.azurerm_key_vault_secret.elasticsearch_api_key.value
  elasticsearch_apm_host              = data.ec_deployment.deployment.integrations_server[0].https_endpoint
  opentelemetry_operator_helm_version = var.opentelemetry_operator_helm_version
  operator_helm_release_name          = "opentelemetry-cloud-operator"
  otel_kube_namespace                 = var.aks_config[1].otel.namespace
  grpc_receiver_port                  = var.aks_config[1].otel.receiver_port
  deployment_env                      = var.env
  elastic_namespace                   = "${var.prefix}.${var.env}"
  labels = {
    domain = "core" # Icinga Business Process domain (continuos-platform-monitoring-app)
  }
  tail_sampling        = var.tail_sampling_configuration
  head_sampling        = var.head_sampling_configuration
  otlp_exporter_config = var.otel_exporter_config
  affinity_selector    = var.aks_config[1].otel.affinity_selector
  load_balancer        = var.otel_lb_cl2_load_balancer
  sampling = {
    replicas       = var.otel_lb_cl2_sampling.replicas
    resources      = var.otel_lb_cl2_sampling.resources
    memory_limiter = var.otel_collector_memory_limiter
  }

  # object of migration from old otel module to new scalable module
  install_operator = var.otel_lb_install_operator # FIXME true
  create_namespace = false                        # FIXME var.aks_config[1].otel.create_ns

  providers = {
    kubectl = kubectl.cluster_2
    helm    = helm.cluster_2
  }
}