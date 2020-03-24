SELECT
 nspname as "Schema", relname as "Table", reltuples as "Rows", pc.relpages as "Pages"
 ,pg_size_pretty(pg_total_relation_size(pc.oid)) AS "Total_size" --pg_size_pretty(pg_total_relation_size(relname::regclass)) as full_size
 ,pg_size_pretty(pg_relation_size(relname::regclass)) as Table_Size
 ,pg_size_pretty(pg_total_relation_size(relname::regclass)-pg_relation_size(relname::regclass)) as index_size
FROM
 pg_class pc
 inner join pg_namespace pn on pn.oid = pc.relnamespace
WHERE
 relkind = 'r'::char and
 nspname = 'public'
 order by relname;