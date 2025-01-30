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
  type = string
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




variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

###

variable "input_file" {
  type        = string
  description = "secret json file"
}

variable "enable_iac_pipeline" {
  type        = bool
  description = "If true create the key vault policy to allow used by azure devops iac pipelines."
  default     = false
}


variable "kv-key-permissions-read" {
  type        = list(string)
  description = "List of read key permissions"
  default     = ["Get", "List"]
}

variable "kv-secret-permissions-read" {
  type        = list(string)
  description = "List of read secret permissions"
  default     = ["Get", "List"]
}

variable "kv-certificate-permissions-read" {
  type        = list(string)
  description = "List of read certificate permissions"
  default     = ["Get", "GetIssuers", "List", "ListIssuers"]
}

variable "kv-storage-permissions-read" {
  type        = list(string)
  description = "List of read storage permissions"
  default     = ["Get", "GetSAS", "List", "ListSAS"]
}
