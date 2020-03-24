CREATE OR REPLACE FUNCTION test.tf1(accountno integer=0, debit numeric=0)
 RETURNS numeric
 LANGUAGE sql
AS $function$
    SELECT (accountno+debit);
$function$
;

--example:
/*
do $$
declare accountno integer=5;
        debit integer=7;
        res integer;
begin
    res=test.tf1(accountno, debit);
 
    RAISE NOTICE '%', res;
end $$
*/