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

variable "location" {
  type        = string
  description = "One of westeurope, northeurope"
}

variable "location_short" {
  type = string
  validation {
    condition = (
      length(var.location_short) == 3
    )
    error_message = "Length must be 3 chars."
  }
  description = "One of wue, neu"
}

variable "shared_env" {
  type        = list(string)
  description = "List of environments contained in this deployment"
}

variable "hot_config" {
  type = object({
    size       = string
    zone_count = number
  })
  description = "Hot storage disk configuration"
}

variable "warm_config" {
  type = object({
    size       = string
    zone_count = number
  })
  description = "Warm storage disk configuration"
}

variable "cold_config" {
  type = object({
    size       = string
    zone_count = number
  })
  description = "Cold storage disk configuration"
}


variable "kibana_zone_count" {
  type        = number
  description = "Kibana AZ count"
  default     = 1
}


variable "elk_snapshot_sa" {
  type = object({
    blob_delete_retention_days = number
    backup_enabled             = bool
    blob_versioning_enabled    = bool
    advanced_threat_protection = bool
    replication_type           = optional(string, "LRS")
  })
  default = {
    blob_delete_retention_days = 30
    backup_enabled             = true
    blob_versioning_enabled    = true
    advanced_threat_protection = true
    replication_type           = "GZRS"
  }
}

variable "integration_server" {
  type = object({
    size = string
    zones = number
    size_resource = optional(string, "memory")
  })
}

variable "elasticsearch_version" {
  type = string
}