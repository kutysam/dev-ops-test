resource "google_kms_key_ring" "my_apps_keyring" {
  project  = "rsathishx87"
  name     = "my-apps-keyring"
  location = "us-central1"
}

resource "google_kms_crypto_key" "my_apps_crypto_key" {
  name     = "my-apps-crypto-key"
  key_ring = google_kms_key_ring.my_apps_keyring.id
}
