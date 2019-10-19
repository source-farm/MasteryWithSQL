-- Операторы сравнения.
-- Поддерживаются =, <, >, <=, >=, != (non-standard) or <> (SQL way).
select title, rental_duration
  from film
 where rental_duration = 5;

-- Сравнение строк чувствительно к регистру.
-- Для строковых литералов используются одинарные кавычки.
-- Двойные используются только для идентификации таблиц, столбцов и т.д. (aliasing).
select *
  from customer
 where first_name = 'MARY'; -- 'mary' не даст никаких результатов.

-- Функции можно использовать и в WHERE.
select *
  from customer
 where lower(first_name) = 'mary';

-- Даты.
select *
  from rental
 where rental_date > '2006-01-01';

select *
  from rental
 where rental_date = '2006-02-14 15:16:03';
