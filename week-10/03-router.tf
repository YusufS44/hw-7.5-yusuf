#copied from Terraform registry (1st example) https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_routerhttps://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
resource "google_compute_router" "router_alpha" {
  name    = "router-alpha"
  network = google_compute_network.ten_network.name
  bgp {
    asn               = 64514
}
}