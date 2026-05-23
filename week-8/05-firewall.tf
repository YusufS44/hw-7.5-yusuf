resource "google_compute_firewall" "allow_web_traffic_port_80" {
  name    = "allow-web-traffic-port-80"
  network = google_compute_network.compute_network91.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}