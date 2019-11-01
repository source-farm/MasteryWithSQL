-- При работе с агрегатными функциями, если в запросе не используется выражение
-- GROUP BY, то мы неявно работаем с одной группой из всех строк таблицы. GROUP BY
-- позволяет разбить строки на группы и выполнить агрегатные функции над этими
-- группами. С помощью HAVING можно фильтровать группы.

-- Сколько фильмов принадлежат определённому рейтингу.
-- Когда в запросе есть GROUP BY, то схема его работы меняется: вместо обработки
-- всех строк таблицы идёт отдельная обработка каждой группы. Т.е. если обычно
-- SELECT работает со всеми строками, то при наличии GROUP BY все выражения,
-- которые по порядку выполнения идут после ORDER BY (HAVING,  SELECT, ORDER BY,
-- LIMIT) выполняются над группами и каждая группа должна схлопнуться в одну
-- строку.  В нашем случае группы формируются на основе поля rating - все строки с
-- одинаковым значением поля rating собираются в отдельные группы и count(*)
-- применяется к этим группам.  Т.е.  все строки с рейтингом 'G' должны быть
-- сведены к одной строки, что и делает count(*) и также для всех остальных
-- рейтингов, включая NULL.
  select rating, count(*)
    from film
group by rating;

-- Общая продолжнительность всех фильмов определённого рейтинга.
  select rating, sum(length)
    from film
group by rating;

-- Показ всех возможных рейтингов.
-- После применения GROUP BY все строки с одинаковым рейтингом объединяются в
-- группы и SELECT применяется к этим группам. SELECT должен схлопнуть каждую
-- группу в одну строку, но т.к. группы были созданы по полю rating, то
-- получается, что у каждой группы одинаковое значение поля rating и SELECT просто
-- берёт значение этого поля.
  select rating
    from film
group by rating;

-- Следующий запрос в отличие от предыдущего не работает. Все фильмы с определённым
-- рейтингом должны быть схлопнуты в одну строку, но select не знает какой title
-- нужно взять для каждой группы. Мы не указали как нужно привести значения поля
-- title к одному значению. Как раз это и делают агрегатные функции наподобие count.
-- Элементы, которые не участвуют в выражении GROUP BY, могут появится в SELECT
-- только внутри агрегатных функций.
  select rating, title
    from film
group by rating;

-- Сколько взаимодействий было у каждого клиента с каждым работником.
  select customer_id, staff_id, count(*)
    from payment
group by customer_id, staff_id
order by customer_id, staff_id;

-- Сколько взаимодействий было у каждого клиента с каждым работником.
-- Убираем взаимодействия, которые произошли не более 20 раз.
  select customer_id, staff_id, count(*)
    from payment
group by customer_id, staff_id
-- HAVING уже работает с группами, а не отдельными строками.
  having count(*) > 20
order by customer_id, staff_id;

-- Подсчёт количества людей, у которых имя начинается на A, B, C и т.д.
  select left(first_name, 1) as first_letter, count(*)
    from customer
group by left(first_name, 1)
order by first_letter;
