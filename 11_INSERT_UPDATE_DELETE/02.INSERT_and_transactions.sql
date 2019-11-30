-- Транзакция позволяет вносить атомарные изменения в БД. Общий вид
-- транзакции в PostgreSQL имеет следующий вид:
begin;
-- Здесь могут находиться какие-либо операции с БД.
commit;   -- Фиксирует изменения в БД.
rollback; -- Отменяет изменения, т.е. возвращаемся к состоянию, которое было до выражения begin;
-- Если после begin; произойдёт какая-либо ошибка, то транзакция будет
-- находиться в состоянии aborted и дальнейшие запросы не будут выполняться.
-- Чтобы выйти из этого состояния нужно выполнить запрос rollback;

-- Пример вставки строк в таблицу:
insert into actor(first_name, last_name)
     values ('Keanu', 'Reeves'),
            ('Tom', 'Cruise'),
            ('Winona', 'Rider');

-- Выражения INSERT, UPDATE и DELETE позволяют получить строки, на которые
-- они оказали влияние с помощью выражения RETURNING. Например,
-- следующий запрос возвращает все поля для трёх строк, которые мы
-- вставили в таблицу:
insert into actor(first_name, last_name)
     values ('Keanu', 'Reeves'),
            ('Tom', 'Cruise'),
            ('Winona', 'Rider')
  returning *;
-- Можно также возвращать определённые поля или выражение:
insert into actor(first_name, last_name)
     values ('Keanu', 'Reeves'),
            ('Tom', 'Cruise'),
            ('Winona', 'Rider')
  returning first_name || ' ' || last_name;

-- Вместо ручного перечисления всех значений, которые нужно вставить в таблицу,
-- можно вставить результат SELECT'а:
insert into actor (first_name, last_name)
    select first_name, last_name
      from customer
     where active = 0
returning *;
