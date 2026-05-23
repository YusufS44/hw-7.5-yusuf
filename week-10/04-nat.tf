#copied from Terraform registry (1st example) https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat
resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.router_alpha.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}