provider "google" {
    project = var.project
    region  = var.region
    zone    = var.zone
}

# VPC
resource "google_compute_network" "vpc" {
    name                    = "simple-vpc"
    auto_create_subnetworks = true
}
# FIREWALL
resource "google_compute_firewall" "allow_http" {
    name    = "allow-http"
    network = google_compute_network.vpc.name

    allow {
        protocol = "tcp"
        ports    = ["80", "8080"]
    }
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["http-server"]
}

# FRONTEND (e2-micro)
resource "google_compute_instance" "frontend" {
    name         = "frontend-vm"
    machine_type = "e2-micro"
    zone         = var.zone

    boot_disk {
        initialize_params {
        image = "debian-cloud/debian-11"
        size  = 10
        }
    }

    network_interface {
        network       = google_compute_network.vpc.name
        access_config {}
    }

    tags = ["http-server"]
}

# BACKEND (e2-small)
resource "google_compute_instance" "backend" {
    name         = "backend-vm"
    machine_type = "e2-small"
    zone         = var.zone

    boot_disk {
        initialize_params {
        image = "debian-cloud/debian-11"
        size  = 15
        }
    }

    network_interface {
        network       = google_compute_network.vpc.name
        access_config {}
    }

    tags = ["http-server"]
}

# POSTGRES (e2-small)
resource "google_compute_instance" "postgres" {
    name         = "postgres-vm"
    machine_type = "e2-small"
    zone         = var.zone

    boot_disk {
        initialize_params {
        image = "debian-cloud/debian-11"
        size  = 15
        }
    }

    network_interface {
        network       = google_compute_network.vpc.namep 
    }
}

# REDIS + MONGO (e2-small)
resource "google_compute_instance" "redis_mongo" {
    name         = "redis-mongo-vm"
    machine_type = "e2-small"
    zone         = var.zone

    boot_disk {
        initialize_params {
        image = "debian-cloud/debian-11"
        size  = 15
        }
    }

    network_interface {
        network       = google_compute_network.vpc.name
        access_config {}
    }
}