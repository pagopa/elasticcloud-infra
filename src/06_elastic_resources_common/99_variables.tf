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
  type = string
}

variable "env_short" {
  type = string
  validation {
    condition = (
      length(var.env_short) == 1
    )
    error_message = "Length must be 1 chars."
  }
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

variable "deployment_name" {
  type        = string
  description = "(Required) EC deployment name"
}

variable "snapshot_lifecycle_default" {
  description = "(Required) Identifier for the default snapshot lifecycle policy of the EC deployment."
  type = object({
    expire_after = string
  })
  default = {
    expire_after = "30d"
  }
}

variable "default_ilm" {
  type        = any
  description = "Defines the default Index Lifecycle Management (ILM) policy stages for an Elasticsearch deployment."
  default     = {}
}

variable "role_mappings" {
  type        = map(any)
  description = ""
  default     = {}
}


variable "default_snapshot_policy" {
  type = object({
    scheduling = optional(string, "0 30 1 * * ?")
    enabled    = bool
  })

  description = "Defines the properties of the default snapshot policy"
}
