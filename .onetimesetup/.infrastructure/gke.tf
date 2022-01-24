# Entire thing takes about 10 minutes!

resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_container_cluster" "primary" {
  name     = "sathish-cluster-1"
  location = "us-central1-a"
  node_pool {
    name               = "default-pool"
    initial_node_count = 1
    node_config {
      preemptible  = true
      machine_type = "e2-medium"
      # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
      service_account = google_service_account.default.email
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
    }
    autoscaling {
      max_node_count = 5
      min_node_count = 1
    }
  }
}
