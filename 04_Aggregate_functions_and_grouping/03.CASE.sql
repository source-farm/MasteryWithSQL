-- Группы можно создавать на основе выражения CASE.
-- Здесь создаются 4 группы фильмов: короткие, средние, длинные и те,
-- для которых поле length равно NULL.
-- Выражение, которое находится в GROUP BY, должно целиком совпадать с
-- выражением в SELECT, т.е. там должны быть одинаковые CASE'ы.
  select
        case
            when length < 60 then 'short'
            when length between 60 and 120 then 'medium'
            when length > 120 then 'long'
        end,
        count(*)
    from film
group by
        case
            when length < 60 then 'short'
            when length between 60 and 120 then 'medium'
            when length > 120 then 'long'
            -- Если нет else, то возвращается NULL, т.е. будет создана группа,
            -- у которых поле length равно NULL.
        end;

-- То же самое, что и предыдущий запрос, но NULL-length фильмы добавлены к коротким.
  select
        case
            when length < 60 then 'short'
            when length between 60 and 120 then 'medium'
            when length > 120 then 'long'
            else 'short'
        end,
        count(*)
    from film
group by
        case
            when length < 60 then 'short'
            when length between 60 and 120 then 'medium'
            when length > 120 then 'long'
            else 'short'
        end;

-- То же самое, что и предыдущий запрос, но выражение в GROUP BY копируется из SELECT.
  select
        case
            when length < 60 then 'short'
            when length between 60 and 120 then 'medium'
            when length > 120 then 'long'
            else 'short'
        end,
        count(*)
    from film
group by 1; -- 1 означает скопировать первый элемент из SELECT, т.е. выражение CASE.

-- CASE можно использовать внутри функций.
-- Подсчёт количества фильмов с рейтингом R или NC-17.
select
    sum (case when rating in ('R', 'NC-17') then 1 else 0 end) as num_adult_films,
    count(*) as num_total_films
from film;

-- Предыдущий запрос + процент фильмов с рейтингом R или NC-17.
select
    sum(case when rating in ('R', 'NC-17') then 1 else 0 end) as num_adult_films,
    count(*) as num_total_films,
    100.0 * sum(case when rating in ('R', 'NC-17') then 1 else 0 end)/count(*) as pct
from film;

-- Предыдущий запрос с count вместо sum. Этот запрос работает, т.к. count при передаче
-- ему выражений игнорирует NULL.
select
    count(case when rating in ('R', 'NC-17') then 1 else null end) as num_adult_films,
    count(*) as num_total_films,
    100.0 * sum(case when rating in ('R', 'NC-17') then 1 else null end)/count(*) as pct
from film;

-- Предыдущий запрос, но без явного указания ELSE, т.к. CASE сам возвращает NULL, если
-- не выполнилось ни одно из его условий.
select
    count(case when rating in ('R', 'NC-17') then 1 end) as num_adult_films,
    count(*) as num_total_films,
    100.0 * sum(case when rating in ('R', 'NC-17') then 1 end)/count(*) as pct
from film;

-- PostgreSQL-specific способ подсчёта на уснове различных условий.
-- Первое выражение в SELECT делает то же самое, что и первое выражение в SELECT
-- в предыдущем запросе.
select
    count(*) filter(where rating in ('R', 'NC-17')) as adult_films,
    count(*) filter(where rating = 'G' and length > 120) as mixed
from film;
