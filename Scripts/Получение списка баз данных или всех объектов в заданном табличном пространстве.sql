--получаем oid нужного табличного пространства
select oid from pg_tablespace where spcname='<tablespace_name>';
 
--получаем список БД в заданном табличном пространстве
select datname
from pg_database
where oid in (select pg_tablespace_databases(<tablespace_oid>));
 
--получаем список всех объектов в заданном табличном пространстве (reltablespace=0-если пространство по умолчанию)
select relnamespace::regnamespace, relname, relkind
from pg_class
where reltablespace=<tablespace_oid>;