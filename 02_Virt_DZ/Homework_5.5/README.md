Царьков В.В.
Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"
Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.
Задача 1

Дайте письменые ответы на следующие вопросы:

    В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
```
	В режиме replicated приложение запускается в том количестве экземпляров, какое укажет пользователь. При этом на отдельной ноде может быть как несколько экземпляров приложения, так и не быть совсем.

	В режиме global приложение запускается обязательно на каждой ноде и в единственном экземпляре.
```
    Какой алгоритм выбора лидера используется в Docker Swarm кластере?
```	
	Raft.

    Протокол решает проблему согласованности: чтобы все manager ноды имели одинаковое представление о состоянии кластера
    Для отказоустойчивой работы должно быть не менее трёх manager нод.
    Количество нод обязательно должно быть нечётным, но лучше не более 7 (это рекомендация из документации Docker).
    Среди manager нод выбирается лидер, его задача гарантировать согласованность.
    Лидер отправляет keepalive пакеты с заданной периодичностью в пределах 150-300мс. Если пакеты не пришли, менеджеры начинают выборы нового лидера.
    Если кластер разбит, нечётное количество нод должно гарантировать, что кластер останется консистентным, т.к. факт изменения состояния считается совершенным, если его отразило большинство нод. Если разбить кластер пополам, нечётное число гарантирует что в какой-то части кластера будеть большинство нод.
```
    Что такое Overlay Network?
```
	Overlay Network — логическая или виртуальная сеть, созданная поверх другой сети. Узлы оверлейной сети могут быть связаны либо физическим соединением, либо логическим, для которого в основной сети существуют один или несколько соответствующих маршрутов из физических соединений. Таким образом клиенты разных сетей могут находится как-будто в одной сети.
```

Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:

docker node ls
```
[root@node01 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
sjq5x3dj5q377hg952m6222od *   node01.netology.yc   Ready     Active         Leader           20.10.13
g0dgvtmk6shw6ngxh88mhs0tp     node02.netology.yc   Ready     Active         Reachable        20.10.13
iqi62mgyuuntwyb7wf97zbt33     node03.netology.yc   Ready     Active         Reachable        20.10.13
o3doqn4b4psiyeptrp36zy3fp     node04.netology.yc   Ready     Active                          20.10.13
wasvn45p9ed39sbezghj9qj88     node05.netology.yc   Ready     Active                          20.10.13
y99g2ch25jixludv4xs006b2t     node06.netology.yc   Ready     Active                          20.10.13
[root@node01 ~]#
```

Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:

docker service ls
```
[root@node01 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
kl7davtae08t   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
q6qa1ihvlgf6   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
aeu7nlhp5dyz   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
qo67wgkcvnyc   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
y1p4qugmnlxf   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
m8vqa1kpo9nk   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
vxjjkwsi1ai8   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
f19cwn6oje1a   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
[root@node01 ~]#
```

Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:

# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
