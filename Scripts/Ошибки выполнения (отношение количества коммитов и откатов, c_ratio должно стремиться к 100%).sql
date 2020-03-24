select datname,
case when (xact_commit+xact_rollback=0) then 100 else (xact_commit*100)/(xact_commit+xact_rollback) end as c_ratio, -->=95
deadlocks, --<=0
conflicts, --<=10
temp_files, --<=100
xact_commit,
xact_rollback,
pg_size_pretty(temp_bytes) as temp_size --<=10 GB
from pg_stat_database;