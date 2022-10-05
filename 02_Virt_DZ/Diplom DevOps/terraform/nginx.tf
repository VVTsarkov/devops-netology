resource "yandex_compute_instance" "nginx" {
  name                      = "nginx"
  hostname                  = "nginx"
  zone                      = "ru-central1-a"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.image_id}"
      size        = "10"
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id      = "${yandex_vpc_subnet.subnet-1.id}"
    ip_address     = "${var.int_ip}"
    nat            = true
    nat_ip_address = "${var.ext_ip}"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}