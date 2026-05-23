# copied from Terraform registry (1st example) https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat
resource "google_compute_address" "nat" {
    name         = "nat"
    region       = var.region
    address_type = "EXTERNAL"
    network_tier = "PREMIUM"
  }