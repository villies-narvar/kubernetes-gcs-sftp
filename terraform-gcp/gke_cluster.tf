resource "google_container_cluster" "villies-test-sftp" {
  name = "villies-test-sftp"
  region = "${var.gcp_region}"

  lifecycle {
    ignore_changes = ["node_pool"]
  }

  node_pool {
    name = "default-pool"
  }

  addons_config {
    kubernetes_dashboard {
      disabled = true
    }
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "villies-test-sftp" {
  name = "villies-test-sftp"
  region = "${var.gcp_region}"
  cluster = "${google_container_cluster.villies-test-sftp.name}"
  node_count = 1

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
