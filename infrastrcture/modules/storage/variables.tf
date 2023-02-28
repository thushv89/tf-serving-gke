variable "include_module_storage" {
  type = bool
  description = "If true it will include the storage module in apply/destroy"
}

variable "gcp_project_id" {
  type = string
  description = "GCP Project ID"
}

variable "gcp_region" {
  type = string
  description = "GCP region"
}
