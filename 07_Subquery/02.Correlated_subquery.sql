-- Кроме несвязанных (uncorrelated) есть ещё и связанные (correlated).
-- Выполнение связанного запроса зависит от внешнего запроса.

-- Пример нахождения для каждого сотрудника последней даты, когда
-- они арендовали фильм:
select c.customer_id, c.first_name, c.last_name,
       (select max(rental_date)
          from rental as r
         where r.customer_id = c.customer_id) as "most recent rental"
  from customer as c;
-- Этот запрос можно прочитать так: из таблицы customer берём значение
-- трёх полей customer_id, first_name, last_name первой строки. Далее
-- подставляем значение поля customer_id в подзапрос и результат его
-- выполнения добавляем в конец первой строки результирующей таблицы.
-- То же самое делаем для всех строк таблицы customer.
-- Подзапрос в данном запросе является связанным, т.к. в нём есть
-- ссылка на внешнюю таблицу, а именно псевдоним c таблицы customer
-- используется в выражении where. Именно наличие этого псевдонима и
-- делает подзапрос связанным.

-- Клиенты, которые в общем потратили меньше 100 долларов:
select c.customer_id, c.first_name, c.last_name
  from customer as c
 where (select sum(p.amount)
          from payment as p
         where p.customer_id = c.customer_id) < 100;

-- Люди, которые потратили что-либо в наших магазинах:
select c.customer_id, c.first_name, c.last_name
  from customer as c
 where exists (select * -- столбцы можно не указывать, т.к. идёт только проверка на наличие чего-либо.
                 from payment as p
                where p.customer_id = c.customer_id);
-- EXISTS проверяет есть в подзапросе хотя бы одна строка. Соответственно
-- NOT EXISTS делает проверку на пустоту. Т.е. чтобы найти людей, которые
-- вообще не тратили ничего можно выполнить следующий запрос:
select c.customer_id, c.first_name, c.last_name
  from customer as c
 where not exists (select *
                     from payment as p
                    where p.customer_id = c.customer_id);
-- Иногда в подзапросе вместо * используют 1, т.к. сами возвращаемые столбцы
-- никак не влияют на проверку exists (select 1 буквально возвращает 1 для
-- каждой строки):
select c.customer_id, c.first_name, c.last_name
  from customer as c
 where not exists (select 1
                     from payment as p
                    where p.customer_id = c.customer_id);

-- Нахождение для каждого клиента времени когда он арендовал фильм и предыдущей
-- даты аренды фильма:
select r1.rental_id, r1.customer_id, r1.rental_date,
       (select max(r2.rental_date)
          from rental as r2
         where r2.customer_id = r1.customer_id and r2.rental_date < r1.rental_date) as prev_rental_date
  from rental as r1
order by r1.customer_id, r1.rental_date;
