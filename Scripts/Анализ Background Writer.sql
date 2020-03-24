select *
from pg_stat_bgwriter
where maxwritten_clean>0 or buffers_backend_fsync>0 --это плохо (в первом случае будет большая нагрузка на чекпоинты, а во втором-нужно улучшать систему ввода-вывода);