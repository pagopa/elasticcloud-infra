module "otel_cluster_1" {
  source = "../../tf_module/otel"

  elasticsearch_api_key               = data.azurerm_key_vault_secret.elasticsearch_api_key.value
  elasticsearch_apm_host              = data.ec_deployment.deployment.integrations_server[0].https_endpoint
  opentelemetry_operator_helm_version = var.opentelemetry_operator_helm_version
  otel_kube_namespace                 = var.aks_config[0].otel.namespace
  create_namespace                    = var.aks_config[0].otel.create_ns
  grpc_receiver_port                  = var.aks_config[0].otel.receiver_port

  affinity_selector = var.aks_config[0].otel.affinity_selector

  providers = {
    kubectl = kubectl.cluster_1
    helm    = helm.cluster_1
  }
}

module "otel_cluster_2" {
  source = "../../tf_module/otel"
  count  = length(var.aks_config) > 1 ? 1 : 0

  elasticsearch_api_key               = data.azurerm_key_vault_secret.elasticsearch_api_key.value
  elasticsearch_apm_host              = data.ec_deployment.deployment.integrations_server[0].https_endpoint
  opentelemetry_operator_helm_version = var.opentelemetry_operator_helm_version
  otel_kube_namespace                 = var.aks_config[1].otel.namespace
  create_namespace                    = var.aks_config[1].otel.create_ns
  grpc_receiver_port                  = var.aks_config[0].otel.receiver_port

  affinity_selector = var.aks_config[1].otel.affinity_selector

  providers = {
    kubectl = kubectl.cluster_2
    helm    = helm.cluster_2
  }
}
