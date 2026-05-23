terraform {
  required_version = "~> 1.10"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

#Change the project to your GCP project ID. You can find this in the GCP console.
provider "google" {
  # Configuration options
  project = "gcp-class-417400"
  region  = "us-central1"
}