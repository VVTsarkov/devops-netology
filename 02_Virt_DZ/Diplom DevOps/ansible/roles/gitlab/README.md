# Gitlab Install Role
## Что делает Role
1. Установка для `GitLab` зависимостей.
2. Настройка репозитория `GitLab`.
3. Установка `GitLab`.
4. Настройка для возможности мониторинга Prometheus и Node Exporter.
5. Добавляем `token` для `runner` и устанавливаем пароль для `root`.
6. Производим запуск конфигуратора `Gitlab`.

## Переменные

| Название переменной | Значение | Описание |
| :--- | :--- | :--- |
| `gitlab_domain` | `gitlab.you.domain` | Домен GitLab |
| `gitlab_external_url` | `https://{{ gitlab_domain }}/` | Внешний URL для Gitlab  |
| `gitlab_git_data_dir` | `/var/opt/gitlab/git-data` | Директория для данных Gitlab |
| `gitlab_edition` | `gitlab-ce` | Версия распространения Gitlab |
| `gitlab_version` |   | Версия Gitlab |
| `gitlab_backup_path` | `/var/opt/gitlab/backups` | Директория для Бэкапов |
| `gitlab_repository_installation_script_url` |  | Ссылка на установочный скрипт |
| `gitlab_pass` | `Passwordforgit!` | Пароль от root Gitlab |
| `reg_runner_token` | `fGAsDzsydzSmtxpsksHi` | Token для Runner |
|`gitlab_dependencies` | `curl`,`tzdata`,`perl`, `gnupg2` | Зависимости для Gitlab |