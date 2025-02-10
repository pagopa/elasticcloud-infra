variable "prefix" {
  type = string
  validation {
    condition = (
      length(var.prefix) <= 6
    )
    error_message = "Max length is 6 chars."
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
}

variable "deployment_name" {
  type        = string
  description = "One of westeurope, northeurope"
}

variable "location" {
  type        = string
  description = "One of wue, neu"
}

variable "federated_entra_groups" {
  type        = list(string)
  description = "List of Microsoft Entra group names to be added to this environment application"
}