-- Изменение данных в таблице проводится с помощью выражения UPDATE.
-- В самом простом виде UPDATE меняет состояние каждой строки указанной колонки:
update customer
   set activebool = true;

-- Обновление значения поля activebool для всех строк.
-- Для UPDATE выражение RETURNING возвращает все строки, которые изменились
-- в результате выполнения этого UDPATE'а.
   update customer
      set activebool = true
returning *;

-- Обновление данных определённого пользователя:
update customer
   set activebool = true
 where customer_id = 42;

-- Обновление значений нескольких полей:
update customer
   set first_name = initcap(first_name),
       last_name = initcap(last_name),
       email = lower(email)
 where customer_id = 42;

-- Следующий запрос делает то же самое, что и верхний, но использует немного
-- другой синтаксис:
update customer
   set (first_name, last_name, email) =
       (initcap(first_name), initcap(last_name), lower(email))
 where customer_id = 42;

-- Можно обновлять поле значением из другой таблицы:
update payment
   set payment_date = (select rental_date
                         from rental
                        where rental.rental_id = payment.rental_id);

-- Установка поля activebool таблицы customer равным true, если
-- пользователь делал покупку не раньше 2006-01-01:
update customer
   set activebool = true
 where exists (select *
                 from rental
                where rental_date >= '2006-01-01' and
                      rental.customer_id = customer.customer_id);
