# general

variable "prefix" {
  type = string
  validation {
    condition = (
      length(var.prefix) <= 6
    )
    error_message = "Max length is 6 chars."
  }
}

variable "location" {
  type    = string
  default = "westeurope"
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

variable "azdo_iac_target_identities" {
  type = object({
    principal_ids = set(string)
    rg_name = string
  })
  description = "Object containing the AZDO managed identities principal ids and resource group name for the target subscription that must have access to this target keyvault"
}
