-- Оконные функции позволяют произвести некие вычисления для некоторой группы строк
-- таблицы (окно), которые каким-то образом связаны с текущей строкой.
-- В некотором смысле они похожи на связанные подзапросы (correlated subqueries).
-- От агрегатных функций они отличаются тем, что не схлопывают группу в одну строку;
-- каждая строка сохраняет свою идентичность.

-- Примеры использования оконных функций.
select title,
       length,
       -- row_number() является оконной функцией. После любой оконной функции объязательно
       -- идёт ключевое слово OVER и далее в скобках можно указать окно (т.е. множество строк),
       -- к которому применяется функция. В нашем случае функция применяется ко всем строкам
       -- таблицы, упорядоченным по возрастанию продолжительности, т.к. у нас нет каких-либо выражений
       -- where или group by и т.д. row_number присваивает номер каждой строке. Номера начинаются с 1.
       row_number() over (order by length),
       -- rank() работает следующим образом: группы строк с одинаковым значением полей из ORDER BY
       -- (в нашем случае только одно поле length) считаются равноправными (то что в документации
       -- называют peers) и всем им присваивается один и тот же ранг - целое число, которое начинается на 1.
       -- Первая такая группа строк получает ранг 1, вторая - количество строк в первой группе + 1,
       -- третья - количество строк в первый двух группах + 1 и т.д.
       rank() over (order by length),
       -- dense_rank() похож на rank(), но присвает ранг по количеству предыдущих групп + 1.
       dense_rank() over (order by length)
  from film;

-- Использование ключевого слова PARTITION.
select title,
       length,
       rating,
       -- PARTITION BY позволяет делить окно, над которым работает оконная функция,
       -- на более мелкие окна. Далее оконная функция работает отдельно с каждым подокном.
       -- Когда ключевого слова PARTITION не было row_number() присвоил номер,
       -- начиная с 1, каждой строке таблицы. Т.е. окном у нас была вся таблица.
       -- Теперь же выражение partition by rating делит основное окно, т.е. все
       -- строки таблицы, на более мелкие подокна, которые формируются на основе поля
       -- rating. Т.е. все строки с одинаковым значением поля rating будут объединены
       -- в одно подокно и row_number будет применена к этому подокну. В итоге получается,
       -- что у фильмов с рейтингом 'G' будет своя нумерация, начинающаяся на 1, у фильмов
       -- с рейтингом 'PG' своя, которая тоже начинается на 1 и т.д. То же самое
       -- относится и к функциям rank() и dense_rank().
       row_number() over (partition by rating order by length),
       rank() over (partition by rating order by length),
       dense_rank() over (partition by rating order by length)
  from film;

-- Нахождение самых коротких трёх фильмов, включая "ничьи":
select *
  from (select title,
               length,
               row_number() over (order by length),
               rank() over (order by length),
               dense_rank() over (order by length)
          from film) as t
 where rank <= 3;
