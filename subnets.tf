# Create Management Subnet
resource "google_compute_subnetwork" "management-subnet" {
  name          = "management-subnet"
  ip_cidr_range = "10.4.0.0/18"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
  private_ip_google_access  = true
  
}


# Create Restricted Subnet
resource "google_compute_subnetwork" "restricted-subnet" {
  name          = "restricted-subnet"
  ip_cidr_range = "10.3.0.0/18" 
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
  private_ip_google_access  = true

  secondary_ip_range {

    range_name = "cluster-pods-range"
    ip_cidr_range = "10.48.0.0/14"   # Kubernetes pods

  }
  
  secondary_ip_range {

    range_name = "cluster-service-range"
    ip_cidr_range = "10.52.0.0/20"   # Kubernetes services

  }



  
}
