output "vpc_name" {
    description = "The name of the VPC network"
    value = google_compute_network.vpc_network.name
}

output "vpc_id" {
    description = "The ID of the VPC network"
    value = google_compute_network.vpc_network.id
}

output "my_favorite_food" {
    description = "My favorite food is my homemade chili."
    value = var.favorite_food
}