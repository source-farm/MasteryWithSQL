-- Агрегатные функции возвращают одно значение для набора строк.
-- Самые часто используемые агрегатные функции:
--    count, sum, min, max, avg

-- Подсчёт количества строк в таблице film.
-- * - это wildcard, означает посчитать количество всех строк.
select count(*)
  from film;

-- count может принимать на вход и выражение. Если передать столбец,
-- то count посчитает количество не NULL строк в этом столбце.
select count(length)
  from film;

-- Подсчёт количества уникальных значений (без учёта NULL) столбца rating.
select count(distinct rating)
  from film;

-- Подсчёт количества строк в таблице film.
select count(1) -- То же самое, что и count(*).
  from film;

-- Продолжительность всех фильмов.
select sum(length)
  from film;

-- Мин., макс. и средняя плата за фильм.
select min(amount), max(amount), avg(amount)
  from payment;
