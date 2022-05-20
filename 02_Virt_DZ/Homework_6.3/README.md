Царьков В.В.
Домашнее задание к занятию "6.3. MySQL"
Введение

Перед выполнением задания вы можете ознакомиться с дополнительными материалами.
Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
```
version: '3.5'       
       
services:

  mysql:
    container_name: mysql
    image: mysql:8.0
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root1234
    volumes:
      - /data/mysql:/var/lib/mysql
    ports:
      - "3306:3306"
```
Изучите бэкап БД и восстановитесь из него.

Перейдите в управляющую консоль mysql внутри контейнера.
```
root@8a88e69ee14c:/# mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 17
Server version: 8.0.28 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          11
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.28 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 39 min 3 sec

Threads: 2  Questions: 5  Slow queries: 0  Opens: 117  Flush tables: 3  Open tables: 36  Queries per second avg: 0.002
--------------

mysql>

```
```
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.13 sec)
```
```
mysql> create database test_db;
Query OK, 1 row affected (0.03 sec)
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test_db            |
+--------------------+
5 rows in set (0.00 sec)

```
Используя команду \h получите список управляющих команд.

Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

Приведите в ответе количество записей с price > 300.
```
root@8a88e69ee14c:/var/lib/mysql# mysql -uroot -p test_db < test_dump.sql
Enter password:
root@8a88e69ee14c:/var/lib/mysql#
```
```
mysql> \u test_db
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.01 sec)
```
```
mysql> select * from orders where price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.01 sec)

mysql>
```
В следующих заданиях мы будем продолжать работу с данным контейнером.
Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:

    плагин авторизации mysql_native_password
    срок истечения пароля - 180 дней
    количество попыток авторизации - 3
    максимальное количество запросов в час - 100
    аттрибуты пользователя:
        Фамилия "Pretty"
        Имя "James"

Предоставьте привелегии пользователю test на операции SELECT базы test_db.
```
mysql> CREATE USER 'test'@'localhost' IDENTIFIED BY 'test-pass';
Query OK, 0 rows affected (0.04 sec)

mysql> ALTER USER 'test'@'localhost' ATTRIBUTE '{"fname":"James", "lname":"Pretty"}';
Query OK, 0 rows affected (0.00 sec)
```
```
mysql> ALTER USER 'test'@'localhost' IDENTIFIED BY 'test-pass' WITH MAX_QUERIES_PER_HOUR 100 PASSWORD EXPIRE INTERVAL 180 DAY FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2;
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT Select ON test_db.orders TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.01 sec)
```
```
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)
```

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.
Задача 3

Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.

Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.

Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:

    на MyISAM
    на InnoDB
```
mysql> \u test_db
Database changed
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> select * from orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.00 sec)

mysql> show profiles;
+----------+------------+----------------------+
| Query_ID | Duration   | Query                |
+----------+------------+----------------------+
|        1 | 0.00094200 | select * from orders |
+----------+------------+----------------------+
1 row in set, 1 warning (0.00 sec)
```
```
mysql> select engine from information_schema.tables where table_schema = 'test_db' and table_name = 'orders';
+--------+
| ENGINE |
+--------+
| InnoDB |
+--------+
1 row in set (0.00 sec)
```
```
mysql> alter table orders engine = myisam;
Query OK, 5 rows affected (0.09 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> alter table orders engine = innodb;
Query OK, 5 rows affected (0.07 sec)
Records: 5  Duplicates: 0  Warnings: 0
```
```
mysql> show profiles;
+----------+------------+-------------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                                 |
+----------+------------+-------------------------------------------------------------------------------------------------------+
|        1 | 0.00094200 | select * from orders                                                                                  |
|        2 | 0.00262625 | select engine from information_schema.tables where table_schema = 'test_db' and table_name = 'orders' |
|        3 | 0.08599050 | alter table orders engine = myisam                                                                    |
|        4 | 0.06930275 | alter table orders engine = innodb                                                                    |
+----------+------------+-------------------------------------------------------------------------------------------------------+
4 rows in set, 1 warning (0.00 sec)
```

Задача 4

Изучите файл my.cnf в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):

    Скорость IO важнее сохранности данных
    Нужна компрессия таблиц для экономии места на диске
    Размер буффера с незакомиченными транзакциями 1 Мб
    Буффер кеширования 30% от ОЗУ
    Размер файла логов операций 100 Мб

Приведите в ответе измененный файл my.cnf.
```
root@8a88e69ee14c:/etc/mysql# cat my.cnf
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/
```
```
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

innodb_flush_method = O_DSYNC
innodb_file_per_table = 1
innodb_log_buffer_size = 1M
innodb_buffer_pool_size= 1G
innodb_log_file_size = 100M

# Custom config should go here
!includedir /etc/mysql/conf.d/
```