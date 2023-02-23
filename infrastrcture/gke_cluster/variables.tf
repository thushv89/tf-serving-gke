variable "service_account_gke_admin" {
  type        = string
  description = "GKE service account email"
  default = "gke-admin@tf-serving-exploration.iam.gserviceaccount.com"
}

variable "cluster_name" {
  type = string
  default = "sd-cluster"
}

variable "cluster_location" {
  type = string
  default = "us-central1-c"
}