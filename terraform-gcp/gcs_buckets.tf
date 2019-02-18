resource "google_storage_bucket" "sftp-villies-test-inbound" {
  name     = "sftp-villies-test-inbound"
  location = "${var.gcp_region}"
  storage_class = "REGIONAL"
}

resource "google_storage_bucket" "sftp-villies-test-outbound" {
  name     = "sftp-villies-test-outbound"
  location = "${var.gcp_region}"
  storage_class = "REGIONAL"
}
