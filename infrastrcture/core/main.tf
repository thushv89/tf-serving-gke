terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  project = "tf-serving-exploration"
  region  = "us-central1"
}

resource "google_storage_bucket" "storage_bucket" {
  name          = "tf-serving-exploration-bucket"
  location      = "us-central1"
  force_destroy = true
}
