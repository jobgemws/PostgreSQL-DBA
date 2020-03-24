select *
from pg_stat_replication;--значения (позиции в журнале транзакций) должны совпадать в идеале (реплика не отстает от мастера)
--отставание реплики в секундах
select extract(epoch from now() - pg_last_xact_replay_timestamp());