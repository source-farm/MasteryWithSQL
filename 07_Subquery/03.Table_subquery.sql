-- Подзапросы могут также возвращать целые таблицы, а не только одно значение
-- или один столбец.
-- Допустим мы хотим найти сколько раз в среднем каждый человек арендовал
-- у нас фильмы. Эту задачу можно разбить на две подзадачи: сначала находим
-- для каждого человека сколько всего он делал аренд. Затем находим среднее
-- значение для количества аренд каждого человека.
select avg(rentals_num) as average_rentals_per_customer
  from (  select customer_id, count(*) as rentals_num
            from rental
        group by customer_id) as t; -- Подзапрос-таблица должна иметь название.
-- В этом запросе подзапрос находит для каждого клиента количество аренд, которые
-- он всего совершил, а внешний запрос среднее значение количества аренд всех
-- клиентов.

-- Название возвращаемых колонок можно также указывать и рядом с названием
-- таблица подзапроса. Также во внешнем запросе можно указывать название
-- таблицы из подзапроса:
select avg(t.rentals_num) as average_rentals_per_customer
  from (  select customer_id, count(*)
            from rental
        group by customer_id) as t(customer, rentals_num);

-- Нахождение фильмов, которые должны быть арендованы не менее 30 раз, чтобы
-- не уйти в минус:
select *
  from (select title, rental_rate, replacement_cost, ceil(replacement_cost / rental_rate) as break_even
          from film) as t
 where break_even > 30;

-- Подзапросы, которые возвращают таблицы, могут быть также удобны при генерации
-- собственных таблиц.
      select f.film_id, f.title, f.length, c.desc
        -- С помощью values можно вручную создавать таблицы.
        from (values ('short', 0, 60),
                     ('medium', 60, 120),
                     ('long', 120, 10000)) as c("desc", "min", "max") -- c - это название таблицы, "desc", "min", "max" - названия столбцов.
  inner join film as f on f.length >= c.min and f.length < c.max;
