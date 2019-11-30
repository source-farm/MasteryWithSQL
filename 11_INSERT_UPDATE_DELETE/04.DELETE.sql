-- Данные из таблиц удаляются с помощью выражения DELETE.

-- Удаление всех строк из таблицы:
delete from payment;

-- Удаление определённой строки. RETURNING для DELETE возвращает
-- удалённые строки:
delete from payment
      where payment_id = 17000
  returning *;

-- Удаление всех записей из таблицы payment для клиентов с именем 'JOHN':
 delete from payment
where exists (select *
                from customer
               where first_name = 'JOHN' and
                     customer.customer_id = payment.customer_id);

-- Если таблица очень большая и нам нужно удалить из неё все данные, то
-- можно воспользоваться выражением TRUNCATE, т.к. он работает быстрее DELETE'а:
truncate table payment;