--Для начала включим мониторинг AUTOVACUUM на сервере (записывается в postgresql.conf)
ALTER SYSTEM SET log_autovacuum_min_duration = 0;
SELECT pg_reload_conf();
 
--Cоздадим представление, показывающее, какие таблицы в данный момент нуждаются в очистке. Оно будет использовать функцию,
--возвращающую текущее значение параметра с учетом того, что оно может быть переопределено на уровне таблицы:
CREATE FUNCTION get_value(param text, reloptions text[], relkind "char")
RETURNS float
AS $$
  SELECT coalesce(
    -- если параметр хранения задан, то берем его
    (SELECT option_value
     FROM   pg_options_to_table(reloptions)
     WHERE  option_name = CASE
              -- для toast-таблиц имя параметра отличается
              WHEN relkind = 't' THEN 'toast.' ELSE ''
            END || param
    ),
    -- иначе берем значение конфигурационного параметра
    current_setting(param)
  )::float;
$$ LANGUAGE sql;
 
--VACUUM. Представление из которого можно уже делать анализ необходимости
CREATE VIEW need_vacuum AS
  SELECT c.nspname as schema_name,
         st.relname as tablename,
         c.reltuples as CurrentRows,
         st.n_dead_tup as dead_tup,
         get_value('autovacuum_vacuum_threshold', c.reloptions, c.relkind) +
         get_value('autovacuum_vacuum_scale_factor', c.reloptions, c.relkind) * c.reltuples as max_dead_tup,        
         st.last_autovacuum
  FROM   pg_stat_all_tables as st
    INNER JOIN
            (SELECT pc.oid,pn.nspname,pc.relname,pc.reltuples,pc.reloptions, pc.relkind
            FROM pg_class pc
            INNER JOIN pg_namespace pn on pn.oid = pc.relnamespace
            GROUP BY pc.oid,pn.nspname,pc.relname,pc.reltuples,pc.reloptions, pc.relkind) as c
  ON  c.oid = st.relid
  AND    c.relkind IN ('r','m','t')
 ORDER BY c.nspname,st.relname;
 
--ANALYZE. Представление из которого можно уже делать анализ необходимости
CREATE VIEW need_analyze AS
  SELECT c.nspname as schema_name,
         st.relname as tablename,
         c.reltuples as CurrentRows,
         st.n_mod_since_analyze mod_tup,
         get_value('autovacuum_analyze_threshold', c.reloptions, c.relkind) +
         get_value('autovacuum_analyze_scale_factor', c.reloptions, c.relkind) * c.reltuples as max_mod_tup,        
         st.last_autoanalyze
  FROM   pg_stat_all_tables as st
    INNER JOIN
            (SELECT pc.oid,pn.nspname,pc.relname,pc.reltuples,pc.reloptions, pc.relkind
            FROM pg_class pc
            INNER JOIN pg_namespace pn on pn.oid = pc.relnamespace
            GROUP BY pc.oid,pn.nspname,pc.relname,pc.reltuples,pc.reloptions, pc.relkind) as c
  ON  c.oid = st.relid
  AND    c.relkind IN ('r','m','t')
 ORDER BY c.nspname,st.relname;