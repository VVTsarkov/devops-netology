Царьков В.В.
Домашнее задание к занятию "6.2. SQL"
Введение

Перед выполнением задания вы можете ознакомиться с дополнительными материалами.
Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

```
root@vagrant:/vagrant/docker-compose# cat docker-compose.yaml
version: '3.5'

services:
  postgres:
    container_name: postgres
    image: postgres:12
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-postgres}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-postgres}
      PGDATA: /data/postgres
    volumes:
       - postgres_data:/data/postgres
       - postgres_backup:/data/backup/postgres
    ports:
      - "5432:5432"
    restart: always

volumes:
  postgres_data:
  postgres_backup:

```
```
root@vagrant:/vagrant/docker-compose# docker-compose up -d
Creating network "docker-compose_default" with the default driver
Creating volume "docker-compose_postgres_data" with default driver
Creating volume "docker-compose_postgres_backup" with default driver
Pulling postgres (postgres:12)...
12: Pulling from library/postgres
c229119241af: Pull complete
3ff4ca332580: Pull complete
5037f3c12de6: Pull complete
0444ef779945: Pull complete
47098a4166e7: Pull complete
203cca980fab: Pull complete
a479b6c0e001: Pull complete
1eaa9abe8ca4: Pull complete
d75de4191ec9: Pull complete
512622d47d8a: Pull complete
739b0cc3f951: Pull complete
03678d273a66: Pull complete
ef189ffe6cdd: Pull complete
Digest: sha256:dccefcef098597b666c0a7012ffdb0187a84fd48868c1165cb72d031f0e36e7c
Status: Downloaded newer image for postgres:12
Creating postgres ... done
```
```
root@vagrant:/vagrant/docker-compose# docker-compose ps
  Name                Command              State                    Ports
-------------------------------------------------------------------------------------------
postgres   docker-entrypoint.sh postgres   Up      0.0.0.0:5432->5432/tcp,:::5432->5432/tcp

```
Задача 2

В БД из задачи 1:

    создайте пользователя test-admin-user и БД test_db
```
CREATE ROLE "test-admin-user" PASSWORD 'test' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN;
```
```
CREATE DATABASE test_db;
```
    в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
```
CREATE TABLE orders (
    id serial primary key,
    Name varchar(80),
    Price int
);
```
```
CREATE TABLE clients (
    id serial primary key,
    Last_Name varchar(20),
    Country varchar(20),
    OrderID int REFERENCES orders (id)
);
```
```
CREATE INDEX ON clients (country);
```
```
COMMENT ON COLUMN orders.name IS 'Наименование';
COMMENT ON COLUMN orders.price IS 'Цена';
```
```
COMMENT ON COLUMN clients.last_name IS 'Фамилия';
COMMENT ON COLUMN clients.country IS 'Страна проживания';
COMMENT ON COLUMN clients.orderid IS 'Заказ';
```
    предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
```
GRANT ALL ON TABLE public.clients, public.orders TO "test-admin-user";
```
    создайте пользователя test-simple-user
```
CREATE ROLE "test-simple-user" PASSWORD 'test1' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;
```
    предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
```
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE public.clients, public.orders TO "test-simple-user";
```

Таблица orders:

    id (serial primary key)
    наименование (string)
    цена (integer)

Таблица clients:

    id (serial primary key)
    фамилия (string)
    страна проживания (string, index)
    заказ (foreign key orders)

Приведите:

    итоговый список БД после выполнения пунктов выше,
```
test_db=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)
```
    описание таблиц (describe)
```
test_db=# \d+ clients
                                                            Table "public.clients"
  Column   |         Type          | Collation | Nullable |               Default               | Storage  | Stats t
arget |    Description
-----------+-----------------------+-----------+----------+-------------------------------------+----------+--------
------+-------------------
 id        | integer               |           | not null | nextval('clients_id_seq'::regclass) | plain    |
      |
 last_name | character varying(20) |           |          |                                     | extended |
      | Фамилия
 country   | character varying(20) |           |          |                                     | extended |
      | Страна проживания
 orderid   | integer               |           |          |                                     | plain    |
      | Заказ
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_orderid_fkey" FOREIGN KEY (orderid) REFERENCES orders(id)
Access method: heap
```
```
test_db=# \d+ orders
                                                        Table "public.orders"
 Column |         Type          | Collation | Nullable |              Default               | Storage  | Stats targe
t | Description
--------+-----------------------+-----------+----------+------------------------------------+----------+------------
--+--------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |
  |
 name   | character varying(80) |           |          |                                    | extended |
  | Наименование
 price  | integer               |           |          |                                    | plain    |
  | Цена
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_orderid_fkey" FOREIGN KEY (orderid) REFERENCES orders(id)
Access method: heap
```
    SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
```
SELECT table_catalog, table_name, array_agg(privilege_type), grantee
FROM information_schema.table_privileges
WHERE (table_schema NOT IN ('information_schema','pg_catalog')) and (grantee !='postgres')
GROUP BY grantee, table_catalog, table_name;
```
	список пользователей с правами над таблицами test_db
```
 table_catalog | table_name |                         array_agg                         |     grantee
---------------+------------+-----------------------------------------------------------+------------------
 test_db       | clients    | {INSERT,SELECT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER} | test-admin-user
 test_db       | orders     | {INSERT,SELECT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER} | test-admin-user
 test_db       | clients    | {INSERT,SELECT,UPDATE,DELETE}                             | test-simple-user
 test_db       | orders     | {INSERT,SELECT,UPDATE,DELETE}                             | test-simple-user
(4 rows)
```
Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders
Наименование 	цена
Шоколад 	10
Принтер 	3000
Книга 	500
Монитор 	7000
Гитара 	4000
```
INSERT INTO public.orders (name,price) VALUES
('Шоколад',10),
('Принтер',3000),
('Книга',500),
('Монитор',7000),
('Гитара',4000);
```
Таблица clients
ФИО 	Страна проживания
Иванов Иван Иванович 	USA
Петров Петр Петрович 	Canada
Иоганн Себастьян Бах 	Japan
Ронни Джеймс Дио 	Russia
Ritchie Blackmore 	Russia
```
INSERT INTO public.clients (last_name,country) VALUES
('Иванов Иван Иванович','USA'),
('Петров Петр Петрович','Canada'),
('Иоганн Себастьян Бах','Japan'),
('Ронни Джеймс Дио','Russia'),
('Ritchie Blackmore','Russia');
```
Используя SQL синтаксис:

    вычислите количество записей для каждой таблицы
    приведите в ответе:
        запросы
        результаты их выполнения.
```
SELECT 'clients' as name_table, COUNT(*) as all_entries FROM clients
UNION ALL
SELECT 'orders' as name_table, COUNT(*) as all_entries FROM orders;
```
```
 name_table | all_entries
------------+-------------
 clients    |           5
 orders     |           5
(2 rows)
```
Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:
ФИО 	Заказ
Иванов Иван Иванович 	Книга
Петров Петр Петрович 	Монитор
Иоганн Себастьян Бах 	Гитара

Приведите SQL-запросы для выполнения данных операций.
```
CREATE TABLE orders_to_clients (
  id serial PRIMARY KEY,
  id_clients integer,
  id_product integer,
  FOREIGN KEY (id_clients) REFERENCES clients (id),
  FOREIGN KEY (id_product) REFERENCES orders (id)
);
```
```
insert into orders_to_clients (id_clients,id_product) values
(1,3),
(2,4),
(3,5);
```
Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
```
select last_name, country, name, price from orders_to_clients 
join clients on clients.id=orders_to_clients.id_clients
join orders on orders.id=orders_to_clients.id_product;
```
```
     last_name        | country |    name | price
----------------------------------------+---------+
 Иванов Иван Иванович | USA     | Книга   |   500
 Петров Петр Петрович | Canada  | Монитор |  7000
 Иоганн Себастьян Бах | Japan   | Гитара  |  4000
(3 rows)
```
Подсказк - используйте директиву UPDATE.

Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.
```
 EXPLAIN SELECT * FROM clients WHERE orderid IS NOT null;
                         QUERY PLAN
------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..15.30 rows=527 width=124)
   Filter: (orderid IS NOT NULL)
(2 rows)
```
```
Seq Scan — последовательное, блок за блоком, чтение данных таблицы clients
Вывод данной команды покажет нам затраты на чтение строк. И количество вернувшихся строк, а так же стредний размер.
```

Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
```
 pg_dump -h 172.20.10.14 -U postgres -W -f /data/backup/postgres/test_db.dump -Fc test_db -Z 5 -v
```
```
root@b7f824a82e71:/data/backup/postgres# ls -la
total 20
drwxr-xr-x 2 root root 4096 Apr  7 09:35 .
drwxr-xr-x 3 root root 4096 Apr  5 10:42 ..
-rw-r--r-- 1 root root 9806 Apr  7 09:36 test_db.dump
```
Остановите контейнер с PostgreSQL (но не удаляйте volumes).
```
root@vagrant:/vagrant/docker-compose# docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED        STATUS       PORTS                                       NAMES
b7f824a82e71   postgres:12   "docker-entrypoint.s…"   47 hours ago   Up 2 hours   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres
root@vagrant:/vagrant/docker-compose# docker stop postgres
postgres
root@vagrant:/vagrant/docker-compose# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
Поднимите новый пустой контейнер с PostgreSQL.
```
root@vagrant:/vagrant/docker-compose# docker-compose up -d
Creating postgres ... done
root@vagrant:/vagrant/docker-compose#
```
Восстановите БД test_db в новом контейнере.
```
root@vagrant:/vagrant/docker-compose# docker exec -it postgres bash
root@16b6daf23ee7:/# cd /data/backup/postgres/
root@16b6daf23ee7:/data/backup/postgres# ls
test_db.dump
```
```
postgres=# pg_restore -U postgres -C -d postgres /data/backup/postgres/test_db.dump -v
postgres-# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)

postgres-# \c test_db
You are now connected to database "test_db" as user "postgres".
test_db-# \d+
                                 List of relations
 Schema |           Name           |   Type   |  Owner   |    Size    | Description
--------+--------------------------+----------+----------+------------+-------------
 public | clients                  | table    | postgres | 8192 bytes |
 public | clients_id_seq           | sequence | postgres | 8192 bytes |
 public | orders                   | table    | postgres | 8192 bytes |
 public | orders_id_seq            | sequence | postgres | 8192 bytes |
 public | orders_to_clients        | table    | postgres | 8192 bytes |
 public | orders_to_clients_id_seq | sequence | postgres | 8192 bytes |
(6 rows)
```
