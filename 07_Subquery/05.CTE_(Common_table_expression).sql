-- Common table expressions (обобщённые табличные выражения) или CTE
-- позволяют вынести подзапрос наверх для более удочной организации
-- кода и улучшения читабельности.

-- Ранее мы уже рассматривали следующий запрос для нахождения фильмов,
-- которые должны быть арендованы не менее 30 раз, чтобы не уйти в минус:
select *
  from (select title, rental_rate, replacement_cost, ceil(replacement_cost / rental_rate) as break_even
          from film) as t
 where break_even > 30;
-- Благодаря CTE подзапрос можно вынести наружу:
with film_stats as
(
    select title, rental_rate, replacement_cost, ceil(replacement_cost / rental_rate) as break_even
      from film
)
-- После ключевого слова WITH идёт название новой таблицы, содержимое которой
-- определяется находящимся в ней запросом. Далее мы можем делать обычные запросы
-- к этой таблице:
select *
  from film_stats
 where break_even > 30;

-- Названия колонок в CTE можно переопределять:
with film_stats(t, rr, rc, be) as
(
    select title, rental_rate, replacement_cost, ceil(replacement_cost / rental_rate) as break_even
      from film
) -- Нельзя вставлять новую строку между круглой скобкой и select.
select *
  from film_stats
 where be > 30;

-- Одной из особенностей CTE является то, что позднее определённые CTE могут
-- ссылаться на ранее определённые.
-- Рассмотрим следующий запрос, который находит среднее количество аренд
-- фильмов для каждого дня недели:
  select to_char(rent_day, 'Day') as day_name,
         round(avg(num_rentals)) as average
    from (  select date_trunc('day', rental_date) as rent_day, count(*) as num_rentals
              from rental
          group by rent_day) as T
group by day_name
order by average desc;
-- Этот запрос можно разбить на два CTE:
with day_counts as
(
  select date_trunc('day', rental_date) as rent_day, count(*) as num_rentals
    from rental
group by rent_day
), -- Для второго и следующих CTE не нужно указывать WITH.
day_of_week_counts as
(
  select to_char(rent_day, 'Day') as day_name,
         round(avg(num_rentals)) as average
    from day_counts
group by day_name
)
select *
  from day_of_week_counts;
