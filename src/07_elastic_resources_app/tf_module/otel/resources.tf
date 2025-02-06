resource "helm_release" "opentelemetry_operator_helm" {
  name       = "opentelemetry-cloud-operator"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-operator"
  version    = var.opentelemetry_operator_helm_version
  namespace  = var.otel_kube_namespace


  values = [
    templatefile("${path.module}/yaml/values.yaml", {
      affinity_selector = var.affinity_selector
    })
  ]
}


resource "kubectl_manifest" "otel_collector" {
  depends_on = [
    helm_release.opentelemetry_operator_helm
  ]
  yaml_body = templatefile("${path.module}/yaml/collector.yaml", {
    namespace    = var.otel_kube_namespace
    apm_api_key  = var.elasticsearch_api_key
    apm_endpoint = var.elasticsearch_apm_host
  })

  force_conflicts = true
  wait            = true
}
