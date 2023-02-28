resource "google_storage_bucket" "storage_bucket" {
  count         = var.include_module_storage ? 1 : 0
  name          = "${var.gcp_project_id}-bucket"
  location      = var.gcp_region
  force_destroy = true
}
