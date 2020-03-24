--снятие запроса без закрытия подключения
select pg_cancel_backend (pid);
--снятие запроса с закрытием подключения
select pg_terminate_backend (pid);
--отключить всех пользователей, кроме себя самого:
select pg_terminate_backend (pid)
from pg_stat_activity
where pid<>pg_backend_pid() and backend_type = 'client backend';