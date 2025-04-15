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

variable "default_ilm_logs" {
  type        = string
  description = "ILM used by default index templates via logs@custom"
}
variable "default_ilm_traces" {
  type        = string
  description = "ILM used by default index templates via traces@custom"
}
variable "default_ilm_metrics" {
  type        = string
  description = "ILM used by default index templates via metrics@custom"
}
variable "default_ilm_elastic" {
  type        = string
  description = "ILM used by default index templates via elastic@custom"
}
variable "default_ilm_metricbeat" {
  type        = string
  description = "ILM used by default index templates via metricbeat@custom"
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

variable "ilm_delete_wait_for_snapshot" {
  type        = bool
  description = "Wheather or not the delete phase of every lifecycle policy for this environment needs to wait for snapshot policy to run or not"
}

variable "alert_channels" {
  description = "Channels used to notify alerts"
  type = object({
    opsgenie = bool
    email    = bool
    log      = bool
    slack    = bool
  })
  default = {
    log      = true
    slack    = true
    email    = false
    opsgenie = false
  }
}



