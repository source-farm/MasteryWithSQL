-- Получение колонки, где продолжительность аренды указана в часах.
-- Такие колонки называются derived (или computed) колонками.
select title, rental_duration * 24 as "rental duration (hrs)"
  from film;

-- SQL калькулятор.
select
    3 * 3 as "multiplication",
    3 + 3 as "addition",
    3 / 3 as "division",
    3 - 3 as "subtraction";

-- Работа с датами.
select rental_date, return_date - rental_date as "duration"
  from rental;

-- Объединение строковых колонок с помощью оператора конкатенации ||.
select first_name, last_name, first_name || ' ' || last_name as "Full Name"
  from customer;

-- Использование функции.
select first_name, last_name, initcap(first_name || ' ' || last_name) as "Full Name"
  from customer;
