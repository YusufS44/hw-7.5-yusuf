# copied from Teraform registry (1st example) https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "allow_web_traffic_port_80" {
  name    = "allow-web-traffic-port-80"
  network = google_compute_network.sonny_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["web"]

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "default" {
  name          = "fw-allow-health-check"
  direction     = "INGRESS"
  network       = google_compute_network.sonny_vpc.id
  priority      = 1000
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["allow-health-check"]
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
}