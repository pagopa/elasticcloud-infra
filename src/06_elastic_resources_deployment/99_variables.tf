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
variable "default_ilm_elastic" {
  type        = string
  description = "ILM used by default index templates via elastic@custom"
}
variable "default_ilm_metricbeat" {
  type        = string
  description = "ILM used by default index templates via metricbeat@custom"
}
variable "default_ilm_elastic_monitoring" {
  type        = string
  description = "ILM used by default index templates via elastic_monitoring@custom"
}

variable "default_idx_tpl_customization" {
  type = map(object({
    lifecycle             = optional(string, "")
    primary_shard_count   = optional(number)
    component             = string,
    total_shards_per_node = optional(number)
  }))
  description = "(Required) Map of <index type> - <index component template parameters> to be used for default index templates customization. The key is the index type, the value is an object containing the lifecycle name, primary shard count, component name and total shards per node. The index type can be logs, traces, metrics, elastic, metricbeat or elastic_monitoring."
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


variable "alert_configuration" {
  description = "Alert configuration parameters"
  type = object({
    cluster_health = optional(object({
      threshold = optional(number, 85)
      duration  = optional(string, "30m")
      }), {
      threshold = 85
      duration  = "30m"
    })
    node_changed = optional(object({
      threshold = optional(number, 85)
      duration  = optional(string, "1h")
      }), {
      threshold = 85
      duration  = "1h"
    })
    node_cpu_usage = optional(object({
      threshold = optional(number, 90)
      duration  = optional(string, "30m")
      }), {
      threshold = 90
      duration  = "30m"
    })
    node_disk_usage = optional(object({
      threshold = optional(number, 95)
      duration  = optional(string, "5m")
      }), {
      threshold = 95
      duration  = "5m"
    })
    node_memory_usage = optional(object({
      threshold = optional(number, 85)
      duration  = optional(string, "30m")
      }), {
      threshold = 85
      duration  = "30m"
    })
    index_shard_size = optional(object({
      threshold = optional(number, 55)
      }), {
      threshold = 55
    })
  })
  default = {}
}

variable "app_connectors" {
  type = map(object({
    type       = string
    secret_key = string
  }))

  description = "(optional) Map of <connector name>-<connector details> for additional connectors dedicated to app alerts. supports slack and opsgenie type"

  default = {}

  validation {
    condition = (
      alltrue([for i in var.app_connectors : contains(["slack", "opsgenie"], i.type)])
    )
    error_message = "Only 'slack' and 'opsgenie' types are supported"
  }
}

