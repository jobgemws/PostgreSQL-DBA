CREATE FUNCTION test.sum_n_product (x int=0, y int=0, OUT sum int, OUT product int)
AS 'SELECT x + y, x * y'
LANGUAGE SQL;

--example:
/*
do $$
declare x integer=5;
        y integer=7;
        res_sum integer;
        res_product integer;
begin
    select sum, product
    into res_sum, res_product
    from test.sum_n_product(x, y);
 
    RAISE NOTICE '%,%', res_sum, res_product;
end $$
*/