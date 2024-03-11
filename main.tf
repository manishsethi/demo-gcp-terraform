
provider "google" {
  project = "training-ac"
  region  = "us-west2"
}

# Retrieve my public IP address
data "http" "my_public_ip" {
  url = "http://ipv4.icanhazip.com"
}

data "template_file" "this" {
  template = file("${path.module}/bootstrap.sh")
  vars = {
    name     = var.vm_name
    password = var.vm_password
  }
}

resource "google_compute_firewall" "this" {
  name    = "${var.vm_name}-firewall"
  network = var.network_name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = [80, 443, 22]
  }

  source_ranges = local.ingress_cidrs
}

resource "google_compute_firewall" "iap" {
  name    = "${var.vm_name}-iap"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = [22]
  }

  source_ranges = local.iap_range
}


resource "google_compute_address" "this" {
  count = var.enable_public_ip ? 1 : 0

  name         = "${var.vm_name}-external"
  address_type = "EXTERNAL"
  region       = var.region
}

resource "google_compute_instance" "this" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
    }
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name

    dynamic "access_config" {
      for_each = var.enable_public_ip == true ? [1] : [0]

      content {
        nat_ip       = var.enable_public_ip ? google_compute_address.this[0].address : null
        network_tier = var.network_tier
      }
    } 
  }

  metadata = {
        startup-script = file("./bootstrap.sh")
  }
}

locals {
  rfc1918       = ["0.0.0.0/0"]
  my_public_ip  = "${chomp(data.http.my_public_ip.response_body)}/32"
  iap_range     = ["35.235.240.0/20"]
  ingress_cidrs = concat(local.rfc1918, [local.my_public_ip])
}