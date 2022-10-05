# Царьков В.В. 
# Дипломное задание по курсу «DevOps-инженер»
##Дипломный практикум в YandexCloud
```
Цели:
    Зарегистрировать доменное имя (любое на ваш выбор в любой доменной зоне).
    Подготовить инфраструктуру с помощью Terraform на базе облачного провайдера YandexCloud.
    Настроить внешний Reverse Proxy на основе Nginx и LetsEncrypt.
    Настроить кластер MySQL.
    Установить WordPress.
    Развернуть Gitlab CE и Gitlab Runner.
    Настроить CI/CD для автоматического развёртывания приложения.
    Настроить мониторинг инфраструктуры с помощью стека: Prometheus, Alert Manager и Grafana.
```
#Этапы выполнения:

##1. Регистрация доменного имени

Подойдет любое доменное имя на ваш выбор в любой доменной зоне.
ПРИМЕЧАНИЕ: Далее в качестве примера используется домен you.domain замените его вашим доменом.
Рекомендуемые регистраторы:
• nic.ru
• reg.ru

Цель:
    Получить возможность выписывать TLS сертификаты для веб-сервера.

Ожидаемые результаты:
    У вас есть доступ к личному кабинету на сайте регистратора.
    Вы зарезистрировали домен и можете им управлять (редактировать dns записи в рамках этого домена).
- **Был зарегистрирован домен vvtsarkov.ru на RuCenter**
![img](picture/RuCenter.png)
[Проверка](https://www.nic.ru/whois/?ysclid=l8a98nod1579913379&searchWord=vvtsarkov.ru)

##2. Создание инфраструктуры

Для начала необходимо подготовить инфраструктуру в YC при помощи Terraform.

Конфигурация инфраструктуры находится в папке [terraform](terraform/).

Предварительная подготовка:
    Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
    Подготовьте backend для Terraform:

а. Рекомендуемый вариант: Terraform Cloud
б. Альтернативный вариант: S3 bucket в созданном YC аккаунте.

Был выбран вариант: `S3 bucket` в  YC аккаунте.
```
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = "AQAAAAAAtl88AATuwThx5JxpbkTaorwBYZxyaDc"
  cloud_id  = "b1g22ui73eo1b5lr8fs5"
  folder_id = "b1gbolqget39qpnc13fg"
  zone      = "ru-central1-a"
}

resource "yandex_iam_service_account" "sa" {
  name = "vvtsarkov"
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = "b1gbolqget39qpnc13fg"
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "test" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "vvtsarkov"
}
```
```
[root@localhost terraform]# terraform init

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Using previously-installed yandex-cloud/yandex v0.80.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
 Настройте workspaces
а. Рекомендуемый вариант: создайте два workspace: stage и prod. В случае выбора этого варианта все последующие шаги должны учитывать факт существования нескольких workspace.
б. Альтернативный вариант: используйте один workspace, назвав его stage. Пожалуйста, не используйте workspace, создаваемый Terraform-ом по-умолчанию (default).

Настроили `workspaces`, назвав его *stage*.\
```
[root@localhost terraform]# terraform workspace new stage
Created and switched to workspace "stage"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
[root@localhost terraform]# terraform workspace list
  default
* stage
```
![img](picture/3.png)

# Домен был делегирован под управление ns1.yandexcloud.net и ns2.yandexcloud.net.

    Создайте VPC с подсетями в разных зонах доступности.
    Убедитесь, что теперь вы можете выполнить команды terraform destroy и terraform apply без дополнительных ручных действий.
    В случае использования Terraform Cloud в качестве backend убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Цель:
    Повсеместно применять IaaC подход при организации (эксплуатации) инфраструктуры.
    Иметь возможность быстро создавать (а также удалять) виртуальные машины и сети. С целью экономии денег на вашем аккаунте в YandexCloud.

Ожидаемые результаты:
    Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
    Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.
```
yandex_vpc_network.tsar-diplom: Creating...
yandex_dns_zone.tsar-zone: Creating...
yandex_dns_zone.tsar-zone: Creation complete after 2s [id=dns72easb9tpt581guka]
yandex_vpc_network.tsar-diplom: Creation complete after 2s [id=enp57nglod86hbk6n98f]
yandex_vpc_route_table.nat-int: Creating...
yandex_vpc_route_table.nat-int: Creation complete after 1s [id=enp9obp0f4ucij9ej3p1]
yandex_vpc_subnet.subnet-2: Creating...
yandex_vpc_subnet.subnet-1: Creating...
yandex_vpc_subnet.subnet-2: Creation complete after 1s [id=e2lgue3k1v31c76vaq72]
yandex_compute_instance.db02: Creating...
yandex_vpc_subnet.subnet-1: Creation complete after 1s [id=e9b1061pi42og2frtbqb]
yandex_compute_instance.nginx: Creating...
yandex_compute_instance.app: Creating...
yandex_compute_instance.gitlab: Creating...
yandex_compute_instance.monitoring: Creating...
yandex_compute_instance.runner: Creating...
yandex_compute_instance.db01: Creating...
yandex_compute_instance.db02: Still creating... [10s elapsed]
yandex_compute_instance.app: Still creating... [10s elapsed]
yandex_compute_instance.gitlab: Still creating... [10s elapsed]
yandex_compute_instance.nginx: Still creating... [10s elapsed]
yandex_compute_instance.monitoring: Still creating... [10s elapsed]
yandex_compute_instance.runner: Still creating... [10s elapsed]
yandex_compute_instance.db01: Still creating... [10s elapsed]
yandex_compute_instance.db02: Still creating... [20s elapsed]
yandex_compute_instance.nginx: Still creating... [20s elapsed]
yandex_compute_instance.app: Still creating... [20s elapsed]
yandex_compute_instance.gitlab: Still creating... [20s elapsed]
yandex_compute_instance.monitoring: Still creating... [20s elapsed]
yandex_compute_instance.runner: Still creating... [20s elapsed]
yandex_compute_instance.db01: Still creating... [20s elapsed]
yandex_compute_instance.monitoring: Creation complete after 28s [id=fhmfkf7se7n7gmpa9qnq]
yandex_compute_instance.app: Creation complete after 29s [id=fhmvhcbgq3qjqnb31b50]
yandex_compute_instance.runner: Creation complete after 29s [id=fhm251vcdeo5g8khripd]
yandex_compute_instance.db02: Still creating... [30s elapsed]
yandex_compute_instance.db02: Creation complete after 30s [id=epdvlibkjprd5sks42gk]
yandex_compute_instance.gitlab: Still creating... [30s elapsed]
yandex_compute_instance.nginx: Still creating... [30s elapsed]
yandex_compute_instance.db01: Still creating... [30s elapsed]
yandex_compute_instance.gitlab: Creation complete after 34s [id=fhmn89dr8vr159m75spl]
yandex_compute_instance.db01: Creation complete after 35s [id=fhmjeg44kcq3boib8umk]
yandex_compute_instance.nginx: Still creating... [40s elapsed]
yandex_compute_instance.nginx: Creation complete after 50s [id=fhms79q3raqifcpuop6s]
yandex_dns_recordset.t6: Creating...
yandex_dns_recordset.t3: Creating...
yandex_dns_recordset.t1: Creating...
yandex_dns_recordset.t5: Creating...
yandex_dns_recordset.t2: Creating...
yandex_dns_recordset.t4: Creating...
local_file.inventory: Creating...
local_file.inventory: Creation complete after 0s [id=5e9ab21f4119e2747e4af600093cf3d5f38a6fd2]
yandex_dns_recordset.t4: Creation complete after 1s [id=dns72easb9tpt581guka/grafana/A]
yandex_dns_recordset.t2: Creation complete after 1s [id=dns72easb9tpt581guka/www/A]
yandex_dns_recordset.t6: Creation complete after 1s [id=dns72easb9tpt581guka/alertmanager/A]
yandex_dns_recordset.t1: Creation complete after 1s [id=dns72easb9tpt581guka/vvtsarkov.ru./A]
yandex_dns_recordset.t5: Creation complete after 2s [id=dns72easb9tpt581guka/prometheus/A]
yandex_dns_recordset.t3: Creation complete after 2s [id=dns72easb9tpt581guka/gitlab/A]

Apply complete! Resources: 19 added, 0 changed, 0 destroyed.
```
![img](picture/2.png)
![img](picture/5.png)
![img](picture/5.1.png)
![img](picture/6.png)
![img](picture/7.png)

##3. Установка Nginx и LetsEncrypt

Необходимо разработать Ansible роль для установки Nginx и LetsEncrypt.
Для получения LetsEncrypt сертификатов во время тестов своего кода пользуйтесь тестовыми сертификатами, так как количество запросов к боевым серверам LetsEncrypt лимитировано.

Все Ansible роли находятся в папке [ansible](ansible/).

Рекомендации:
• Имя сервера: you.domain
• Характеристики: 2vCPU, 2 RAM, External address (Public) и Internal address.

Цель:
    Создать reverse proxy с поддержкой TLS для обеспечения безопасного доступа к веб-сервисам по HTTPS.

Ожидаемые результаты:
    В вашей доменной зоне настроены все A-записи на внешний адрес этого сервера:

    https://www.you.domain (WordPress)
    https://gitlab.you.domain (Gitlab)
    https://grafana.you.domain (Grafana)
    https://prometheus.you.domain (Prometheus)
    https://alertmanager.you.domain (Alert Manager)

    Настроены все upstream для выше указанных URL, куда они сейчас ведут на этом шаге не важно, позже вы их отредактируете и укажите верные значения.
    В браузере можно открыть любой из этих URL и увидеть ответ сервера (502 Bad Gateway). На текущем этапе выполнение задания это нормально!
	
 ![img](picture/13.png)
 ![img](picture/10.png)
 ![img](picture/9.png)
 ![img](picture/8.png)
 ![img](picture/11.png)
 ![img](picture/12.png)
 
##4. Установка кластера MySQL

Необходимо разработать Ansible роль для установки кластера MySQL.

Все Ansible роли находятся в папке [ansible](ansible/).

Рекомендации:
• Имена серверов: db01.you.domain и db02.you.domain
• Характеристики: 4vCPU, 4 RAM, Internal address.

Цель:
    Получить отказоустойчивый кластер баз данных MySQL.

Ожидаемые результаты:
    MySQL работает в режиме репликации Master/Slave.
    В кластере автоматически создаётся база данных c именем wordpress.
    В кластере автоматически создаётся пользователь wordpress с полными правами на базу wordpress и паролем wordpress.

##5. Установка WordPress

Необходимо разработать Ansible роль для установки WordPress.

Все Ansible роли находятся в папке [ansible](ansible/).

Рекомендации:
• Имя сервера: app.you.domain
• Характеристики: 4vCPU, 4 RAM, Internal address.

Цель:
    Установить WordPress. Это система управления содержимым сайта (CMS) с открытым исходным кодом.
По данным W3techs, WordPress используют 64,7% всех веб-сайтов, которые сделаны на CMS. Это 41,1% всех существующих в мире сайтов. Эту платформу для своих блогов используют The New York Times и Forbes. Такую популярность WordPress получил за удобство интерфейса и большие возможности.

Ожидаемые результаты:
    Виртуальная машина на которой установлен WordPress и Nginx/Apache (на ваше усмотрение).
    В вашей доменной зоне настроена A-запись на внешний адрес reverse proxy:

    https://www.you.domain (WordPress)
![img](picture/16.png)

    На сервере you.domain отредактирован upstream для выше указанного URL и он смотрит на виртуальную машину на которой установлен WordPress.
    В браузере можно открыть URL https://www.you.domain и увидеть главную страницу WordPress.

##6. Установка Gitlab CE и Gitlab Runner
![img](picture/22.png)
![img](picture/23.png)

Необходимо настроить CI/CD систему для автоматического развертывания приложения при изменении кода.

Реализацию CI/CD находится [тут](gitlab-ci-cd/).

Рекомендации:
• Имена серверов: gitlab.you.domain и runner.you.domain
• Характеристики: 4vCPU, 4 RAM, Internal address.

Цель:
    Построить pipeline доставки кода в среду эксплуатации, то есть настроить автоматический деплой на сервер app.you.domain при коммите в репозиторий с WordPress.
    Подробнее о Gitlab CI

Ожидаемый результат:
    Интерфейс Gitlab доступен по https.
    В вашей доменной зоне настроена A-запись на внешний адрес reverse proxy:

    https://gitlab.you.domain (Gitlab)
![img](picture/28.png)
```
CI/CD для деплоя темы в WordPress
	Создадим на целевом сервере ssh ключи для пользователя `ubuntu`.
	Открытый ключ перенаправим в `~/.ssh/authorized_keys` для дальнейшего подключения.
	Закрытый ключ нам понадобится для добавления в `Gitlab`.
Настройка переменных GitLab CI/CD
	В разделе `GitLab Project > Settings > CI/CD > Variables` создаем следующие переменные:
	- **`STAGE_SERVER_IP`** – содержит IP-адрес целевого сервера. Этот IP-адрес используется GitLab Runner для установления SSH-подключения к целевому серверу.
	- **`STAGE_SERVER_USER`** — содержит пользователя, используемого при открытии сеанса SSH.
	- **`STAGE_ID_RSA`** – содержит закрытый ключ SSH, используемый во время сеанса SSH.\
```
![img](picture/24.png)
```
Подготовка GitLab к автоматическому развертыванию
	Создаем новый публичный репозиторий для нашего проекта.
	Загружаем в него наш файл `.gitlab-ci.yml` и папку с темой `wp-content`.\
	Подготавливаем `Runner` для работы с нашем проектом.
```
После завершения настройки, GitLab CI/CD автоматически развернет новую тему для WordPress.
 - **Успешно выполненный `pipeline`**
![img](picture/27.png)

 - **Измененная тема на нашем сайте Wordpress**
![img](picture/26.png)

##7. Установка Prometheus, Alert Manager, Node Exporter и Grafana

Необходимо разработать Ansible роль для установки Prometheus, Alert Manager и Grafana.
Рекомендации:
• Имя сервера: monitoring.you.domain
• Характеристики: 4vCPU, 4 RAM, Internal address.

Цель:
    Получение метрик со всей инфраструктуры.

Ожидаемые результаты:
    Интерфейсы Prometheus, Alert Manager и Grafana доступены по https.
    В вашей доменной зоне настроены A-записи на внешний адрес reverse proxy:
    • https://grafana.you.domain (Grafana)
    • https://prometheus.you.domain (Prometheus)
    • https://alertmanager.you.domain (Alert Manager)
    На сервере you.domain отредактированы upstreams для выше указанных URL и они смотрят на виртуальную машину на которой установлены Prometheus, Alert Manager и Grafana.
    На всех серверах установлен Node Exporter и его метрики доступны Prometheus.
    У Alert Manager есть необходимый набор правил для создания алертов.
    В Grafana есть дашборд отображающий метрики из Node Exporter по всем серверам.
    В Grafana есть дашборд отображающий метрики из MySQL (*).
    В Grafana есть дашборд отображающий метрики из WordPress (*).

![img](picture/20.png)
![img](picture/21.png)
![img](picture/17.png)
![img](picture/18.png)
![img](picture/19.png)
