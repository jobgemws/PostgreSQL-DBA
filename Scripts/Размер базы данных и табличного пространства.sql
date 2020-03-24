--current_database()-возвращает имя текущей БД
--в КБ
select pg_size_pretty(pg_database_size(current_database()));
--в байтах
select pg_database_size(current_database());
--для табличного пространства в КБ
select pg_size_pretty(pg_tablespace_size('<tablespace_name>'));