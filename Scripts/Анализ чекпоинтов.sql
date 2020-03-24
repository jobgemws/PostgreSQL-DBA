select *
from pg_stat_bgwriter
where checkpoints_req>checkpoints_timed --это плохо (кол-во чекпоинтов по принуждению больше кол-ва чекпоинтов по времени);