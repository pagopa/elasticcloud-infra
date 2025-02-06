variable "otel_kube_namespace" {
  type        = string
  description = "Namespace where to install the elastic agent resources"
}

variable "opentelemetry_operator_helm_version" {
  type        = string
  description = "Helm chart version for otel operator"
}

variable "elasticsearch_apm_host" {
  type        = string
  description = "Host where the otel collector will send the collected apm"
}

variable "elasticsearch_api_key" {
  type        = string
  sensitive   = true
  description = "Api key used by the elastic agent"
}

variable "affinity_selector" {
  type = object({
    key   = string
    value = string
  })
  default     = null
  description = "Affinity selector configuration for opentelemetry pods"
}