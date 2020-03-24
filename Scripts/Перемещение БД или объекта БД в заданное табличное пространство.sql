--перемещение БД в заданное табличное пространство
alter database <db_name> set tablespace <tablespace_name>;
--перемещение таблицы в заданное табличное пространство
alter table <db_name> set tablespace <tablespace_name>;
--перемещение всех таблиц из заданного табличное пространство в заданное табличное пространство
alter table all in tablespace <source_tablespace_name> set tablespace <target_tablespace_name>;