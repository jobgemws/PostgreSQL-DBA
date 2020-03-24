-- PROCEDURE: srv.killconnect(text, text)
 
-- DROP PROCEDURE srv.killconnect(text, text);
 
CREATE OR REPLACE PROCEDURE srv.killconnect(
    databasename text,
    loginname text)
LANGUAGE 'sql'
 
AS $BODY$SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE pid <> pg_backend_pid()
AND (datname = databasename OR databasename IS NULL)
AND (usename= loginname OR loginname IS NULL);$BODY$;

--example:
/*
do $$
declare
    databasename text:='SRV';
    loginname text:=null;
 
begin
    CALL srv.killconnect(
    databasename,
    loginname
);
 
END $$;
 
SELECT *
FROM pg_stat_activity
WHERE pid <> pg_backend_pid()
AND (datname = 'SRV')
--AND (usename is not null);
*/