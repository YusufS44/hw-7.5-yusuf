#Copied from Terraform registry (1st example) https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.66.0.0/16"
  network       = google_compute_network.ten_network.id
  region = var.region
}
