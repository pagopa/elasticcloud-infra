variable "prefix" {
  type = string
  validation {
    condition = (
      length(var.prefix) <= 6
    )
    error_message = "Max length is 6 chars."
  }
}

variable "env" {
  type        = string
  description = "(Required) Environment name"

  validation {
    condition     = contains(["dev", "uat", "prod"], var.env)
    error_message = "Env allowed values are: dev, uat, prod"
  }
}

variable "env_short" {
  type = string
  validation {
    condition = (
      length(var.env_short) == 1
    )
    error_message = "Length must be 1 chars."
  }

  validation {
    condition     = contains(["d", "u", "p"], var.env_short)
    error_message = "Env allowed values are: d, u, p"
  }
}

variable "deployment_name" {
  type        = string
  description = "(Required) EC deployment name"
}


variable "aks_config" {
  type = list(object({
    name = string
    elastic_agent = object({
      namespace = string
      create_ns = bool
      tolerated_taints = optional(list(object({
        key    = string
        effect = optional(string, "NoSchedule")
      })), [])
    })
    otel = object({
      namespace = string
      create_ns = bool
      affinity_selector = optional(object({
        key   = string
        value = string
      }), null)
      receiver_port = optional(string, "4317")
    })
  }))

  description = "(Required) list of aks cluster configurations where the elstic agent and otel will be installed. must not be empty, must not be more than 2 elements"

  validation {
    condition     = length(var.aks_config) <= 2
    error_message = "Currently more than 2 cluster is not supported. Please open a ticket to @payments-cloud-admin to request an increase"
  }

  validation {
    condition     = length(var.aks_config) == length(toset([for n in var.aks_config : n.name]))
    error_message = "Aks names elements must be unique"
  }
}

variable "k8s_kube_config_path_prefix" {
  type        = string
  default     = "~/.kube"
  description = "(Optional) path to the kube config folder"
}

variable "k8s_application_log_instance_names" {
  type        = list(string)
  description = "(Required) List of app namespaces or pod names for which the elastic agent will send logs"
}

variable "opentelemetry_operator_helm_version" {
  type        = string
  description = "Open telemetry operator version"
  default     = "0.24.3"
}


variable "apm_sampling" {
  type = object({
    enabled       = bool
    rate          = number
    storage_limit = string
  })
  default = {
    enabled       = false
    rate          = 0.1
    storage_limit = "3GB"
  }
}

