CREATE TABLE psa (datid int, datname text);
 
CREATE FUNCTION test.getpsa(text) RETURNS setof psa AS $$
    SELECT datid::int, datname::text FROM pg_catalog.pg_stat_activity where datname=$1;
$$ LANGUAGE SQL;

--example:
/*
select *
from test.getpsa('SRV');
*/