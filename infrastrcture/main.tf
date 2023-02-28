terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  project = local.data["gcp_project_id"]
  region  = local.data["gcp_region"]
}

provider "google" {
  alias  = "impersonation_helper"
  scopes = [
   "https://www.googleapis.com/auth/cloud-platform",
   "https://www.googleapis.com/auth/userinfo.email",
  ]
}

data "google_service_account_access_token" "default" {
 provider               	= google.impersonation_helper
 target_service_account 	= module.iam.service_account_gke_admin
 scopes                 	= ["userinfo-email", "cloud-platform"]
 # This depends_on is required, otherwise this may get executed
 # before adding the role ServiceAccountUser, leading to
 # googleapi: Error 403: terraform Permission 'iam.serviceAccounts.getAccessToken' denied on resource
 depends_on = [module.iam]
}

provider "google" {
  alias = "impersonated"
  project = local.data["gcp_project_id"]
  region  = local.data["gcp_region"]
  access_token	= data.google_service_account_access_token.default.access_token
  request_timeout 	= "60s"
}

locals {
  data = jsondecode(file(".gcp_config/basic_config.json"))
}

# file("../.gcp_config/credentials")

module "iam" {
  source = "./modules/iam"
  gcp_project_id = local.data["gcp_project_id"]
  gcp_user = local.data["gcp_user"]
}

module "gke_cluster" {
  source = "./modules/gke_cluster"

  # Example: https://developer.hashicorp.com/terraform/language/meta-arguments/module-providers
  providers = {
    google = google.impersonated
  }

  service_account_gke_node = module.iam.service_account_gke_node
}

module "storage" {
  source = "./modules/storage"
  gcp_project_id = local.data["gcp_project_id"]
  gcp_region = local.data["gcp_region"]
  include_module_storage = var.include_module_storage
}