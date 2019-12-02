-- PostgreSQL позволяет писать свои функции. Из коробки поддерживаются
-- три языка: стандартный SQL, PL/pgSQL - специфичный для PostgreSQL
-- язык и язык программирования C.

-- Пример функции на стандартном SQL.
-- Эта функция возвращает p_n самых популярных фильмов по количеству
-- аренд для переданного рейтинга p_rating. Если рейтинг не передать,
-- то он будет считаться равным 'PG'.
create or replace function popular_films -- Название функции.
(
    -- Входные параметры (здесь p перед названием параметра означает parameter).
    p_n int,
    p_rating mpaa_rating default 'PG' -- Параметру p_rating задано значение по-умолчанию.
)
-- Функция возвращает таблицу.
returns table (title       varchar(255),
               description text,
               length      int2,
               rating      mpaa_rating)
-- Функция написана на стандартном SQL.
language sql
-- $$ называют ещё dollar quote. Вместо них можно было бы использовать просто '', но $$ более явно выделяют тело функции.
as $$
      select f.title,
             f.description,
             f.length,
             f.rating
        from rental as r inner join inventory as i using (inventory_id)
                         inner join film as f using (film_id)
       where f.rating = p_rating -- Обращение к переданному параметру. Можно было бы написать и $2 вместо p_rating - его позиция в списке параметров.
    group by f.film_id
    order by count(*) desc, f.title
       limit p_n;
$$;

-- Вызвать функцию можно так:
select * from popular_films(3, 'R');
select * from popular_films(3);

-- Вместо возврата таблицы при определении функции можно обозначить параметры как входные
-- или выходные. Следующая функция делает то же самое, что определённая выше:
create or replace function popular_films
(
    in p_n int,
    in p_rating mpaa_rating default 'PG',
    out title       varchar(255),
    out description text,
    out length      int2,
    out rating      mpaa_rating
)
returns setof record
language sql
as $$
      select f.title,
             f.description,
             f.length,
             f.rating
        from rental as r inner join inventory as i using (inventory_id)
                         inner join film as f using (film_id)
       where f.rating = p_rating
    group by f.film_id
    order by count(*) desc, f.title
       limit p_n
$$;

-- Функция, которая возвращает только одно значение:
create or replace function my_sum
(
    a int,
    b int
)
returns int -- Если функция возвращает только одно значение, то можно указать просто его тип.
-- Функции поддерживают большое количество дополнительных настроек. Например,
-- если функция не зависит от каких-либо внешних данных и только работает с
-- входными параметрами, то обозначение её как immutable может привести к включению
-- оптимизаций компилятора.
immutable
language sql
as $$
    select a + b;
$$;

select my_sum(1, 2);
