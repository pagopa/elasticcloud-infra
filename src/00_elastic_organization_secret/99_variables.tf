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
  type        = set(string)
  description = "Set of AZDO managed identities principal ids for the target subscription that must have access to this target keyvault"
}

