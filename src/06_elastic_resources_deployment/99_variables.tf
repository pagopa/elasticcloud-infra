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

variable "default_ilm" {
  type        = string
  description = "ILM used by default index templates via logs@custom, traces@custom and metrics@custom"
}

variable "kv_name_org_ec" {
  type = string
}

variable "kv_rg_org_ec" {
  type = string
}

variable "elastic_apikey_env_short" {
  type        = string
  description = "Short env to be used when building the KV name to retrieve the elasticsearch api key"
}

variable "elastic_apikey_env" {
  type        = string
  description = "Env to be used when building the KV name to retrieve the elasticsearch api key"
}



