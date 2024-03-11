variable "vm_name" {
  type    = string
  default = "gcp-vm"
}

variable "vm_password" {
  type    = string
  default = "Google123#"
}

variable "region" {
  type    = string
  default = "us-west2"
}

variable "network_name" {
  type    = string
  default = "default"
}

variable "subnet_name" {
  type    = string
  default = "default"
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
}

variable "enable_public_ip" {
  type    = bool
  default = true
}

variable "network_tier" {
  description = "PREMIUM, FIXED_STANDARD or STANDARD"
  type        = string
  default     = "PREMIUM"
}