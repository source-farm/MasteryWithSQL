-- Оконные функции lag и lead позволяют обращаться к предыдущим и следующим
-- строкам при упорядочивании строк в определённом порядке. Эти две функции не
-- работают с оконным фреймом.

-- Вывод рядом с датой текущей аренды даты предыдущей аренды:
select rental_id,
       customer_id,
       rental_date,
       -- То что делает функция lag можно описать следующим образом: строится
       -- виртуальная таблица, которая состоит из строк с тем же customer_id, что и у
       -- текущей строки и эта таблица упорядочивается по возрастанию rental_date.
       -- Далее вызов lag(rental_date) находит в этой таблице строку с таким же
       -- rental_date как у текущей строки, отходит на одну строку назад и выводит
       -- дату, которая находится в этом месте.
       lag(rental_date) over (partition by customer_id order by rental_date)
  from rental;

-- По-умолчанию lag отходит на одну строку назад и возвращает NULL, если
-- строки нет. Но эти значения можно указывать и самому.
select rental_id,
       customer_id,
       rental_date,
       -- В предыдущем запроса первая строка партиции содержала NULL,
       -- т.к. у первой строки партиции нет предыдущей строки. Здесь мы
       -- отходим на две строки назад и NULL заменяем на UNIX эпоху.
       lag(rental_date, 2, '1970-01-01'::timestamp) over (partition by customer_id order by rental_date)
  from rental;

-- lead позволяет получить следующую строку:
select rental_id,
       customer_id,
       rental_date,
       lead(rental_date) over (partition by customer_id order by rental_date)
  from rental;
