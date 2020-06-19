
variable "project_id" {
  type        = string
  description = "The GCP project ID"
  default     = null
}

variable "region" {
  type        = string
  description = "Region used for GCP resources."
  default = null
}

variable "network" {
  type        = string
  description = "Name of the network to create resources in."
  default     = ""
}

# variable "firewall_project" {
#   type        = string
#   description = "Name of the project to create the firewall rule in. Useful for shared VPC. Default is var.project."
#   default     = ""
# }
variable "hostname" {
  description = "Hostname prefix for instances"
  default     = "neo4j"
}

variable "service_port" {
  type        = number
  description = "TCP port your service is listening on."
  default     = null
}

variable "target_tags" {
  description = "List of target tags to allow traffic using firewall rule."
  type        = list(string)
  default     = null
}

variable "target_service_accounts" {
  description = "List of target service accounts to allow traffic using firewall rule."
  type        = list(string)
  default     = null
}

variable "session_affinity" {
  type        = string
  description = "How to distribute load. Options are `NONE`, `CLIENT_IP` and `CLIENT_IP_PROTO`"
  default     = "NONE"
}

variable "disable_health_check" {
  type        = bool
  description = "Disables the health check on the target pool."
  default     = false
}

variable "health_check" {
  description = "Health check to determine whether instances are responsive and able to do work"
  type = object({
    check_interval_sec  = number
    healthy_threshold   = number
    timeout_sec         = number
    unhealthy_threshold = number
    port                = number
    request_path        = string
    host                = string
  })
  default = {
    check_interval_sec  = null
    healthy_threshold   = null
    timeout_sec         = null
    unhealthy_threshold = null
    port                = 7474
    request_path        = null
    host                = null
  }
}

variable "ip_address" {
  description = "IP address of the external load balancer, if empty one will be assigned."
  default     = null
}

variable "ip_protocol" {
  description = "The IP protocol for the frontend forwarding rule and firewall rule. TCP, UDP, ESP, AH, SCTP or ICMP."
  default     = "TCP"
}

variable "allowed_ips" {
  description = "The IP address ranges which can access the load balancer."
  default     = ["0.0.0.0/0"]
  type        = list(string)

}