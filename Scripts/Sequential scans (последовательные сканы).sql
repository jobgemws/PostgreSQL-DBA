select relname,
       pg_size_pretty(pg_relation_size(relname::regclass)) as size,
       seq_scan,
       seq_tup_read, --больше 1000 может быть неочень
       seq_scan/seq_tup_read as seq_tup_avg
from pg_catalog.pg_stat_user_tables
where seq_tup_read>0
order by 3,4 desc limit 5;