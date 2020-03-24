select pt.spcname, pat.rolname, pt.spcowner, pt.spcacl, pt.spcoptions
from pg_tablespace as pt
inner join pg_authid as pat on pat.oid=pt.spcowner;