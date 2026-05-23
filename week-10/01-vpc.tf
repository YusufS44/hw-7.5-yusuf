#copied from Terraform registry (2nd example) https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks = true
  mtu                     = 1460
}