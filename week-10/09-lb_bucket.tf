# copied from the Terraform registry (1st example) https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "static-site" {
  name          = "sonny-images"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  cors {
    origin          = ["http://sonny-images.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
  cors {
    origin            = ["http://image-store.com"]
    method            = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header   = ["*"]
    max_age_seconds   = 0
  }
}