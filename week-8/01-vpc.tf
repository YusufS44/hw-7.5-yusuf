resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
  disable_on_destroy = false
}


resource "google_compute_network" "compute_network91" {
  name                    = "compute-network91"
  auto_create_subnetworks = false # Set to true by deafult, we want to create our own subnets, so set to false.
  mtu                     = 1460
}

# Subnet Config
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork

resource "google_compute_subnetwork" "compute_subnet91" {
  name          = "compute-subnetwork91"
  ip_cidr_range = "10.28.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.compute_network91.id
}