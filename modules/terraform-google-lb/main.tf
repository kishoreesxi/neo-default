
locals {
  health_check_port = var.health_check["port"]
}

resource "google_compute_forwarding_rule" "neo4jfw_rule" {
  project               = var.project_id
  name                  = var.hostname
  target                = google_compute_target_pool.neo4jtp.self_link
  load_balancing_scheme = "EXTERNAL"
  port_range            = var.service_port
  region                = var.region
  ip_address            = var.ip_address
  ip_protocol           = var.ip_protocol
}

resource "google_compute_target_pool" "neo4jtp" {
  project          = var.project_id
  name             = var.hostname
  region           = var.region
  session_affinity = var.session_affinity

  health_checks = var.disable_health_check ? [] : [google_compute_http_health_check.neo4jhc.0.self_link]
}

resource "google_compute_http_health_check" "neo4jhc" {
  count   = var.disable_health_check ? 0 : 1
  project = var.project_id
  name    = "${var.hostname}-neo4jhc"

  check_interval_sec  = var.health_check["check_interval_sec"]
  healthy_threshold   = var.health_check["healthy_threshold"]
  timeout_sec         = var.health_check["timeout_sec"]
  unhealthy_threshold = var.health_check["unhealthy_threshold"]

  port         = local.health_check_port == null ? var.service_port : local.health_check_port
  request_path = var.health_check["request_path"]
  host         = var.health_check["host"]
}


# resource "google_compute_firewall" "neo4j-lb-fw" {
#   project = var.firewall_project == "" ? var.project_id : var.firewall_project
#   # project = var.project_id
#   name    = "${var.hostname}-vm-service"
#   network = var.network

#   allow {
#     protocol = lower(var.ip_protocol)
#     ports    = [var.service_port]
#   }

#   source_ranges = var.allowed_ips

#   target_tags = var.target_tags

#   target_service_accounts = var.target_service_accounts
# }

# resource "google_compute_firewall" "neo4j-hc-fw" {
#   count   = var.disable_health_check ? 0 : 1
#   project = var.firewall_project == "" ? var.project : var.firewall_project
#   # project = var.project_id
#   name    = "${var.hostname}-hc"
#   network = var.network

#   allow {
#     protocol = "tcp"
#     ports    = [local.health_check_port == null ? 80 : local.health_check_port]
#   }

#   source_ranges = ["35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22"]

#   target_tags = var.target_tags

#   target_service_accounts = var.target_service_accounts
# }