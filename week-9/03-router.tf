# copied from terraform registry (3rd example) https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
# used the argument reference to verify that only required arguments are included
resource "google_compute_router" "router" {
  name    = "router"
  network = google_compute_network.sonny_vpc.id
  bgp {
    asn = 64514
  }
}

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}