# Создаем файл inventory.yml для последующего запуска ansible
resource "local_file" "inventory" {
  content = <<-DOC
    ---
    Prephost:
      hosts:
        ${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}:
          ansible_ssh_common_args: "-o StrictHostKeyChecking=no"
        db01:
          ansible_ssh_common_args: "-o StrictHostKeyChecking=no -J ubuntu@${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"
        db02:
          ansible_ssh_common_args: "-o StrictHostKeyChecking=no -J ubuntu@${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"
        app:
          ansible_ssh_common_args: "-o StrictHostKeyChecking=no -J ubuntu@${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"
        gitlab:
          ansible_ssh_common_args: "-o StrictHostKeyChecking=no -J ubuntu@${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"
        monitoring:
          ansible_ssh_common_args: "-o StrictHostKeyChecking=no -J ubuntu@${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"
        runner:
          ansible_ssh_common_args: "-o StrictHostKeyChecking=no -J ubuntu@${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"
      vars:
        virtual_domain: ${var.domain}
        ip_nginx: ${yandex_compute_instance.nginx.network_interface.0.ip_address}
        ip_db01: ${yandex_compute_instance.db01.network_interface.0.ip_address}
        ip_db02: ${yandex_compute_instance.db02.network_interface.0.ip_address}
        ip_app: ${yandex_compute_instance.app.network_interface.0.ip_address}
        ip_gitlab: ${yandex_compute_instance.gitlab.network_interface.0.ip_address}
        ip_mon: ${yandex_compute_instance.monitoring.network_interface.0.ip_address}
        ip_runner: ${yandex_compute_instance.runner.network_interface.0.ip_address}
    nginx:
      hosts:
        ${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}:
          ansible_connection: ssh
          ansible_user: ubuntu
          ansible_ssh_common_args: "-o StrictHostKeyChecking=no"
          virtual_domain: ${var.domain}
    database:
      hosts:
        db01:
          ansible_connection: ssh
          ansible_user: ubuntu
          ansible_ssh_common_args: "-o StrictHostKeyChecking=no -J ubuntu@${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"
          mysql_replication_role: 'master'
          mysql_server_id: 1
        db02:
          ansible_connection: ssh
          ansible_user: ubuntu
          ansible_ssh_common_args: "-o StrictHostKeyChecking=no -J ubuntu@${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"
          mysql_replication_role: 'slave'
          mysql_server_id: 2
    wordpress:
      hosts:
        app:
          ansible_connection: ssh
          ansible_user: ubuntu
          ansible_ssh_common_args: "-o StrictHostKeyChecking=no -J ubuntu@${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"
          virtual_domain: ${var.domain}
    git:
      hosts:
        gitlab:
          ansible_connection: ssh
          ansible_user: ubuntu
          ansible_ssh_common_args: "-o StrictHostKeyChecking=no -J ubuntu@${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"
          virtual_domain: ${var.domain}
    mon:
      hosts:
        monitoring:
          ansible_connection: ssh
          ansible_user: ubuntu
          ansible_ssh_common_args: "-o StrictHostKeyChecking=no -J ubuntu@${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"
    gitrunner:
      hosts:
        runner:
          ansible_connection: ssh
          ansible_user: ubuntu
          ansible_ssh_common_args: "-o StrictHostKeyChecking=no -J ubuntu@${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"
    DOC
  filename = "./ansible/inventory/stage.yml"
  file_permission = "0644"

  depends_on = [yandex_compute_instance.nginx]
}