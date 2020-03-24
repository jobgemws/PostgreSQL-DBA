select sum(blks_hit)*100/sum(blks_hit+blks_read) as hit_radio
from pg_catalog.pg_stat_database;