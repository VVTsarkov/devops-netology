Царьков В.В.
Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"
Задача 1
Сценарий выполения задачи:

    создайте свой репозиторий на https://hub.docker.com;
    выберете любой образ, который содержит веб-сервер Nginx;
    создайте свой fork образа;
	реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
	<html>
	<head>
	Hey, Netology
	</head>
	<body>
	<h1>I’m DevOps Engineer!</h1>
	</body>
	</html>
```
```
	root@server1:~/DockerFile# docker pull ubuntu/nginx
	Using default tag: latest
	latest: Pulling from ubuntu/nginx
	d1d7abca142d: Pull complete
	d98a8e24b03f: Pull complete
	ca7d9f1e3ad9: Pull complete
	93363069cb6b: Pull complete
	Digest: sha256:570e77fffb564652c1b5b24d241666037da59334b25a6fc8a2fe12ba9487b47d
	Status: Downloaded newer image for ubuntu/nginx:latest
	docker.io/ubuntu/nginx:latest

	root@server1:~/DockerFile# docker build -t tsarkovvv/nginx:1.0 .
	Sending build context to Docker daemon  3.072kB
	Step 1/2 : FROM ubuntu/nginx:1.18-21.10_beta
	---> b7301f7f1bd2
	Step 2/2 : COPY index.html /usr/share/nginx/html/index.html
	---> bf156217fbc2
	Successfully built bf156217fbc2
	Successfully tagged tsarkovvv/nginx:1.0

	root@server1:~/DockerFile# docker run -d -p 80:80 tsarkovvv/nginx:1.0
	6a54e98936292f42d6dd430c77544d0a1261e8993b74773bf7674d5a1b2cbbaa

	root@server1:~/DockerFile# docker ps
	CONTAINER ID   IMAGE                          COMMAND                  CREATED             STATUS             PORTS                                   NAMES
	6a54e9893629   tsarkovvv/nginx:1.0            "/docker-entrypoint.…"   31 seconds ago      Up 29 seconds      0.0.0.0:80->80/tcp, :::80->80/tcp       vigorous_kapitsa
	4124cd24d4d5   ubuntu/nginx:1.18-21.10_beta   "/docker-entrypoint.…"   About an hour ago   Up About an hour   0.0.0.0:8080->80/tcp, :::8080->80/tcp   nginx-container
	
	root@6a54e9893629:/usr/share/nginx/html# cat index.html
	<html>
	<head>
	Hey, Netology
	</head>
	<body>
	<h1>I’m DevOps Engineer!</h1>
	</body>
	</html>

	root@server1:~/DockerFile# docker push tsarkovvv/nginx:1.0
	The push refers to repository [docker.io/tsarkovvv/nginx]
	9d2c95284864: Layer already exists
	421422e4142a: Layer already exists
	18180375b9be: Layer already exists
	cc5507213811: Layer already exists
	2d83b38bc099: Layer already exists
	1.0: digest: sha256:9e8e368c2f5f777c811afa5ff8aa4b6bf65a0ec277803c27603afbf788c6a81f size: 1362

```

Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

	https://hub.docker.com/repository/docker/tsarkovvv/nginx

Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

    Высоконагруженное монолитное java веб-приложение; - Целесообразно использовать виртуальные или физические машины
    Nodejs веб-приложение; Подойдет Docker. - Простота развертывания приложения, лёгковесность и масштабирование.
    Мобильное приложение c версиями для Android и iOS; - Возможно использовать как Docker  так и ВМ
    Шина данных на базе Apache Kafka; - Используем физические и виртуальные сервера
    Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana; - В случае высоконагруженных систем с большими объёмами и сроками хранения логов целесообразно использовать физические/виртуальные сервера,
    Мониторинг-стек на базе Prometheus и Grafana; - Docker - Масштабируемость, лёгкость и скорость развёртывания.
    MongoDB, как основное хранилище данных для java-приложения; - Физические или виртуальные сервера, ввиду сложности администрирования MongoDB внутри контейнера
    Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry. - Docker в данном случае не подойдет, т.к. при потере контейнера будет сложно восстановить частоизменяемые данные. Здесь больше подходят физические или виртуальные сервера.
	
Задача 3

    Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;
    Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;
    Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data;
    Добавьте еще один файл в папку /data на хостовой машине;
    Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.
```	
	root@server1:~/DZ_5.3# docker run -v /data:/data -dt --name centos centos
	51eedb747c99d85ec82ca4ee35e1cddf754ec023cdea80a7d0dfb4366d10dc6e
	root@server1:~/DZ_5.3# docker run -v /data:/data -dt --name debian debian
	85caa415970052d9bc50fb29378d5f58a7e61af0b23d1fede5252e9d924e3ea5
	
	root@server1:~/DZ_5.3# docker exec -it centos /bin/sh
	sh-4.4# echo 'It from centos'>/data/from-centos
	sh-4.4# exit
	exit
	
	root@server1:~/DZ_5.3# docker exec -it debian /bin/sh
	# cat /data/from-centos
	It from centos
	# exit

	root@server1:~/DZ_5.3# docker ps
	CONTAINER ID   IMAGE                          COMMAND                  CREATED          STATUS          PORTS                                   NAMES
	85caa4159700   debian                         "bash"                   2 minutes ago    Up 2 minutes                                            debian
	51eedb747c99   centos                         "/bin/bash"              4 minutes ago    Up 4 minutes                                            centos

	root@server1:~/DZ_5.3# echo 'from localhost'>/data/localhost
	root@server1:~/DZ_5.3# docker exec -it debian /bin/sh
	# ls -la /data
	total 16
	drwxr-xr-x 2 root root 4096 Feb 22 13:06 .
	drwxr-xr-x 1 root root 4096 Feb 22 13:02 ..
	-rw-r--r-- 1 root root   15 Feb 22 13:03 from-centos
	-rw-r--r-- 1 root root   15 Feb 22 13:06 localhost
```
Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

	https://hub.docker.com/repository/docker/tsarkovvv/ansible