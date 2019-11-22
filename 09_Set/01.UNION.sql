-- Объединение трёх таблиц в одну с удалением дублирующихся строк.
-- При объединении каждая подтаблица должна иметь одинаковое
-- количество строк и типы соответствующих строк должны быть сравнимыми.
-- Названия строк не объязательно должны быть одинаковыми. В результирующую
-- таблицу берутся названия из первой подтаблицы.
select first_name, last_name
  from customer
union
select first_name, last_name
  from staff
union
select first_name, last_name
  from actor;

-- Объединение трёх таблиц в одну. Дубликаты остаются, т.е. получается
-- что количество строк в объединении будет равно сумме количества строк
-- в каждой подтаблице.
select first_name, last_name
  from customer
union all
select first_name, last_name
  from staff
union all
select first_name, last_name
  from actor;

-- Для удобства чтения SELECT'ы можно заключать в скобки:
(
    select first_name, last_name
      from customer
)
union
(
    select first_name, last_name
      from staff
);

-- Можно также упорядочить объединение:
(
    select first_name, last_name
      from customer
)
union
(
    select first_name, last_name
      from staff
)
order by first_name;
