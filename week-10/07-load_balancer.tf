#LB-Frontend-external-ip-address
#copied from Terraform registry (1st example) # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address
resource "google_compute_global_address" "sonny_lb_ip" {
  name          = "sonny-lb-ip"

}

#LB-URL-MAP
#copied from Terraform registry (1st example) https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map
resource "google_compute_url_map" "lb_url_map" {
  name            = "lb-url-map"
  default_service = google_compute_backend_service.default.id
}

#Backendservice
#copied from Terraform registry (1st example)
resource "google_compute_backend_service" "http" {
  name          = "http-backend-service"
  protocol      = "HTTP"
  health_checks = [google_compute_health_check.http_basic_check.id]

  # backend blocks go here (e.g., instance groups)
}


#LB-Backend-health-check
#copied from Terraform registry () https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check
resource "google_compute_health_check" "http_basic_check" {
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

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service
resource "google_compute_backend_service" "default" {
  name                            = "sonny-backend-service"
  protocol                        = "HTTP"
  connection_draining_timeout_sec = 0
  load_balancing_scheme           = "EXTERNAL_MANAGED"
  port_name                       = "http"
  session_affinity                = "NONE"
  timeout_sec                     = 30
  health_checks                   = [google_compute_health_check.http_basic_check.id]

  backend {
    group           = google_compute_instance_group_manager.app_ten.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}
