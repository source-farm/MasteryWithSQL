-- INNER JOIN можно рассматривать как частный случай CROSS JOIN'а, но
-- с дополнительным фильтром для отсеивания определённых строк.

-- Пример простейшего INNER JOIN'а. Таблица rental содержит поле
-- customer_id, которое является внешним ключом на customer.customer_id.
-- Весь процесс INNER JOIN'а можно описать так: сначала происходит
-- CROSS JOIN таблиц rental и customer, т.е. создаётся новая таблица
-- которая содержит всевозможные пары строк из этих таблиц. Далее остаются
-- только те строки для которых выполняется условие rental.customer_id = customer.customer_id.
-- После отбираются все поля из обеих таблиц и показывается результат.
    select *
      from rental
inner join customer on rental.customer_id = customer.customer_id;

-- Верхний запрос с меньшим количеством полей.
-- Фактически этот запрос показывает кто когда арендовал фильмы.
    select rental_date, first_name, last_name
      from rental
inner join customer on rental.customer_id = customer.customer_id;

-- В запросе выше если бы для поля customer_id какой-либо строки из таблицы rental не было бы
-- соответствующего customer_id в таблицы customer, то эта строка не вошла бы
-- в финальный результат. Рассмотрим это правило на примере таблиц film и film_actor.
-- Таблица film_actor хранит информацию какой актёр в каком фильме снимался, но в этой
-- таблице нет информации о фильме с id 803, т.е. следующий запрос вернёт пустой результат:
select *
  from film_actor
 where film_id = 803;
-- Но в таблице film есть фильм с id 803:
select *
  from film
 where film_id = 803;
-- По правилу, которое мы описали в начале этой серии запросов получается, что в результате
-- выполнения следующего запроса мы не увидим строку с id 803, т.к. такого id нет в таблице
-- film_actor:
    select *
      from film
inner join film_actor on film.film_id = film_actor.film_id;
-- В этом можно убедиться с помощью такого запроса, который возвращает пустой результат:
    select *
      from film
inner join film_actor on film.film_id = film_actor.film_id
     where film.film_id = 803;
-- Если в результате должны быть строки из исходной таблицы, для которых нет совпадений
-- в INNER JOIN таблице, то можно воспользоваться OUTER JOIN'ом.

-- Иногда при выполнении запросов необходимо следовать за несколькими полями в разных
-- таблицах пока мы не доберёмся полностью до нужных нам данных. Допустим мы хотим для каждого
-- пользователя из таблицы customer вывести город и страну, в которой он живёт.
-- Для этого нам придётся пройти по полю address_id в таблице customer до поля city_id в
-- таблице address. По полю city_id мы сможем пройти до таблицы city, в которой хранится
-- город в поле city и поле country_id, которое указывает на страну в таблице country.
-- Всё это можно сделать следующим запросом:
    select c.first_name || ' ' || c.last_name as "customer", city.city, ctry.country
      from customer as c
inner join address as addr on c.address_id = addr.address_id
inner join city on addr.city_id = city.city_id
inner join country as ctry on city.country_id = ctry.country_id;

-- Следующий запрос делает то же самое, что и верхний: если inner не указать, то
-- JOIN по-умолчанию считается INNER JOIN'ом.
select c.first_name || ' ' || c.last_name as "customer", city.city, ctry.country
  from customer as c
  join address as addr on c.address_id = addr.address_id
  join city on addr.city_id = city.city_id
  join country as ctry on city.country_id = ctry.country_id;

-- Если после on идёт операция сравнения на равенство двух одинаковых полей, то
-- можно использовать более короткий синтаксис using:
    select c.first_name || ' ' || c.last_name as "customer", city.city, ctry.country
      from customer as c
inner join address as addr using (address_id)
inner join city using (city_id)
inner join country as ctry using (country_id);

-- Старый синтаксис для выполнения INNER JOIN. Сейчас используется редко.
select *
  from rental, customer
 where rental.customer_id = customer.customer_id;
