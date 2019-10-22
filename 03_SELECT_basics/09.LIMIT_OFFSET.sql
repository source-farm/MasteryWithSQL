-- LIMIT
select first_name, last_name
  from customer
 limit 5;

-- LIMIT часто используют вместе с ORDER BY.
  select first_name, last_name
    from customer
order by first_name
   limit 5;

-- OFFSET - смещение от начала на указанное количество строк.
-- Часто используют для реализации пагинации.
  select first_name, last_name
    from customer
order by first_name
   limit 5
  offset 5; -- Сначала смещаемся на 5 строк, затем оставляем
            -- только первые  5 строк (limit 5).
