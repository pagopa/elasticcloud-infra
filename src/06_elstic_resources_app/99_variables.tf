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

variable "ec_deployment_id" {
  type        = string
  description = "(Required) identifier of EC deployment"
}

variable "default_snapshot_policy_name" {
  type        = string
  description = "(Required) default snapshot policy name"
  default     = "default-nightly-snapshots"
}

variable "lifecycle_policy_wait_for_snapshot" {
  type        = bool
  description = "(Optional) True if the index lifecycle policy has to wait for snapshots before deletion"
  default     = true
}

