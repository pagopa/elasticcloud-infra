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
  type = map(object({
    roles   = list(string)
    enabled = bool
  }))
  description = ""
  default     = {}
}
