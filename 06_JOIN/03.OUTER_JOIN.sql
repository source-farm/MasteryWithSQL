-- Как мы уже говорили INNER JOIN можно представить как CROSS JOIN с
-- дополнительной фильтрацией строк. OUTER JOIN можно рассматривать как
-- дальнейшее развитие INNER JOIN с добавлением недостающих строк:
--
-- CROSS JOIN: декартово произведение
-- INNER JOIN: CROSS JOIN + фильтрация
-- OUTER JOIN: CROSS JOIN + фильтрация + недостающие строки
--
-- Существует три вида OUTER JOIN: LEFT, RIGHT и FULL. LEFT оставляет
-- строки из "левой" таблицы, RIGHT - из "правой", FULL - из левой и из правой.

-- Рассмотрим пример из урока по INNER JOIN. Как мы уже говорили следующий запрос
-- исключает из финального результата фильм с film_id 803, т.к. в таблице film_actor
-- нет поля с film_id 803:
    select *
      from film
inner join film_actor on film.film_id = film_actor.film_id
  order by film.film_id;
-- Для того чтобы фильм 803 оказался в финальном результате нужно воспользоваться
-- LEFT OUTER JOIN'ом - все строки из таблицы film останутся, но в результирующей
-- таблице поля из таблицы film_actor, для которых нет film_id из таблицы film
-- будут иметь значение NULL:
         select *
           from film
left outer join film_actor on film.film_id = film_actor.film_id
       order by film.film_id;
-- LEFT OUTER JOIN это то же самое, что и LEFT JOIN. Поэтому этот запрос можно
-- переписать так:
   select *
     from film
left join film_actor on film.film_id = film_actor.film_id
 order by film.film_id;

-- RIGHT JOIN'ы используются довольно редко, т.к. таблицы из выражений
-- from и right join можно поменять местами и выполнить LEFT JOIN и получится
-- то же самое. Следующий запрос делает то же самое, что и расположенный выше:
    select *
      from film_actor
right join film on film.film_id = film_actor.film_id
  order by film.film_id;

-- С помощью LEFT JOIN мы можем найти фильмы, для которых не указаны актёры:
   select film.film_id, film.title, film_actor.film_id
     from film
left join film_actor on film.film_id = film_actor.film_id
    where film_actor.film_id is null
 order by film.film_id;

-- Допустим мы хотим посчитать сколько актёров снималось в каждом фильме.
-- Рассмотрим следующий неправильный запрос:
   select film.film_id, film.title, count(*)
     from film
left join film_actor on film.film_id = film_actor.film_id
 group by film.film_id
 order by film.film_id;
-- Этот запрос для фильма film.film_id 803 показывает 1, т.е. что в нём снимался один
-- актёр, хотя в таблице film_actor нет никакой информации об актёрах этого
-- фильма. Это происходит потому что при группировании по film.film_id
-- фильм 803 создаёт группу из одной строки, а т.к. count(*) подсчитывает количество
-- строк в группе мы получаем 1. Но мы знаем, что в результате LEFT JOIN для фильмов,
-- которых нет в film_actor, мы получим значение NULL в поле film_actor.film_id (или
-- для любого поля таблицы film_actor). Поэтому можно использовать count с передачей
-- ему конкретного поля, т.к. в этом случае он считает количество не NULL значений:
   select film.film_id, film.title, count(film_actor.film_id)
     from film
left join film_actor on film.film_id = film_actor.film_id
 group by film.film_id
 order by film.film_id;

-- Допустим мы хотим вывести актёров, которые играют в каждом фильме, а не просто
-- их id (film_actor.actor_id). Информация об актёрах хранится в таблице actor.
-- Следующий запрос похоже делает то что нам нужно, но он не является абсолютно
-- правильным:
    select film.film_id, film.title, film_actor.actor_id, actor.first_name, actor.last_name
      from film
 left join film_actor on film.film_id = film_actor.film_id
inner join actor on film_actor.actor_id = actor.actor_id
  order by film.film_id;
-- Всё дело в том, что этот запрос пропускает фильм с film_id 803. Это происходит
-- потому что после LEFT JOIN'а мы получаем таблицу, где поле film_actor.actor_id (и
-- другие поля из таблицы film_actor) для фильма 803 равно NULL и при выполнении
-- INNER JOIN с таблицей actor эта строка исключается из результата.
-- Следующий запрос делает в точности то что нам нужно:
    select film.film_id, film.title, film_actor.actor_id, actor.first_name, actor.last_name
      from film
 left join (film_actor inner join actor on film_actor.actor_id = actor.actor_id) on film.film_id = film_actor.film_id
  order by film.film_id;
-- Здесь выражение в скобках можно считать ещё одной таблицей. Она формируется до
-- LEFT JOIN'а и добавляет к таблице film_actor имена актёров.

-- FULL JOIN используется довольно редко. Его можно считать объединением результатов
-- LEFT JOIN и RIGHT JOIN. Одним из практических его применений является нахождение
-- разницы двух таблиц. Например, мы можем захотеть узнать кто из клиентов появился
-- в 2012 году по сравнению с прошлым годом, а кто наоборот исчез.

-- В общем работу LEFT JOIN, RIGHT JOIN и FULL JOIN можно представить на следующем примере.
-- Допустим у нас есть две таблицы T1 и T2 с одним целочисленным полем:
--
--     T1    T2
--     --    --
--      1     1
--      2     2
--      3     4
--
-- Если выполнить INNER JOIN таблиц T1 и T2, то мы получим следующее:
--
--     T1 inner join T2
--     ----------------
--      T1.1  |  T2.1
--      T1.2  |  T2.2
--
-- Если выполнить LEFT JOIN таблиц T1 и T2, то мы получим следующее:
--
--     T1 left join T2
--     ----------------
--      T1.1  |  T2.1
--      T1.2  |  T2.2
--      T1.3  |  NULL
--
-- Если выполнить RIGHT JOIN таблиц T1 и T2, то мы получим следующее:
--
--     T1 left join T2
--     ----------------
--      T1.1  |  T2.1
--      T1.2  |  T2.2
--      NULL  |  T2.4
--
-- Если выполнить FULL JOIN таблиц T1 и T2, то мы получим следующее:
--
--     T1 left join T2
--     ----------------
--      T1.1  |  T2.1
--      T1.2  |  T2.2
--      T1.3  |  NULL
--      NULL  |  T2.4
