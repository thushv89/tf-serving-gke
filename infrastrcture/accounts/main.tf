terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

locals {
  data = jsondecode(file("../.gcp_config/basic_config.json"))
}

provider "google" {
  project = local.data["gcp_project_id"]
  region  = local.data["gcp_region"]
}

resource "google_service_account" "sa" {
  account_id   = "gke-admin"
  display_name = "GKE Service Account (Admin)"
}

# Setting the correct role
resource "google_project_iam_binding" "binding_sa_gke_admin" {
  project = local.data["gcp_project_id"]
  role    = "roles/container.admin"

  members = [
    "serviceAccount:${google_service_account.sa.email}",
  ]
}

# Avoid Error: Error reading instance group manager returned as an instance group URL: "googleapi: Error 403: Required 'compute.instanceGroupManagers.get' permission for 'projects/tf-serving-exploration/zones/us-central1-f/instanceGroupManagers/gke-image-classifier-image-classifier-b20f612b-grp', forbidden"
resource "google_project_iam_binding" "binding_sa_compute_viewer" {
  project = local.data["gcp_project_id"]
  role    = "roles/compute.viewer"

  members = [
    "serviceAccount:${google_service_account.sa.email}",
  ]
}

# Avoid ERROR: (gcloud.container.clusters.create) ResponseError: code=400, message=The user does not have access to service account
resource "google_project_iam_binding" "binding_sa_user" {
  project = local.data["gcp_project_id"]
  role    = "roles/iam.serviceAccountUser"

  members = [
    "serviceAccount:${google_service_account.sa.email}",
  ]
}


# Bind user to impersonate the service account when needed
resource "google_service_account_iam_binding" "admin_account_iam" {
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.serviceAccountTokenCreator"

  members = [
    "user:${local.data["gcp_user"]}",
  ]
}