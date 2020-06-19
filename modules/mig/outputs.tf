output "self_link" {
  description = "Self-link of managed instance group"
  value       = google_compute_region_instance_group_manager.mig.self_link
}

output "instance_group" {
  description = "Instance-group url of managed instance group"
  value       = google_compute_region_instance_group_manager.mig.instance_group
}