resource "google_compute_subnetwork" "private" {
  name                     = "private-subnet"
  ip_cidr_range            = "10.81.0.0/18"
  region                   = "us-central1"
  network                  = google_compute_network.compute_network91.id
  private_ip_google_access = true

  # IMPORTANT:
  # These CIDR ranges MUST NOT overlap
  # Do not modify unless you understand subnetting

  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.24.0.0/14"
  }

  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.44.0.0/20"
  }

  depends_on = [
    google_compute_network.compute_network91
  ]
}