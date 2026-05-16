# required outputs from week 9 hw 
# copied the attributes from the "attributes-reference" sections of the registry docs:
# mig: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_group_manager#attributes-reference
# template: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template#attributes-reference
output "mig_self_link" {
  value = google_compute_region_instance_group_manager.appserver.self_link
}

output "mig_name" {
  value = google_compute_region_instance_group_manager.appserver.name
}

output "mig_instance_group" {
  value = google_compute_region_instance_group_manager.appserver.instance_group
}

output "mig_region" {
  value = google_compute_region_instance_group_manager.appserver.region
}

output "instance_template_self_link" {
  value = google_compute_instance_template.appserver.self_link
}

output "load_balancer_ip" {
  value       = google_compute_global_address.sonny_lb_ip.address
  description = "the ip address for the load balancer"
}

output "load_balancer_url" {
  value       = "http://${google_compute_global_address.sonny_lb_ip.address}"
  description = "the link to the load balancer"
}