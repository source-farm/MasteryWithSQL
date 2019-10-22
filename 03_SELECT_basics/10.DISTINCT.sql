-- Все значения поля customer_id без дубликатов.
select distinct customer_id
  from payment;

-- DISTINCT убирает дубликаты строк, т.е. следующий запрос возвращает только
-- строки с уникальной комбинацией полей customer_id и staff_id.
select distinct customer_id, staff_id
  from payment
 where customer_id = 269;

-- DISTINCT как часть выражения SELECT начинает работать только когда выполнение
-- запроса доходит до SELECT. Внутри SELECT'а DISTINCT выполняется после применения
-- функций или обработки каких-либо выражений.
-- Следующий запрос находит месяцы по годам, когда вообще были выполнены какие-либо платежи.
  select distinct
         date_part('month', payment_date) as month,
         date_part('year', payment_date) as year
    from payment
order by year;
