select c.relname,
current_setting('autovacuum_vacuum_threshold') as av_base_thresh,
current_setting('autovacuum_vacuum_scale_factor') as av_scale_factor,
(current_setting('autovacuum_vacuum_threshold')::int+
(current_setting('autovacuum_vacuum_scale_factor')::float*c.reltuples)) as av_thresh,
s.n_dead_tup
from pg_stat_user_tables as s
join pg_class as c on s.relname=c.relname
where s.n_dead_tup>(current_setting('autovacuum_vacuum_threshold')::int
+(current_setting('autovacuum_vacuum_scale_factor')::float*c.reltuples));