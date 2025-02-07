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

variable "ec_deployment_id" {
  type        = string
  description = "(Required) identifier of EC deployment"
}

variable "lifecycle_policy_wait_for_snapshot" {
  type        = bool
  description = "(Optional) True if the index lifecycle policy has to wait for snapshots before deletion"
  default     = true
}

variable "k8s_kube_config_path_prefix" {
  type        = string
  default     = "~/.kube"
  description = "(Optional) path to the kube config folder"
}

variable "aks_names" {
  type = list(object({
    name = string
    affinity_selector = optional(object({
      key   = string
      value = string
    }), null)
  }))

  description = "(Required) list of aks cluster names where the elstic agent will be installed. must not be empty, must not be mode than 2 elements"

  validation {
    condition     = length(var.aks_names) <= 2
    error_message = "Currently more than 2 cluster is not supported. Please open a ticket to @payments-cloud-admin to request an increase"
  }

  validation {
    condition     = length(var.aks_names) == length(toset([for n in var.aks_names : n.name]))
    error_message = "Aks names elements must be unique"
  }
}

variable "k8s_application_log_instance_names" {
  type        = list(string)
  description = "(Required) List of app namespaces or pod names for which the elastic agent will send logs"
}

variable "elastic_agent_kube_namespace" {
  type        = string
  description = "(Required) Kubernetes namespace where to install all the resources needed for the elastic agent"
}

variable "otel_kube_namespace" {
  type        = string
  description = "(Required) Kubernetes namespace where to install all the resources needed for the open telemetry"
}

variable "ilm" {
  type        = map(string)
  description = "(Required) Map containing all the application name for this environment associated to the related index lifecicle management policy to be used for that application. The allowed values are the file names in `default_library/ilm` folder"

  validation {
    condition     = alltrue([for v in values(var.ilm) : !strcontains(v, ".json")])
    error_message = "One or more ilm contains file extension. Use the file name only"
  }

  validation {
    condition     = alltrue([for v in values(var.ilm) : fileexists("${path.module}/default_library/ilm/${v}.json")])
    error_message = "One or mode ilm defined does not have the corresponding file configured in the library"
  }
}

variable "opentelemetry_operator_helm_version" {
  type        = string
  description = "Open telemetry operator version"
  default     = "0.24.3"
}

variable "ilm_delete_wait_for_snapshot" {
  type        = bool
  description = "Wheather or not the delete phase of every lifecycle policy for this environment needs to wait for snapshot policy to run or not"
}

