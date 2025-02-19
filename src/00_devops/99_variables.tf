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

variable "enabled_features" {
  type = object({
    kv = bool
  })
  default = {
    kv = false
  }
  description = "Features Flag enabled"
}
