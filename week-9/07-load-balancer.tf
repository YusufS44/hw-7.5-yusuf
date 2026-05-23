# Global external IP address for the load balancer frontend
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address
resource "google_compute_global_address" "sonny_lb_ip" {
  name = "sonny-lb-ip"
}

# HTTP health check used by the backend service to determine instance health
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check
resource "google_compute_health_check" "http" {
  name                = "http-basic-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    port         = 80
    request_path = "/"
    proxy_header = "NONE"
  }
}

# Backend service points the LB at the regional MIG and references the health check
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service
resource "google_compute_backend_service" "default" {
  name                            = "sonny-backend-service"
  protocol                        = "HTTP"
  connection_draining_timeout_sec = 0
  load_balancing_scheme           = "EXTERNAL_MANAGED"
  port_name                       = "http"
  session_affinity                = "NONE"
  timeout_sec                     = 30
  health_checks                   = [google_compute_health_check.http.id]

  backend {
    group           = google_compute_region_instance_group_manager.appserver.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

# the url map routes all requests to the default backend service
resource "google_compute_url_map" "default" {
  name            = "web-map-http"
  default_service = google_compute_backend_service.default.id
}

# the http target proxy terminates client connections and hands off to the url map
resource "google_compute_target_http_proxy" "default" {
  name    = "http-lb-proxy"
  url_map = google_compute_url_map.default.id
}

# the forwarding rule exposes the LB on port 80 at the reserved global ip address
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "http-content-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.sonny_lb_ip.id
}
