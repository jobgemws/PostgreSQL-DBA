--в конце список pid, которые блокируют текущий pid
select *, pg_blocking_pids(pid)
from pg_stat_activity
where backend_type='client backend';
 
--вывести все заблокированные запросы (cardinality-подсчитывает мощность множества)
select *, pg_blocking_pids(pid)
from pg_stat_activity
where backend_type='client backend'
and cardinality(pg_blocking_pids(pid))>0;
 
--общий процент подключений
select count(*)*100/(select current_setting('max_connections')::int)
from pg_stat_activity;
 
select client_addr, usename, datname, count(*) as cnt
from pg_stat_activity
group by client_addr, usename, datname
order by cnt desc;
 
--долгие запросы (clock_timestamp()-для вычисления времени работы)
select client_addr, usename, datname, application_name,
       clock_timestamp() - xact_start as xact_age,
       clock_timestamp() - query_start as query_age,
       query
from pg_stat_activity
order by xact_start, query_start;
 
--сколько запросов к базе данных выполняется в данный момент
select datname,
count(*) as open,
count(*) filter (where state='active') as active, --активные
count(*) filter (where state='idle') as idle, --неактивные
count(*) filter (where state='idle in transaction') as idle_in_trans --неактивные, но находящиеся внутри транзакции
from pg_stat_activity
where backend_type='client backend'
group by rollup(1);
 
--как долго выполняются транзакции
select pid, xact_start, now()-xact_start as duration
from pg_stat_activity
where state like '%transaction%'
order by 3 desc;
 
--анализ длительности выполнения активных запросов
select now()-query_start as duration, datname, query
from pg_stat_activity
where state='activite'
order by 1 desc;