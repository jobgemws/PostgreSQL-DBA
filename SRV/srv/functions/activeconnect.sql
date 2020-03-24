-- FUNCTION: srv.activeconnect(text)
 
--DROP FUNCTION srv.activeconnect(text);
 
CREATE OR REPLACE FUNCTION srv.activeconnect(
    dbname text)
    RETURNS TABLE(db_name text, use_name text)
    LANGUAGE 'plpgsql'
 
    COST 100
    VOLATILE
    ROWS 1000
AS $BODY$BEGIN
    RETURN QUERY
    SELECT datname::text, usename::text
    FROM pg_stat_activity
    WHERE pid <> pg_backend_pid()
    AND (datname = dbname);
END; $BODY$;
 
ALTER FUNCTION srv.activeconnect(text)
    OWNER TO postgres;
	
--example:
/*
SELECT *
from srv.activeconnect(
	'srv'
);
*/