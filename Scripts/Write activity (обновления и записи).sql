select s.relname,
pg_size_pretty(pg_relation_size(relid)),
coalesce(n_tup_ins, 0)+2*coalesce(n_tup_upd, 0)-
coalesce(n_tup_hot_upd, 0)+coalesce(n_tup_del, 0) as total_writes,
(coalesce(n_tup_hot_upd, 0)::float*100/(case when n_tup_upd>0 then n_tup_upd else 1 end)::float)::numeric(10,2) as hot_rate, -- (n_tup_hot_upd-это Heap-Only Tuple): не вызывает перестроения индекса или только для тех значения, которые не участвуют в индекса (чем больше значение n_tup_hot_upd, тем лучше (hot_rate должно стремиться к 100). Для увеличения данного значения меняют значение Fillfactor на таблице (70-80%): ALTER TABLE <table_name> SET (fillfactor=70);)
(select v[1] from regexp_matches(reloptions::text, E'fillfactor=(\\d+)') as r(v) limit 1) as fillfactor
from pg_stat_all_tables as s
inner join pg_class as c on c.oid=relid
order by total_writes desc
limit 50;