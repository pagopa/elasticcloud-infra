variable "elastic_agent_kube_namespace" {
  type = string
}

variable "dedicated_log_instance_name" {
  type = list(string)
}

variable "system_integration_policy" {
  type = object({
    name = string
    id   = string
  })
}

variable "system_package_version" {
  type = string
}

variable "k8s_integration_policy" {
  type = object({
    name = string
    id   = string
  })
}

variable "k8s_package_version" {
  type = string
}

variable "apm_integration_policy" {
  type = object({
    name = string
    id   = string
  })
}

variable "apm_package_version" {
  type = string
}

variable "target" {
  type = string
}

variable "target_namespace" {
  type = string
}

variable "elasticsearch_host" {
  type = string
}

variable "elasticsearch_api_key" {
  type      = string
  sensitive = true
}

variable "k8s_kube_config_file_path" {
  type = string
}