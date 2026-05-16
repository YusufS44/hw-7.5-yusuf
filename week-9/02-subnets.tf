# copied from Terraform registry (1st  example) https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetworks
#changed from data to resource and set the cidr ranges and region to match the variables in the variables.tf file. Also added a second subnet for the private subnet.
resource "google_compute_subnetwork" "monk_subnet" { 
  name          = "sonny-subnet"
  ip_cidr_range = "10.84.0.0/16"
  network       = google_compute_network.sonny_vpc.id
  region = var.region
}   