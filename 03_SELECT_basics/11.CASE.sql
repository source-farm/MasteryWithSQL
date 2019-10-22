-- CASE похож на оператор if из других языков программирования.
select title, length,
    -- Общий (general) вид выражения CASE.
    -- CASE определяет новую колонку.
    case
        when length <= 60 then 'short'
        when length > 60 and length <= 120 then 'long'
        when length > 120 then 'very long'
        -- Сравнение с NULL должно происходить так:
        -- WHEN length IS NULL then 'empty'

        -- ELSE не является объязательным, но если он есть и ни одно
        -- из условий в WHEN не выполнилось, то возвращается значение в ELSE.
        -- Если ни одно условие в WHEN не выполнилось и ELSE нет, то
        -- возвращается NULL.
        else 'unknown'
    end as length_description -- псевдоним колонки.
from film;

select title, length, rating,
    -- Простой (simple) вид выражения CASE.
    -- В простом CASE не получится сравнить с NULL и вернуть что-то, нужно
    -- пользоваться общим видом CASE.
    case rating
        when 'G' then 'kid friendly'
        when 'PG' then 'kid friendly'
        else 'not kid friendly'
    end as kid_friendly_rating
from film;
