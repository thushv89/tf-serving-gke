output "service_account_gke_admin" {
  description = "GKE admin service account"
  value       = google_service_account.sa_gke_admin.email
}

output "service_account_gke_node" {
  description = "GKE node service account"
  value       = google_service_account.sa_gke_node.email
}