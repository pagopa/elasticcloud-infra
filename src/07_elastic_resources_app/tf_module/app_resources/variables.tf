variable "prefix" {
  type = string
  validation {
    condition = (
      length(var.prefix) <= 6
    )
    error_message = "Max length is 6 chars."
  }
}

variable "configuration" {
  type = any
}

variable "default_snapshot_policy_name" {
  type = string
}

variable "space_id" {
  type = string
}

variable "env" {
  type = string
}



variable "default_ingest_pipeline_conf" {
  type = any
}

variable "default_ilm_conf" {
  type = any
}

variable "default_component_package_template" {
  type = any
}

variable "default_component_custom_template" {
  type = any
}

variable "query_folder" {
  type = string
}

variable "dashboard_folder" {
  type = string
}

variable "library_component_path" {
  type = string
}

variable "library_package_path" {
  type = string
}
