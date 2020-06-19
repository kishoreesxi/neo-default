
# Data Sources
data "google_compute_image" "image" {
  project = var.source_image != "" ? var.source_image_project : "rhel-cloud"
  name    = var.source_image != "" ? var.source_image : "rhel-7-v20200429"
}

data "google_compute_image" "image_family" {
  project = var.source_image_family != "" ? var.source_image_project : "rhel-cloud"
  family  = var.source_image_family != "" ? var.source_image_family : "rhel-7"
}

# Locals
locals {
  boot_disk = [
    {
      source_image = var.source_image != "" ? data.google_compute_image.image.self_link : data.google_compute_image.image_family.self_link
      disk_size_gb = var.disk_size_gb
      physical_block_size_bytes = "4096"
      disk_type    = var.disk_type
      auto_delete  = var.auto_delete
      boot         = "true"

    },
  ]

  all_disks = concat(local.boot_disk, var.additional_disk)

  # NOTE: Even if all the shielded_instance_config values are false, if the
  # config block exists and an unsupported image is chosen, the apply will fail
  # so we use a single-value array with the default value to initialize the block
  # only if it is enabled.
  shielded_vm_configs = var.enable_shielded_vm ? [true] : []
}

resource "google_compute_address" "ip_address" {
  # name = "internal-ip"
  name   = "static-ip"
  subnetwork   = "" /shared network url
  address_type = "INTERNAL"
  region       = var.region
}

# Instance Template
resource "google_compute_instance_template" "neo4j_tpl" {
  name_prefix             = "${var.name_prefix}-"
  project                 = var.project_id
  machine_type            = var.machine_type
  labels                  = var.labels
  metadata                = var.metadata
  tags                    = var.tags
  can_ip_forward          = var.can_ip_forward
  metadata_startup_script = var.startup_script
  region                  = var.region

  dynamic "disk" {
    for_each = local.all_disks
    content {
      auto_delete  = lookup(disk.value, "auto_delete", null)
      boot         = lookup(disk.value, "boot", null)
      device_name  = lookup(disk.value, "device_name", null)
      disk_name    = lookup(disk.value, "disk_name", null)
      disk_size_gb = lookup(disk.value, "disk_size_gb", null)
      disk_type    = lookup(disk.value, "disk_type", null)
      interface    = lookup(disk.value, "interface", null)
      mode         = lookup(disk.value, "mode", null)
      source       = lookup(disk.value, "source", null)
      source_image = lookup(disk.value, "source_image", null)
      type         = lookup(disk.value, "type", null)

      dynamic "disk_encryption_key" {
        for_each = lookup(disk.value, "disk_encryption_key", [])
        content {
          kms_key_self_link = lookup(disk_encryption_key.value, "kms_key_self_link", null)
        }
      }
    }
  }

  dynamic "service_account" {
    for_each = [var.service_account]
    content {
      email  = lookup(service_account.value, "email", null)
      scopes = lookup(service_account.value, "scopes", null)
    }
  }

  network_interface {
    # network            = var.network
    subnetwork         = var.subnetwork_name
    subnetwork_project = var.subnetwork_project
    network_ip = google_compute_address.ip_address.address
    dynamic "access_config" {
      for_each = var.access_config
      content {
        nat_ip       = access_config.value.nat_ip
        network_tier = access_config.value.network_tier
      }
    }
  }

  lifecycle {
    create_before_destroy = "true"
  }

  # scheduling must have automatic_restart be false when preemptible is true.
  scheduling {
    preemptible       = var.preemptible
    automatic_restart = ! var.preemptible
  }

  dynamic "shielded_instance_config" {
    for_each = local.shielded_vm_configs
    content {
      enable_secure_boot          = lookup(var.shielded_instance_config, "enable_secure_boot", shielded_instance_config.value)
      enable_vtpm                 = lookup(var.shielded_instance_config, "enable_vtpm", shielded_instance_config.value)
      enable_integrity_monitoring = lookup(var.shielded_instance_config, "enable_integrity_monitoring", shielded_instance_config.value)
    }
  }
}