#copied from Terraform registry (2nd example) https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "sonny_vpc" {
  name = "sonny-vpc"
  auto_create_subnetworks = false #setting this to false to avoid auto-created subnets and allow custom subnets that are listed in the 02-subnets.tf file.
  mtu = 1460
}