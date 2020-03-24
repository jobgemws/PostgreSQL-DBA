--прерывание запроса
select pg_cancel_backend(<pid>);
 
--прерывание всего сеанса (в случае с зависшей или забытой транзакцией)
select pg_terminate_backend(<pid>);
 
--прерывание всех зависших сеансов для заблокированного сеанса blocked_pid (unnest-разворачивает массив в строки)
select pg_terminate_backend(b.pid)
from unnest(pg_blocking_pids(<blocked_pid>)) as b(pid);