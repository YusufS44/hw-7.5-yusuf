terraform {
  required_version = "~> 1.10"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "gcp-class-417400"
  region  = "us-central1"
}