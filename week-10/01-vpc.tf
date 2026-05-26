#copied from Terraform registry (2nd example) https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "ten_network" {
  name                    = "ten-network"
  auto_create_subnetworks = true
  mtu                     = 1460
}