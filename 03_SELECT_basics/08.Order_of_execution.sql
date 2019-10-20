/*
SQL выражения (clauses) внутри SELECT выполняются в следующем порядке:

    FROM     - выбор таблиц
    WHERE    - фильтрация строк
    GROUP BY - объединение (aggregate) строк
    HAVING   - фильтрация объединений (aggregates)
    SELECT   - выбор полей, для которых будет показан результат
    ORDER BY - сортировка
    LIMIT    - ограничение количества строк в результате
*/

/*
-- Следующий запрос не работает, т.к. поле break_even формируется после where.
  select title, rental_rate, replacement_cost, ceil(replacement_cost/rental_rate) as break_even
    from film
   where break_even > 10 -- будет ошибка неизвестного поля
order by break_even desc;
*/

-- Одно из возможных решений проблемы в запросе выше.
  select title, rental_rate, replacement_cost, ceil(replacement_cost/rental_rate) as break_even
    from film
   where ceil(replacement_cost/rental_rate) > 10
order by break_even desc;
