-- Фильтрация NULL значений.
select *
  from customer
 where email is null;

-- Фильтрация не NULL значений.
select *
  from customer
 where email is not null;

-- Следующий запрос ничего не возвращает. SQL при сравнении
-- использует так называемую троичную логику. В общем случае результатом
-- сравнения могут быть true, false или unknown. Когда сравниваются два
-- значения, которые не могут быть равны NULL, то результат всегда равен
-- true или false. Но если один из операндов равен NULL, то результат всегда
-- будет unknown. Выражение where возвращает только те строки, для которых
-- был получен true.
select *
  from customer
 where email = null; -- результатом будет unknown, поэтому не получим ни одной строки.

-- Фильмы, рейтинг которых не равен 'PG'.
select title, rating
  from film
 where rating != 'PG' or rating is null;
