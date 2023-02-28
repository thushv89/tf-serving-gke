terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

# To avoid Error: googleapi: Error 403: Insufficient regional quota to satisfy request: resource "SSD_TOTAL_GB": request requires '300.0' and is short '50.0'. project has a quota of '250.0' with '250.0' available. View and manage quotas at https://console.cloud.google.com/iam-admin/quotas?usage=USED&project=tf-serving-exploration., forbidden
# set the location to a zone than a region
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.cluster_location

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "sd-node-pool"
  location   = var.cluster_location
  cluster    = google_container_cluster.primary.name
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  node_config {
    preemptible  = true
    machine_type = "n2-standard-4"
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = var.service_account_gke_node
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }
}

