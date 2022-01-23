# Entire thing takes about 10 minutes!

resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_container_cluster" "primary" {
  name               = "sathish-cluster"
  location           = "us-central1-a"
  initial_node_count = 2
  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum       = 1
      maximum       = 16
    }
    resource_limits {
      resource_type = "memory"
      minimum       = 4
      maximum       = 16
    }
  }
  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
