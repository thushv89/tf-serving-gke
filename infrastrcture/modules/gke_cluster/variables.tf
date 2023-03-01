variable "service_account_gke_node" {
  type        = string
  description = "GKE node service account email"
}

variable "cluster_name" {
  type = string
  default = "sd-cluster"
}

variable "cluster_location" {
  type = string
  default = "us-central1-c"
}