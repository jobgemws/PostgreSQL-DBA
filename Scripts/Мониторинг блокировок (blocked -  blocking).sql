--В основе статья http://zelark.github.io/exploring-query-locks-in-postgres/
select
    coalesce(bgl.relation::regclass::text, bgl.locktype) as locked_item,
    now() - bda.query_start as waiting_duration,
    bda.pid as blocked_pid,
    bda.query as blocked_query,
    bdl.mode as blocked_mode,
    bga.pid as blocking_pid,
    bga.query as blocking_query,
    bgl.mode as blocking_mode
  from pg_catalog.pg_locks bdl
    join pg_stat_activity bda
      on bda.pid = bdl.pid
    join pg_catalog.pg_locks bgl
      on bgl.pid != bdl.pid
      and (bgl.transactionid = bdl.transactionid
        or bgl.relation = bdl.relation and bgl.locktype = bdl.locktype)
    join pg_stat_activity bga
      on bga.pid = bgl.pid
      and bga.datid = bda.datid
  where not bdl.granted
    and bga.datname = current_database();