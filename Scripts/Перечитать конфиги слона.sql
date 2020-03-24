SELECT pg_reload_conf();
 
--параметры, требующие перезапуска службы слона (systemctl restart postgresql)
select name, setting from pg_settings where context = 'postmaster';