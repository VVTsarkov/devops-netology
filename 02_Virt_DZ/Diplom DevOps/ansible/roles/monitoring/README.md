# Monitoring Install Role
## Что делает Role
1. Установка и конфигурация `Prometheus`:\
  1.1 Создание группы и пользователя.\
  1.2 Создание директории для данных и конфигурационных файлов.\
  1.3 Загрузка и установка `Prometheus`.\
  1.4 Перемещение ранее загруженных файлов.\
  1.5 Создание сервиса `Prometheus` на хосте.\
  1.6 Добавление файла `alert.rules` из шаблона.\
  1.7 Конфигурация `Prometheus`.
2. Установка и конфигурация `Grafana`:\
  2.1 Установка `gpg`.\
  2.2 Загрузка GPG-ключа и добавление его в список надежных.\
  2.3 Добавляем в систему репозиторий `Grafana`.\
  2.4 Установка `Grafana`.\
  2.5 Запуск сервиса `Grafana`.\
  2.6 Смена пароля пользователя `admin` на заранее подготовленный нами.\
  2.7 Установка dashboards в `Grafana`.
3. Установка и конфигурация `Alertmanager`:\
  3.1 Создание группы и пользователя.\
  3.2 Загрузка `Alertmanager`.\
  3.3 Создание символической ссылки.\
  3.4 Создание директории для данных, конфигурационных файлов и шаблонов.\
  3.5 Добавление конфигурационного файла из шаблона.\
  3.6 Создание сервиса `Alertmanager` на хосте.\

## Переменные

| Название переменной | Значение | Описание |
| :--- | :--- | :--- |
| `grafana_admin_password` | `PassForMon!` | Пароль пользователя admin от Web-интерфейса Grafana |
| `grafana_datasources` | `[]` | Список источников данных, которые необходимо настроить |
| `grafana_dashboards` | `[]` | Список dashboards для импортирования |
| `grafana_data_dir` | `/var/lib/grafana` | Путь к директории базы данных |
| `grafana_dashboards_dir` | `dashboards` | Путь к директории, содержащему файлы dashboards в json формате |
| `grafana_provisioning_synced` | `false` | Проверка, что ранее подготовленные dashboards не сохраняются, если на них больше нет ссылок|
| `alertmanager_release_url` | `""` | Ссылка для загрузки alertmanager |
| `alertmanager_user` | `{{ prometheus_user }}` | Пользователь alertmanager |
| `alertmanager_group` | `{{ prometheus_group }}` | Группа alertmanager |
| `alertmanager_install_path` | `/opt` | Директория для загрузки alertmanager |
| `alertmanager_bin_path` | `/usr/local/bin` | Директория для бинарных файлов alertmanager |
| `alertmanager_config_path` | `/etc/alertmanager` | Путь к директории с конфигурацией alertmanager |
| `alertmanager_config_file` | `alertmanager.yml` | Переменная, для предоставления пользовательского файла конфигурации alertmanager |
| `alertmanager_config` | `{}` | Дополнительные флаги конфигурации |
| `alertmanager_templates_path` | `{{ alertmanager_config_path }}/templates` | Директория шаблонов alertmanager |
| `alertmanager_listen_address` | `0.0.0.0:9093` | Адрес, который alertmanager будет прослушивать |
| `alertmanager_storage_path` | `/var/lib/alertmanager` | Директория для хранения данных |
| `alertmanager_storage_retention` | `120h` | Срок хранения данных |
| `alertmanager_log_level` | `info` | Уровень детализации журнала alertmanager |
| `alertmanager_additional_cli_args` | `""` | Дополнительные аргументы командной строки |
| `prometheus_user` | `prometheus` | Пользователь для Prometheus |
| `prometheus_group` | `prometheus` | Группа для Prometheus |
| `prometheus_version` | `2.36.2` | Версия пакета Prometheus |
| `prometheus_binary_local_dir` | `""` | Использовать локальные пакеты, вместо распространяемых на github. В качестве параметра указывается директория|
| `prometheus_skip_install` | `false` | Задачи по установки Prometheus пропускаются, если установлено значение `true` |
| `prometheus_binary_install_dir` | `/usr/local/bin` | Путь к директории установки Prometheus |
| `prometheus_config_dir` | `/etc/prometheus` | Путь к директории с конфигурацией Prometheus |
| `prometheus_db_dir` | `/var/lib/prometheus` | Путь к директории с базой данных Prometheus |
| `prometheus_read_only_dirs` | `[]` | Дополнительные пути, которые Prometheus может читать |
| `prometheus_web_listen_address` | `0.0.0.0:9090` | Адрес, который Prometheus будет слушать |
| `prometheus_web_external_url` | `""` | Внешний адрес, по которому доступен Prometheus. |
| `prometheus_storage_retention` | `30d` | Срок хранения данных |
| `prometheus_storage_retention_size` | `0` | Срок хранения данных по размеру |
| `prometheus_config_flags_extra` | `{}` | Дополнительные флаги конфигурации |
| `prometheus_config_file` | `prometheus.yml.j2` | Переменная для предоставления пользовательского файла конфигурации Prometheus |
