#copied from Terraform registry (2nd example) https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "rules" {
  project     = var.project_id
  name        = "ten-firewall-rule"
  network     = google_compute_network.ten_network.name
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["80"]
  }

  target_tags = ["web"]

  source_ranges = ["0.0.0.0/0"]
}

#copied from Terraform registory (1st example) https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "default" {
  name    = "ten-allow-health-check"
  network = google_compute_network.ten_network.name
  direction = "INGRESS"
  priority = 1000
  source_ranges = ["35.191.0.0/16", "130.211.0.0/16"]
  target_tags = ["web"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }


}

# Target HTTP proxy — receives requests and hands them to the URL map
resource "google_compute_target_http_proxy" "lb_proxy" {
  name    = "sonny-http-proxy"
  url_map = google_compute_url_map.lb_url_map.id
}

# Global forwarding rule — binds the reserved IP to the proxy on :80
resource "google_compute_global_forwarding_rule" "lb_forwarding_rule" {
  name                  = "sonny-forwarding-rule"
  ip_protocol           = "TCP"
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target                = google_compute_target_http_proxy.lb_proxy.id
  ip_address            = google_compute_global_address.sonny_lb_ip.address
}