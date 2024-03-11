output "google_compute_firewall" {
  description = "The created GCP Firewall google_compute_firewall as an object with all of it's attributes"
  value       = google_compute_firewall.this
}

output "google_compute_address" {
  description = "The created GCP Public IP google_compute_address as an object with all of it's attributes"
  value       = try(google_compute_address.this[0], null)
}

output "google_compute_instance" {
  description = "The created GCP VM instance google_compute_instance as an object with all of it's attributes"
  value       = google_compute_instance.this
  sensitive   = true
}

output "my_public_ip" {
  description = "My public IP"
  value       = local.my_public_ip
  sensitive   = false
}  