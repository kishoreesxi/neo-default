# output "ip-address" {
#   value = google_compute_address.static_ip_address.address
# }

output "self_link" {
  description = "Self-link of the managed instance group"
  value       = module.mig.self_link
}

output "region" {
  description = "The GCP region to create and test resources in"
  value       = "us-central1"
}
