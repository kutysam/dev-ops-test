data "google_kms_key_ring" "my_apps_keyring" {
  name     = "my-apps-keyring-devops-test-1"
  location = "us-central1"
}

data "google_kms_crypto_key" "my_apps_crypto_key" {
  name     = "my-apps-crypto-key-devops-test-1"
  key_ring = data.google_kms_key_ring.my_apps_keyring.id
}

data "google_kms_secret" "database_password" {
  crypto_key = data.google_kms_crypto_key.my_apps_crypto_key.id
  ciphertext = var.kms_encrypted_database_password
}

resource "google_secret_manager_secret" "admin-password" {
  provider  = google
  secret_id = "rubyapp-password"
  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
    }
  }
}

variable "kms_encrypted_database_password" {
  type        = string
  description = "Encrypted & base64 encoded db password"
}

# Add the secret data for local-admin-password secret
resource "google_secret_manager_secret_version" "admin-password" {
  secret      = google_secret_manager_secret.admin-password.id
  secret_data = data.google_kms_secret.database_password.plaintext
}
