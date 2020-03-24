----Скрипт должен выполняться в контексте каждой конкретной БД
--Информация по конкретному индексу таблицы
SELECT n.nspname::varchar(255) as "Schema",
  c.relname::varchar(255) as "Name",
  i.indisvalid::boolean as "IsValid",
  i.indislive::boolean as "IsInProgessDelete",
  i.indisunique::boolean as "IsUnique",
  i.indisprimary::boolean as "IsPrimary",
  (CASE c.relkind WHEN 'r' THEN 'table' WHEN 'v' THEN 'view' WHEN 'm' THEN 'materialized view' WHEN 'i' THEN 'index' WHEN 'S' THEN 'sequence'
  WHEN 's' THEN 'special' WHEN 'f' THEN 'foreign table' WHEN 'p' THEN 'partitioned table' WHEN 'I' THEN 'partitioned index' END)::varchar(50) as "Type",
  pg_catalog.pg_get_userbyid(c.relowner)::varchar(50) as "Owner",
 c2.relname::varchar(50) as "Table",
  pg_catalog.pg_size_pretty(pg_catalog.pg_table_size(c.oid))::varchar(50) as "Size"
FROM pg_catalog.pg_class c
     INNER JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
     INNER JOIN pg_catalog.pg_index i ON i.indexrelid = c.oid
     INNER JOIN pg_catalog.pg_class c2 ON i.indrelid = c2.oid
WHERE c.relkind IN ('i','I','s','')
      AND n.nspname !~ '^pg_toast'
  AND (c.relname = NULL OR c.relname OPERATOR(pg_catalog.~) '^(ix_id_name)$' COLLATE pg_catalog.default)
  AND (c2.relname = NULL OR c2.relname OPERATOR(pg_catalog.~) '^(t_test)$' COLLATE pg_catalog.default)
  AND pg_catalog.pg_table_is_visible(c.oid)
ORDER BY 1,2;
 
----Необходимо также установка extension. Выполнить в студии CREATE EXTENSION pgstattuple
SELECT
    nspname as "Schema",
    relname as "Table",
    reltuples::bigint as "Rows",
    pc.relpages::bigint as "Pages",
    index_name, scans_of_index,tupples_of_index,tupples_of_table, num_writes,
    (SELECT leaf_fragmentation from pgstatindex('"'||index_name||'"'::varchar(255))) as "leaf_fragmentation", --фрагментированность в индексе
    (pg_total_relation_size(pc.oid))/1024/1024::int AS "table_total_size (Mb)",
    (SELECT index_size from pgstatindex('"'||index_name||'"'::varchar(255)))/1024/1024::int as "index_size (Mb)",
    ((SELECT index_size from pgstatindex('"'||index_name||'"'::varchar(255)))/pg_total_relation_size(pc.oid)::float)*100 as "Index Off%", --Размер индекса относительно всей таблицы
    (pg_indexes_size(relname::varchar(255))/pg_total_relation_size(pc.oid)::float)*100 as "Index All Off" --Размер всех индексов по отношению к размеру всей таблицы%"
FROM
        pg_class pc
        INNER JOIN pg_namespace pn on pn.oid = pc.relnamespace
        INNER JOIN (SELECT idstat.relname AS table_name, indexrelname AS index_name
                           ,idstat.idx_scan AS scans_of_index,idstat.idx_tup_read AS tupples_of_index,idstat.idx_tup_fetch AS tupples_of_table
                           ,n_tup_upd + n_tup_ins + n_tup_del as num_writes--, indexdef AS definition
                    FROM pg_stat_user_indexes AS idstat
                        JOIN pg_indexes ON indexrelname = indexname
                        JOIN pg_stat_user_tables AS tabstat ON idstat.relname = tabstat.relname ) U     ON (relname=U.table_name)
WHERE
    relkind = 'r'::char
    --and nspname = 'public'
ORDER BY relname, scans_of_index DESC, num_writes DESC;
 
--использование индексов
select schemaname, relname, indexrelname, idx_scan,
pg_size_pretty(pg_relation_size(indexrelid)) as idx_size,
pg_size_pretty(sum(pg_relation_size(indexrelid)) over (order by idx_scan, indexrelid)) as total
from pg_stat_user_indexes
order by total;
 
--информация о кешировании индекса
select * from pg_statio_user_indexes;