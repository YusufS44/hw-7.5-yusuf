resource "google_compute_instance_template" "appserver" {
  name         = "appserver-template"
  machine_type = "e2-medium"

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

   network_interface {
     access_config {
       network_tier = "PREMIUM"
     }
     network    = google_compute_network.sonny_vpc.id
     subnetwork = google_compute_subnetwork.monk_subnet.id
   }

  

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

metadata_startup_script = file("${path.module}/start.sh")

tags = ["web", "allow-health-check"]

}

resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/healthz"
    port         = "80"
  }
}

resource "google_compute_region_instance_group_manager" "appserver" {
  name = "appserver-igm"

  base_instance_name = "app"
  region             = var.region
  distribution_policy_zones = var.zones

  version {
    instance_template  = google_compute_instance_template.appserver.self_link
  }


  target_size  = 2

  named_port {
  name = "http"
  port = 80
}

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 300
  }
}

