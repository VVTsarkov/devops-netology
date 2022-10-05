# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

    backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "vvtsarkov"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = "YCAJEcLgS-EMbwFQHN1DM9hY-"
    secret_key = "YCPLOAna7cXhBpvP4XT1HDmP4AZVoszSFjMMwkFi"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token = "${var.token}"
  cloud_id  = "${var.cloud_id}"
  folder_id = "${var.folder_id}"
}
