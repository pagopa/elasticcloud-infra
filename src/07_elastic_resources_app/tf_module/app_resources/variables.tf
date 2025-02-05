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


variable "space_id" {
  type = string
}

variable "env" {
  type = string
}

variable "env_short" {
  type = string
}


variable "query_folder" {
  type = string
}

variable "dashboard_folder" {
  type = string
}

variable "library_index_custom_path" {
  type = string
}

variable "library_index_package_path" {
  type = string
}

variable "ilm_name" {
  type = string
}

variable "library_ingest_pipeline_path" {
  type = string
}

variable "default_custom_component_name" {
  type = string
}


variable "application_name" {
  type = string
}