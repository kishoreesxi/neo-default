#versions of terraform

terraform {
  required_version = "~> 0.12.6"
  required_providers {
    google = ">= 2.7, <4.0"
  }
}