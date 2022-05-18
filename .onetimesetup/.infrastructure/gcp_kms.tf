resource "google_kms_key_ring" "my_apps_keyring" {
  project  = "rsathishx87"
  name     = "devops-test"
  location = "us-central1"
}

resource "google_kms_crypto_key" "my_apps_crypto_key" {
  name     = "devops-test"
  key_ring = google_kms_key_ring.my_apps_keyring.id
}
