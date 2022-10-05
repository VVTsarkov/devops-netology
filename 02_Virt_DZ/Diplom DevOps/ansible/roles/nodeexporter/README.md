# Node Exporter Install Role
## Что делает Role
1. Проверяет наличие на хосте `node exporter`.
2. Создает группу и пользователя для `node exporter`.
3. Создание папки для конфигурационных файлов `node exporter`.
4. Проверка версии `node exporter`, если он установлен на хост.
5. Загрузка и распаковка `node exporter`.
6. Перемещение бинарного файла `node exporter`.
7. Установка/Создание сервиса `node exporter`.

## Переменные

| Название переменной | Значение | Описание |
| :--- | :--- | :--- |
| `node_exporter_version` | `1.4.0` | Версия Node Exporter |
| `node_exporter_bin` | `/usr/local/bin/node_exporter` | Директория Node Exporter  |
| `node_exporter_user` | `node-exporter` | Пользователь для Node Exporter |
| `node_exporter_group` | `node-exporter` | Группа для Node Exporter |
| `node_exporter_dir_conf` | `/etc/node_exporter` | Директория конфигурационных файлов  |
| `node_exporter_link_download` | `https://github.com/prometheus/node_exporter/releases/download/` | Ссылка для загрузки  |
