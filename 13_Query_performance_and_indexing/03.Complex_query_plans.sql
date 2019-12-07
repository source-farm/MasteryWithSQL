-- Рассмотрим план запроса для более сложного запроса.
-- Следующий запрос находит количество фильмов, в которых снялись
-- актёры с именем MARY:
explain analyze
select a.first_name,
       a.last_name,
       (select count(*)
         from film_actor as fa
        where fa.actor_id = a.actor_id)
  from actor as a
 where first_name = 'MARY';

-- Для этого запроса мы получим следующий план:
/*
QUERY PLAN                                                                                                                            |
--------------------------------------------------------------------------------------------------------------------------------------|
Seq Scan on actor a  (cost=0.00..75.59 rows=2 width=21) (actual time=0.054..0.095 rows=2 loops=1)                                     |
  Filter: ((first_name)::text = 'MARY'::text)                                                                                         |
  Rows Removed by Filter: 198                                                                                                         |
  SubPlan 1                                                                                                                           |
    ->  Aggregate  (cost=35.53..35.54 rows=1 width=8) (actual time=0.024..0.024 rows=1 loops=2)                                       |
          ->  Bitmap Heap Scan on film_actor fa  (cost=4.49..35.47 rows=27 width=0) (actual time=0.014..0.018 rows=36 loops=2)        |
                Recheck Cond: (actor_id = a.actor_id)                                                                                 |
                Heap Blocks: exact=2                                                                                                  |
                ->  Bitmap Index Scan on film_actor_pkey  (cost=0.00..4.48 rows=27 width=0) (actual time=0.009..0.009 rows=36 loops=2)|
                      Index Cond: (actor_id = a.actor_id)                                                                             |
Planning Time: 0.115 ms                                                                                                               |
Execution Time: 0.132 ms                                                                                                              |
*/

-- Этот план можно рассматривать как дерево вложенных друг в друга шагов: самый нижний шаг "Bitmap Index Scan on film_actor_pkey"
-- является дочерним узлом шага "Bitmap Heap Scan on film_actor fa", который в свою очередь является дочерним узлом шага "Aggregate"
-- и т.д.
-- Также здесь можно увидеть ещё один тип сканирования: Bitmap Scan (Heap и Index). Этот тип сканирования находится где-то между
-- Seq Scan и Index Scan по скорости выполнения. Index Scan обращается по индексу к конкретному месту на диске для извлечения строки.
-- Если таких обращений очень много, то запрос будет выполняться медленно. Bitmap Scan может сначала получить все местоположения
-- строк на диске через индекс, а после выполнить более эффективное вычитывание этих строк с диска, используя наименьшее количество
-- обращений к диску, что должно ускорить выполнение запроса. В общем случае считается, что Index Scan эффективен, когда необходимо
-- получить небольшое количество строк, Bitmap Scan - когда не очень много строк и Seq Scan - когда нужно вычитать много строк.

-- Рассмотрим различные виды шагов, которые могут встретиться при выполнении JOIN'ов на основе следующего примера:
explain analyze
    select rental.rental_id,
           customer.first_name
      from rental
inner join customer using (customer_id);

-- Для этого запроса мы получим следующий план:
/*
QUERY PLAN                                                                                                        |
------------------------------------------------------------------------------------------------------------------|
Hash Join  (cost=30.48..383.33 rows=16044 width=10) (actual time=0.147..3.676 rows=16044 loops=1)                 |
  Hash Cond: (rental.customer_id = customer.customer_id)                                                          |
  ->  Seq Scan on rental  (cost=0.00..310.44 rows=16044 width=6) (actual time=0.005..1.049 rows=16044 loops=1)    |
  ->  Hash  (cost=22.99..22.99 rows=599 width=10) (actual time=0.137..0.137 rows=599 loops=1)                     |
        Buckets: 1024  Batches: 1  Memory Usage: 34kB                                                             |
        ->  Seq Scan on customer  (cost=0.00..22.99 rows=599 width=10) (actual time=0.003..0.075 rows=599 loops=1)|
Planning Time: 0.123 ms                                                                                           |
Execution Time: 4.105 ms                                                                                          |
*/

-- При выполнении JOIN'ов в основном можно встретить три вида шагов в плане запроса, которые в основном зависят от
-- размера таблиц:
--
--     - Nested Loop
--     - Merge Join
--     - Hash Join
--
-- Nested Loop для каждой строки одной таблицы сканирует другую в поиске совпадения с учётом указанного условия.
-- Работает очень быстро на маленьких таблицах.
-- Merge Join сортирует обе таблицы, а затем уже выполняет Join. Работает быстро на таблицах средних размеров.
-- Hash Join строит для одной таблицы хэш-таблицу и для каждой строки ищет совпадение в первой, используя полученную
-- хэш-таблицу. Иногда можно такое, что для больших таблиц PostgreSQL не использует Hash Join. Это может быть
-- связано с тем, что хэш-таблица может быть слишком большой, чтобы уместиться в настройку work_mem. Поэтому
-- для ускорения запроса можно увеличить work_mem (хотя бы на время выполнения запроса).

-- Иногда бывает удобно рассматривать план запроса в графическом виде. pgAdmin позволяет это сделать.
