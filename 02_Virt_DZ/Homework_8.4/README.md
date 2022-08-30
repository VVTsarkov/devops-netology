# Царьков В.В. 
# Домашнее задание к занятию "8.4 Работа с Roles"
Подготовка к выполнению

    (Необязательно) Познакомтесь с lighthouse
    Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
    Добавьте публичную часть своего ключа к своему профилю в github.

Основная часть

Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для clickhouse, vector и lighthouse и написать playbook для использования этих ролей. Ожидаемый результат: существуют три ваших репозитория: два с roles и один с playbook.

    Создать в старой версии playbook файл requirements.yml и заполнить его следующим содержимым:

    ---
      - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
        scm: git
        version: "1.11.0"
        name: clickhouse 

    При помощи ansible-galaxy скачать себе эту роль.
	```
	root@vagrant:/vagrant/8.3_Roles/old_playbook# ansible-galaxy install -r requirements.yml -p roles
Starting galaxy role install process
- extracting clickhouse to /vagrant/8.3_Roles/old_playbook/roles/clickhouse
- clickhouse (1.11.0) was installed successfully

	```
    Создать новый каталог с ролью при помощи ansible-galaxy role init vector-role.

    На основе tasks из старого playbook заполните новую role. Разнесите переменные между vars и default.

    Перенести нужные шаблоны конфигов в templates.

    Описать в README.md обе роли и их параметры.

    Повторите шаги 3-6 для lighthouse. Помните, что одна роль должна настраивать один продукт.

    Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию Добавьте roles в requirements.yml в playbook.

    Переработайте playbook на использование roles. Не забудьте про зависимости lighthouse и возможности совмещения roles с tasks.


1. Репозиторий с ролью от Clickhouse [Ссылка на репозиторий](https://github.com/VVTsarkov/devops-netology/tree/main/02_Virt_DZ/Homework_8.4/old_playbook/roles/clickhouse)
2. Репозиторий с ролью от Lighthouse [Ссылка на репозиторий](https://github.com/VVTsarkov/devops-netology/tree/main/02_Virt_DZ/Homework_8.4/old_playbook/roles/lighthouse-role)
3. Репозиторий с ролью от Vector [Ссылка на репозиторий](https://github.com/VVTsarkov/devops-netology/tree/main/02_Virt_DZ/Homework_8.4/old_playbook/roles/vector-role)

Playbook состоит из запуска только ролей.
Все переменные, которые можно изменить описаны непосредственно в ролях.
Скачивание ролей с помощью ansible-galaxy проходит успешно.
