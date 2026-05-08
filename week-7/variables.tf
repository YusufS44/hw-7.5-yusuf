variable "project_id" {
  default = "gcp-class-417400"
  type = string
  description = "The ID of the project where my resources are created."
}

variable "region" {
  default = "us-central1"
  type = string
  description = "The region where my resources are created."
}

variable "zone" {
  default = "us-central1-a"
  type = string
  description = "The zone where my resources are created."
}

variable "network_name" {
  default = "vpc-network-91"
  type = string
  description = "The name of the VPC network is vpc-network-91."
}

variable "favorite_food" {
  default = "my homemade chili"
  type = string
  description = "My favorite food is my homemade chili."
}