Царьков В.В.
Домашнее задание к занятию "6.4. PostgreSQL"
Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя psql.

Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.

Найдите и приведите управляющие команды для:

    вывода списка БД
    подключения к БД
    вывода списка таблиц
    вывода описания содержимого таблиц
    выхода из psql
```
root@vagrant:/vagrant/docker-compose# cat docker-compose.yaml
version: '3.5'

services:
  postgres:
    container_name: postgres_13
    image: postgres:13
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-postgres}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-postgres}
      PGDATA: /var/lib/postgresql/data/pgdata
    volumes:
       - /data/postgresql:/var/lib/postgresql/data
       - /data/postgresql/backup:/var/lib/postgresql/backup
    ports:
      - "5432:5432"
    restart: always
```
```
root@b8c2e4888d2c:/# psql -U postgres
psql (13.7 (Debian 13.7-1.pgdg110+1))
Type "help" for help.
postgres=#
```
```
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)
```
```
postgres=# \c postgres
You are now connected to database "postgres" as user "postgres".
```
```
postgres=# \dt
Did not find any relations.
postgres=# \dtS
                    List of relations
   Schema   |          Name           | Type  |  Owner
------------+-------------------------+-------+----------
 pg_catalog | pg_aggregate            | table | postgres
 pg_catalog | pg_am                   | table | postgres
 pg_catalog | pg_amop                 | table | postgres
 pg_catalog | pg_amproc               | table | postgres
...
 pg_catalog | pg_user_mapping         | table | postgres
(62 rows)
```
```
postgres=# \dS+ pg_index
                                      Table "pg_catalog.pg_index"
     Column     |     Type     | Collation | Nullable | Default | Storage  | Stats target | Description
----------------+--------------+-----------+----------+---------+----------+--------------+-------------
 indexrelid     | oid          |           | not null |         | plain    |              |
 indrelid       | oid          |           | not null |         | plain    |              |
 indnatts       | smallint     |           | not null |         | plain    |              |
 indnkeyatts    | smallint     |           | not null |         | plain    |              |
 ...
Indexes:
    "pg_index_indexrelid_index" UNIQUE, btree (indexrelid)
    "pg_index_indrelid_index" btree (indrelid)
Access method: heap
```
```
postgres=# \q
root@b8c2e4888d2c:/#
```
Задача 2

Используя psql создайте БД test_database.

Изучите бэкап БД.

Восстановите бэкап БД в test_database.

Перейдите в управляющую консоль psql внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.

Приведите в ответе команду, которую вы использовали для вычисления и полученный результат.
```
postgres=# create database test_database;
CREATE DATABASE
postgres=# \l
                                   List of databases
     Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
---------------+----------+----------+------------+------------+-----------------------
 postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)
```
```
root@b8c2e4888d2c:/var/lib/postgresql/backup# psql -U postgres test_database < /var/lib/postgresql/backup/test_dump.sql
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
```
```
postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# \d+
                                   List of relations
 Schema |     Name      |   Type   |  Owner   | Persistence |    Size    | Description
--------+---------------+----------+----------+-------------+------------+-------------
 public | orders        | table    | postgres | permanent   | 8192 bytes |
 public | orders_id_seq | sequence | postgres | permanent   | 8192 bytes |
(2 rows)
```
```
test_database=# analyze verbose public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```
```
test_database=# select tablename, attname, avg_width from pg_stats where avg_width in (select max(avg_width) from pg_stats where tablename = 'orders');
 tablename | attname | avg_width
-----------+---------+-----------
 orders    | title   |        16
(1 row)
```
Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
```
test_database=# alter table orders rename to orders_old;
ALTER TABLE
test_database=# create table orders as table orders_old with no data;
CREATE TABLE AS
test_database=# Create table orders_1 (
    Check ( price > 499 )
    )
Inherits (orders);
CREATE TABLE
test_database=# Create table orders_2 (
    Check (price <= 499 )
    )
Inherits (orders);
CREATE TABLE
test_database=# Create Rule orders_insert_to_1 as on insert to orders
where ( price > 499 )
Do instead insert into orders_1 values (new.*);
CREATE RULE
test_database=# Create Rule orders_insert_to_2 as on insert to orders
where ( price <= 499 )
Do instead insert into orders_2 values (new.*);
CREATE RULE
test_database=# Insert into orders select * from orders_old;
INSERT 0 0
```
Задача 4

Используя утилиту pg_dump создайте бекап БД test_database.
```
root@b8c2e4888d2c:/# pg_dump -h 172.20.10.14 -U postgres -W -f /var/lib/postgresql/backup/backup_bd.dump test_database -v
Password:
```
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?
```
	Нужно добавить критерий UNIQUE
CREATE TABLE public.orders (
    id integer,
    title character varying(80) UNIQUE,
    price integer
);
	Или индекс или первичный ключ.

    CREATE INDEX ON orders ((lower(title)));
```