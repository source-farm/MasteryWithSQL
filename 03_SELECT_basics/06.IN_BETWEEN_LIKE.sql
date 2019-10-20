-- BETWEEN
select customer_id, first_name
  from customer
 where customer_id between 1 and 3; -- 1 <= customer_id and customer_id <= 3

-- NOT BETWEEN
select customer_id, first_name
  from customer
 where customer_id not between 1 and 3;

-- IN
select customer_id, first_name
  from customer
 where customer_id in (2, 3, 5); -- customer_id = 2 or customer_id = 3 or customer_id = 5

-- NOT IN
select customer_id, first_name
  from customer
 where customer_id not in (2, 3, 5);

-- LIKE
select customer_id, first_name
  from customer
 where first_name like 'M%'; -- % означает любое количество символов, включая пустую строку.

select customer_id, first_name
  from customer
 where first_name like '__M%'; -- _ означает любой один символ.

-- ILIKE выполняет сравнение без учёта регистра (PostgreSQL specific).
select customer_id, first_name
  from customer
 where first_name ilike '__m%';

-- SIMILAR TO - некая смесь LIKE и общепринятых регулярных выражений.
select customer_id, first_name
  from customer
 where first_name similar to 'M%L{2}%';
