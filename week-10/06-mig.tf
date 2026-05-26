#copied from Terraform registry (1st example) https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_group_manager
resource "google_compute_instance_template" "instance_template" {
  name_prefix  = "instance-template-"
  machine_type = "e2-medium"
  region       = var.region

  // boot disk
  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot        = true
  }

  // networking
  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }
    network = google_compute_network.ten_network.id
    subnetwork = google_compute_subnetwork.network-with-private-secondary-ip-ranges.id
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

metadata_startup_script = file("./start.sh")

tags = ["web", "allow-health-check"]
}

resource "google_compute_instance_group_manager" "app_ten" {
  name               = "appserver-ten"
  base_instance_name = "app-ten"
  zone               = var.zones[0] 
  target_size        = 4

  version {
    instance_template  = google_compute_instance_template.instance_template.self_link
  }

  all_instances_config {
    metadata = {
      metadata_key = "metadata_value"
    }
    labels = {
      label_key = "label_value"
    }
  }

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.http_basic_check.id
    initial_delay_sec = 300
  }
}

resource "google_compute_autoscaler" "appserver_ten" {
  name    = "appserver-ten"
  zone    = var.zones[0]
  target  = google_compute_instance_group_manager.app_ten.id

  autoscaling_policy {
    max_replicas    = 10
    min_replicas    = 4
    cpu_utilization {
      target = 0.6
    }
  }
}