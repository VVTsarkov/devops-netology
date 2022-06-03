Царьков В.В.
Домашнее задание к занятию "6.5. Elasticsearch"
Задача 1

В этом задании вы потренируетесь в:

    установке elasticsearch
    первоначальном конфигурировании elastcisearch
    запуске elasticsearch в docker

Используя докер образ centos:7 как базовый и документацию по установке и запуску Elastcisearch:

    составьте Dockerfile-манифест для elasticsearch
    соберите docker-образ и сделайте push в ваш docker.io репозиторий
    запустите контейнер из получившегося образа и выполните запрос пути / c хост-машины
```
root@vagrant:/vagrant/elasticsearch# cat Dockerfile
FROM centos:7
RUN cd /opt &&\
    groupadd elasticsearch && \
    useradd -c "elasticsearch" -g elasticsearch elasticsearch &&\
    mkdir /var/lib/data && chmod -R 777 /var/lib/data &&\
    yum -y install wget perl-Digest-SHA && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.2.2-linux-x86_64.tar.gz && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.2.2-linux-x86_64.tar.gz.sha512 && \
    shasum -a 512 -c elasticsearch-8.2.2-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-8.2.2-linux-x86_64.tar.gz && \
    rm elasticsearch-8.2.2-linux-x86_64.tar.gz elasticsearch-8.2.2-linux-x86_64.tar.gz.sha512 && \
    chown -R elasticsearch:elasticsearch /opt/elasticsearch-8.2.2

USER elasticsearch
WORKDIR /opt/elasticsearch-8.2.2
ENV PATH=$PATH:/opt/elasticsearch-8.2.2/bin
COPY elasticsearch.yml config/
EXPOSE 9200
EXPOSE 9300
ENTRYPOINT ["elasticsearch"]
```
```
https://hub.docker.com/repository/docker/tsarkovvv/elasticsearch
```
```
root@vagrant:/vagrant/elasticsearch# docker ps -a
CONTAINER ID   IMAGE                         COMMAND           CREATED             STATUS         PORTS                                                                                  NAMES
2e6baa9aec73   tsarkovvv/elasticsearch:1.2   "elasticsearch"   About an hour ago   Up 2 minutes   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 0.0.0.0:9300->9300/tcp, :::9300->9300/tcp   elastic
```
```
root@vagrant:/vagrant/elasticsearch# curl -X GET "localhost:9200"
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "FB1kzNP8T9SMFcMT8UhZ6A",
  "version" : {
    "number" : "8.2.2",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "9876968ef3c745186b94fdabd4483e01499224ef",
    "build_date" : "2022-05-25T15:47:06.259735307Z",
    "build_snapshot" : false,
    "lucene_version" : "9.1.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```
Задача 2

В этом задании вы научитесь:

    создавать и удалять индексы
    изучать состояние кластера
    обосновывать причину деградации доступности данных

Ознакомтесь с документацией и добавьте в elasticsearch 3 индекса, в соответствии со таблицей:
Имя 	Количество реплик 	Количество шард
ind-1 	0 	1
ind-2 	1 	2
ind-3 	2 	4

Получите список индексов и их статусов, используя API и приведите в ответе на задание.

Получите состояние кластера elasticsearch, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

Важно

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард, иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.
```
curl -X PUT "localhost:9200/ind-1" -H 'Content-Type: application/json' -d'{"settings": {"index": {"number_of_shards": 1,"number_of_replicas": 0}}}'
curl -X PUT "localhost:9200/ind-2" -H 'Content-Type: application/json' -d'{"settings": {"index": {"number_of_shards": 2,"number_of_replicas": 1}}}'
curl -X PUT "localhost:9200/ind-3" -H 'Content-Type: application/json' -d'{"settings": {"index": {"number_of_shards": 4,"number_of_replicas": 2}}}'
```
```
root@vagrant:/vagrant/elasticsearch# curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 47wzVS-vTiuhtbX1DVWp0w   1   0          0            0       225b           225b
yellow open   ind-3 65Hs3Ze8TlC-u2iH41skFA   4   2          0            0       900b           900b
yellow open   ind-2 Ixln-iqETImMLx2UH0NYow   2   1          0            0       450b           450b
```
```
root@vagrant:/vagrant/elasticsearch# curl -X GET 'http://localhost:9200/_cluster/health/?pretty=true'
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```
```
curl -X DELETE http://localhost:9200/ind-1
curl -X DELETE http://localhost:9200/ind-2
curl -X DELETE http://localhost:9200/ind-3
```
Задача 3

В данном задании вы научитесь:

    создавать бэкапы данных
    восстанавливать индексы из бэкапов

Создайте директорию {путь до корневой директории с elasticsearch в образе}/snapshots.

Используя API зарегистрируйте данную директорию как snapshot repository c именем netology_backup.

Приведите в ответе запрос API и результат вызова API для создания репозитория.

Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.

Создайте snapshot состояния кластера elasticsearch.

Приведите в ответе список файлов в директории со snapshotами.

Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.

Восстановите состояние кластера elasticsearch из snapshot, созданного ранее.

Приведите в ответе запрос к API восстановления и итоговый список индексов.

Подсказки:

    возможно вам понадобится доработать elasticsearch.yml в части директивы path.repo и перезапустить elasticsearch
```
root@vagrant:/vagrant/elasticsearch# curl -X PUT "http://localhost:9200/_snapshot/netology_backup?verify=false&pretty" -H 'Content-Type: application/json' -d'{"type": "fs","settings": {"location": "/opt/elasticsearch-8.2.2/snapshot"}}'
{
  "acknowledged" : true
}
```
```
curl -X PUT "localhost:9200/test" -H 'Content-Type: application/json' -d'{"settings": {"index": {"number_of_shards": 1,"number_of_replicas": 0}}}'
```
```
root@vagrant:/vagrant/elasticsearch# curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  W24qw2EsQKOYrGiwIQxRrg   1   0          0            0       225b           225b
```
```
root@vagrant:/vagrant/elasticsearch# docker exec -u root -it 2e6baa9aec73 bash
[root@2e6baa9aec73 elasticsearch-8.2.2]#
```
```
curl -X PUT "http://localhost:9200/_snapshot/netology_backup/test_snapshot?wait_for_completion=true&pretty"
```
```
root@vagrant:/vagrant/elasticsearch# docker exec 2e6baa9aec73 bash -c "ls -la /opt/elasticsearch-8.2.2/snapshot/"
total 48
drwxr-xr-x 3 elasticsearch elasticsearch  4096 Jun  3 12:34 .
drwxr-xr-x 1 elasticsearch elasticsearch  4096 Jun  3 11:05 ..
-rw-r--r-- 1 elasticsearch elasticsearch   846 Jun  3 12:34 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Jun  3 12:34 index.latest
drwxr-xr-x 4 elasticsearch elasticsearch  4096 Jun  3 12:34 indices
-rw-r--r-- 1 elasticsearch elasticsearch 18244 Jun  3 12:34 meta-vWGmuB4cRu60evTMjqozuQ.dat
-rw-r--r-- 1 elasticsearch elasticsearch   355 Jun  3 12:34 snap-vWGmuB4cRu60evTMjqozuQ.dat
```
```
root@vagrant:/vagrant/elasticsearch# curl -X DELETE http://localhost:9200/test && curl -X PUT "localhost:9200/test-2" -H 'Content-Type: application/json' -d'{"settings": {"index": {"number_of_shards": 1,"number_of_replicas": 0}}}'
```
```
root@vagrant:/vagrant/elasticsearch# curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 K_MvQ1LgQhmMX4L6pBfYeQ   1   0          0            0       225b           225b
```
```
root@vagrant:/vagrant/elasticsearch# curl -X GET 'http://localhost:9200/_snapshot?pretty'
{
  "netology_backup" : {
    "type" : "fs",
    "uuid" : "HdqNHcikQVyKMUCubhhCoQ",
    "settings" : {
      "location" : "/opt/elasticsearch-8.2.2/snapshot"
    }
  }
}
```
```
root@vagrant:/vagrant/elasticsearch# curl -X POST "http://localhost:9200/_snapshot/netology_backup/test_snapshot/_restore?pretty" -H 'Content-Type: application/json' -d'{"indices": "*","include_global_state": true}'
{
  "accepted" : true
}
```
```
root@vagrant:/vagrant/elasticsearch# curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 K_MvQ1LgQhmMX4L6pBfYeQ   1   0          0            0       225b           225b
green  open   test   1d_uJ45_TOyDAhgKzk5VbA   1   0          0            0       225b           225b
```