-- Подзапрос - это запрос, который находится внутри другого запроса.
-- Одним из видов такого подзапроса является скалярный запрос, когда
-- возвращается только одно значения. Его можно использовать в выражениях.
-- Следующий запрос находит фильмы, у которых продолжительность больше
-- средней продолжительности всех фильмов:
select title, length
  from film
 where length > (select avg(length) from film);
-- В этом запросе сначала вычисляется подзапрос для нахождения средней
-- продолжительности всех фильмов, затем это число подставляется в
-- основной запрос и дальше происходит его выполнение. Выполнение
-- основного запроса никак не связано с выполнением подзапроса после
-- того как подзапрос был выполнен. Такой вид подзапроса ещё называют
-- uncorrelated subquery. Подзапросы всегда необходимо заключать в
-- круглые скобки.

-- Подзапросы можно использовать в любом месте, где нужно одно значение,
-- в том числе и в выражении SELECT. Следующий запрос находит количество
-- денег, которые потратил клиент, но также и процент его трат от общей
-- прибыли компании за всё время:
  select customer_id, sum(amount), 100.0 * sum(amount) / (select sum(amount) from payment) as pct
    from payment
group by customer_id
order by pct desc;

-- Подзапросы могут возвращать и одну колонку. Для таких колонок
-- можно, например, проводить проверку на вхождение. В следующем
-- запросе подзапрос возвращает одну колонку из значений 'PG' и 'PG-13':
select title, rating
  from film
 where rating in (select distinct rating from film where left(rating::text, 2) = 'PG');

-- Нахождение актёров, которые не снимались в фильмах с рейтингом 'R'.
-- Подзапрос находит актёров, которые снимались в фильмах с рейтингом 'R'.
select *
  from actor
 where actor_id not in
       (select actor_id
          from actor inner join film_actor using (actor_id)
                     inner join film using (film_id)
         where rating = 'R');
