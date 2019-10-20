-- Сортировка по возрастанию поля length.
  select title, length
    from film
order by length asc; -- по-умолчанию сортировка идёт по возрастанию, поэтому asc необъязателен

-- Сортировка по убыванию поля length.
  select title, length
    from film
order by length desc;

-- Сортировка по убыванию поля length. Если length содержит NULL'ы, то они будут в начале.
  select title, length
    from film
order by length desc nulls first; -- nulls first (nulls last) - это расширение PostgreSQL.

-- Сортировка по нескольким полям.
-- Сначала строки сортируются по возрастанию на основе значения поля length.
-- Строки с одинаковым значением поля length сортируются дальше по полю title.
  select length, title
    from film
order by length, title;

-- Сортировка по последней букве поля title.
  select length, title
    from film
order by right(title, 1);

-- Сортировка по alias полю.
  select title, rental_rate, replacement_cost, ceil(replacement_cost/rental_rate) as break_even
    from film
-- where break_even > 10 -- будет ошибка неизвестного поля
order by break_even desc;
