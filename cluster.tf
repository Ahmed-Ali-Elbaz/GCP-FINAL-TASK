
resource "google_container_cluster" "private-cluster" {
  name               = "private-cluster"
  location           = "us-central1-a"
  remove_default_node_pool = true
  initial_node_count = 1
  network = google_compute_network.vpc_network.self_link
  subnetwork = google_compute_subnetwork.restricted-subnet.self_link

  

#  logging_service = "logging.gogleapis.com/kubernetes" # Collect logs from each node
#  monitoring_service = "monitoring.googleapis.com/kubernetes"

#  node_locations = [ "us-central1-b" ]


  addons_config {

    horizontal_pod_autoscaling {
      disabled = false
    }

  }

  release_channel {
      channel = "REGULAR"
  }


  ip_allocation_policy {
    cluster_secondary_range_name = "cluster-pods-range"
    services_secondary_range_name = "cluster-service-range"
  }  


  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = true # for bastion
    master_ipv4_cidr_block = "172.16.0.0/28"

  }

# to allow bastion access control plane
  master_authorized_networks_config {
    
    cidr_blocks {
      # ${google_compute_instance.my-instance.network_interface.0.netwrk_ip/32}
      cidr_block = "${google_compute_subnetwork.management-subnet.ip_cidr_range}"
      display_name = "bastion-cidr"
    }

  }

}




resource "google_service_account" "kubernetes" {
  project       = "wired-sol-367809"
  account_id    = "kubernetes"
  display_name  = "Kubernetes Service Account"

}

# resource "google_project_iam_binding" "container-admin2" {
#   project      = "wired-sol-367809"
#   role         = "roles/container.admin"

#   members = [

#     "serviceAccount:${google_service_account.service_account.email}",
#   ]
# }   

resource "google_project_iam_binding" "storage-admin2" {
  project      = "wired-sol-367809"
  role         = "roles/storage.admin"

  members = [

    "serviceAccount:${google_service_account.service_account.email}",
  ]
}  

resource "google_project_iam_binding" "container-admin2" {
  project      = "wired-sol-367809"
  role         = "roles/container.admin"

  members = [

    "serviceAccount:${google_service_account.service_account.email}",
  ]
} 


resource "google_container_node_pool" "nodepool" {
  name       = "my-node-pool"
# location   = "us-central1-a"
  cluster    = google_container_cluster.private-cluster.id
  node_count = 3
  max_pods_per_node = 30
  
  management {
    auto_repair = true
    auto_upgrade = true
  }

  node_config {

    preemptible = false
    machine_type = "e2-standard-2"

    labels = {
      role = "general"
    }
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.kubernetes.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}