resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
  mtu                     = 1460
}

#============= Local File =============
resource "local_file" "favorite_food" {
  content  = var.favorite_food
  filename = "favorite_food.txt"
}

#============= Create Subnet =============
resource "google_compute_subnetwork" "subnet1" {
  name                    = "no-more-lizzo-love-subnet"
  ip_cidr_range           = "10.0.84.0/24"
  region                  = "us-central1"
  network                 = google_compute_network.vpc_network.id
  private_ip_google_access = true  
}

#============= Allow Internal Communication =============
resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.0.84.0/24"]
  
}

#============= Allow SSH from anywhere =============
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

#============= Router =============
resource "google_compute_router" "router" {
  name    = "vpc-router84"
  network = google_compute_network.vpc_network.name
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  name   = "vpc-nat84"
  router = google_compute_router.router.name
  region = var.region

  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}