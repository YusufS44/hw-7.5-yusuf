variable "project_id" {
  description = "The ID of the GCP project to use"
  type        = string
  default    = "gcp-class-417400"
}

variable "region" {
  description = "The region of the GCP project to use"
  type        = string
  default = "us-central1"
}

variable "zones" {
  description = "The zones of the GCP project to use"
  type        = list(string)
  default = ["us-central1-a", "us-central1-b", "us-central1-c", "us-central1-f"]
}