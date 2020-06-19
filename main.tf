provider "google" {
    credentials = var.usr-credentials
    project     = var.project_id
    region      = var.region
}

terraform {
  required_version = ">= 0.12"
}

resource "google_compute_address" "ext_ip_address" {
  name = "external-ip"
  address_type = "EXTERNAL"
  region       = var.region
}

locals {
  access_config = {
    nat_ip       = google_compute_address.ext_ip_address.address
    network_tier = "PREMIUM"
  }
}

module "instance_template" {
  source          = "./modules/instance_template"
  # access_config   = [local.access_config]
  additional_disk   = var.additional_disk
  auto_delete      = false
  disk_size_gb    = var.disk_size_gb
  disk_type       = var.disk_type
  physical_block_size_bytes = var.physical_block_size_bytes
  preemptible      = false
  machine_type    = var.machine_type
  name_prefix     = var.name_prefix
  # network         = var.network
  project_id      = var.project_id
  region          = var.region
  service_account = var.service_account
  source_image_family = var.source_image_family
  source_image    = var.source_image
  source_image_project = var.source_image_project
  startup_script  = file("./startup-neo4j.sh")
  subnetwork_name      = var.subnetwork_name
  subnetwork_project = var.subnetwork_project
}

module "mig" {
  source            = "./modules/mig"
  project_id        = var.project_id
  region            = var.region
  target_size       = var.target_size
  hostname          = var.hostname
  instance_template = module.instance_template.self_link

  health_check = var.health_check
  named_ports = [{
    name = "http"
    port = "7474"
  }]
  target_pools      = [module.load_balancer.target_pool]
}

module "load_balancer" {
  source       = "./modules/terraform-google-lb"
  region       = var.region
  project_id   = var.project_id
  hostname     = var.hostname
  service_port = 7474
  target_tags  = ["allow-lb-service"]
  network      = var.network  // VPC name
  health_check = var.health_check
}
