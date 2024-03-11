terraform {
  backend "gcs" {
    bucket = "demo-gcp-terraform"
    prefix = "terraform/tf-dev"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.18.0"
    }
  }
}