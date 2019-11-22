-- Пересечение двух таблиц:
(
    select customer_id
      from customer
     where customer_id between 1 and 10
)
intersect
(
    select customer_id
      from customer
     where customer_id between 5 and 10
)
order by customer_id;

-- Пустое пересечение:
(
    select customer_id
      from customer
     where customer_id between 1 and 5
)
intersect
(
    select customer_id
      from customer
     where customer_id between 6 and 10
)
order by customer_id;

-- Пересечение с сохранением дубликатов сопоставляет строки из двух
-- таблиц по очереди (1 с 1, 1 с 2, 3 с 4) для обнаружения дубликатов
-- и если есть совпадения, то дубликат включается в финальный результат.
-- В этом запросе пересечение состоит только из одного значения 1.
(
    select n
      from (values (1), (1), (3)) as t1(n)
)
intersect all
(
    select n
      from (values (1), (2), (4)) as t2(n)
);
-- В следующем запросе пересечение состоит из двух значений 1.
(
    select n
      from (values (1), (1), (3)) as t1(n)
)
intersect all
(
    select n
      from (values (1), (1), (4)) as t2(n)
);
