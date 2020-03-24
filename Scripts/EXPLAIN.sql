EXPLAIN (analyze, verbose, costs, timing, buffers)
<query_text>
--analyze выводит фактическое число строк и время выполнения, накопленное в каждом узле плана, вместе с теми же оценками, что выдаёт обычная команда EXPLAIN
--verbose включает в план дополнительную информацию (о столбцах и иную)
--costs показывает стоимость
--timing дает сведения о хронометраже на этапе выполнения (на что расходуется время)
--buffers дает сведения о буферах