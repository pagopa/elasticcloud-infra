variable "elastic_agent_kube_namespace" {
  type = string
  description = "Namespace where to install the elastic agent resources"
}

variable "dedicated_log_instance_name" {
  type = list(string)
  description = "List of namespaces or pod names for which the logs will be collected by the elastic agent"
}

variable "system_integration_policy" {
  type = object({
    name = string
    id   = string
  })
  description = "Details of the 'system' integration policy in elasticsearch"
}

variable "system_package_version" {
  type = string
  description = "Version of the 'system' integration package"
}

variable "k8s_integration_policy" {
  type = object({
    name = string
    id   = string
  })
    description = "Details of the 'kubernetes' integration policy in elasticsearch"

}

variable "k8s_package_version" {
  type = string
    description = "Version of the 'kubernetes' integration package"

}

variable "apm_integration_policy" {
  type = object({
    name = string
    id   = string
  })
    description = "Details of the 'apm' integration policy in elasticsearch"

}

variable "apm_package_version" {
  type = string
    description = "Version of the 'apm' integration package"

}

variable "target" {
  type = string
  description = "Identifier of a target within an elastic deployment, such as 'pagopa-dev' or 'arc-uat'"
}

variable "target_namespace" {
  type = string
    description = "Identifier of a target within an elastic deployment, expressed in an elastic namespace format, such as 'pagopa.dev' or 'arc.uat'"

  validation {
    condition = !strcontains(var.target_namespace, "-")
    error_message = "Target namespace must not contain '-'. Use '.' as separator"
  }

}

variable "elasticsearch_host" {
  type = string
  description = "Host where the elastic agent will send the collected logs/metrics"
}

variable "elasticsearch_api_key" {
  type      = string
  sensitive = true
  description = "Api key used by the elastic agent"
}