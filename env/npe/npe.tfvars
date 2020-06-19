# details of compute instance. 

project_id = ""
name_prefix = "npe-non-prod"
region  = "us-central1"
zone    = "us-central1-a"
# name    = "neo4j-disk"
# static_ip_name = "static-ip-address"
machine_type = "n1-standard-1"
# image = "rhel-cloud/rhel-8-v20200521"
source_image = "rhel-7-v20200429"
source_image_family = "rhel-7"
source_image_project = "rhel-cloud"
disk_type = "pd-ssd"
disk_size_gb = "60"
auto_delete = false
physical_block_size_bytes = "4096"
# allow_stopping_for_update = true
additional_disk = [{
      auto_delete  = false,
      boot         = false,
      disk_size_gb = 60,
      disk_type    = "pd-ssd",
      source_image_family = "rhel-7",
      source_image    = "rhel-7-v20200429",
      physical_block_size_bytes = 4096,
      source_image_project = "rhel-cloud"
  }]
network = ""
subnetwork_name = ""
subnetwork_project = ""
service_account = {
    email           = ""
    scopes          = ["cloud-platform"]
}
target_size = "1"
# ports = ["7474", "7473", "7687"]
environment = "NPE"
hostname = "neo4j"

health_check = {
    type                = "tcp"
    initial_delay_sec   = 30
    check_interval_sec  = 30
    healthy_threshold   = 1
    timeout_sec         = 10
    unhealthy_threshold = 5
    service_port        = 7474
    port                = 80
    response            = ""
    proxy_header        = "NONE"
    request             = ""
    request_path        = "/"
    host                = ""

}