resource "google_compute_router" "router" {
  name    = "router"
  region  = "us-central1"
  network = google_compute_network.compute_network91.id

  depends_on = [
    google_compute_network.compute_network91
  ]
}