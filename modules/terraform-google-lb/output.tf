
output "target_pool" {
  description = "The `self_link` to the target pool resource created."
  value       = google_compute_target_pool.neo4jtp.self_link
}

output "Internal-ip" {
  description = "The external ip address of the forwarding rule."
  value       = google_compute_forwarding_rule.neo4jfw_rule.ip_address
}
