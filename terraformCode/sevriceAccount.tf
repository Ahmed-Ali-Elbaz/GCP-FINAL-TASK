# VM Service Account
resource "google_service_account" "service_account" {
  project      = "wired-sol-367809"
  account_id   = "vm-service-account-id"
  display_name = "Service Account"

}


resource "google_project_iam_binding" "container-admin" {
  project      = "wired-sol-367809"
  role         = "roles/container.admin"

  members = [

    "serviceAccount:${google_service_account.service_account.email}",
  ]
}   

resource "google_project_iam_binding" "storage-admin1" {
  project      = "wired-sol-367809"
  role         = "roles/storage.admin"

  members = [

    "serviceAccount:${google_service_account.service_account.email}",
  ]
}  


# resource "google_project_iam_custom_role" "my-custom-role" {
#   project     = "wired-sol-367809"
#   role_id     = "myCustomRole"
#   title       = "My Custom Role"
#   description = "A description"
#   permissions = ["iam.roles.list", "iam.roles.create", "iam.roles.delete"]

# }