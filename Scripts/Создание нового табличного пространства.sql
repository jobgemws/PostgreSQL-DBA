--под пользователем СУБД создать нужный каталог, например следующим образом:
--postgres$ cd /home/postgres
--postgres$ mkdir ts_dir
create tablespace ts location '/home/postgres/ts_dir';