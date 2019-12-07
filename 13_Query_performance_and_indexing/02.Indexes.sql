-- Объект БД, который называется индекс, очень сильно влияет на производительность
-- выполнения запроса. Мы можем создать индекс для одного или нескольких полей
-- таблицы. В результате создаются оптимизированные для поиска копии данных из
-- этого поля (полей). Эти данные хранятся на диске и называются индексом. При
-- обращении к полю таблицы, для которой создан индекс, сначала происходит обращение
-- к индексу для нахождения положения значений которые нам нужны и далее обращение
-- к самим данным. Без индекса всё что можно делать - это полностью сканировать
-- таблицу. Также по мере изменения данных в таблице (INSERT, UPDATE, DELETE)
-- необходимо также обновлять и индекс, чтобы он оставался актуальным.
-- В PostgreSQL можно создавать индексы для таблиц и материализованных представлений.
-- Существуют различные виды индексов, каждый ориентирован для различных типов
-- данных и запросов. Одним из них является B-tree - индекс на основе деревьев поиска.
-- Это индекс, который создаётся по-умолчанию для основного ключа таблицы и UNIQUE полей.

-- Сначала рассмотрим пример выполнения запроса на больших данных без использования индекса.

create schema test;

create table test.messages (
    id int,
    account_id int,
    msg text
);

-- Заполнение тестовой таблицы миллионом строк.
insert into test.messages (id, account_id, msg)
    select id,
           random() * 10000,
           substring('how are you there?', (random() * 20)::int, 5)
      from generate_series(1, 1000000) as s(id);

-- Как мы уже говорили в прошлом уроке EXPLAIN использует статистику о какой-либо таблице для
-- оценки времени выполнения запроса. После больших изменений в таблице как в нашем случае,
-- нужно запускать следующую команду, что статистика обновилась:
vacuum analyze test.messages;
  
-- На данный момент для таблицы test.messages не создано ни одного индекса.
-- Рассмотрим, что выдаст нам EXPLAIN для какого-нибудь простого запроса:
explain analyze
select id, msg
  from test.messages
 where id = 33;

/*
QUERY PLAN                                                                                                           |
---------------------------------------------------------------------------------------------------------------------|
Gather  (cost=1000.00..11614.43 rows=1 width=9) (actual time=0.264..34.805 rows=1 loops=1)                           |
  Workers Planned: 2                                                                                                 |
  Workers Launched: 2                                                                                                |
  ->  Parallel Seq Scan on messages  (cost=0.00..10614.33 rows=1 width=9) (actual time=18.965..29.526 rows=0 loops=3)|
        Filter: (id = 33)                                                                                            |
        Rows Removed by Filter: 333333                                                                               |
Planning Time: 0.048 ms                                                                                              |
Execution Time: 34.818 ms                                                                                            |
*/ 

-- Здесь мы можем видеть, что выполнение этого запроса шло в несколько потоков - "Parallel Seq Scan on messages",
-- а само количество потоков равно двум - "Workers Launched: 2". Но по своей сути это полный скан - каждая
-- строка таблицы должна быть вычитана из диска и рассмотрена для сравнения id с 33.

-- Создать индекс для колонки id можно так:
create index on test.messages(id);
-- Т.к. мы не определили тип индекса, то будет создан B-tree индекс.
 
-- Теперь если запустить тот же запрос SELECT, который мы запускали до создания, то мы получим следующий план:
/*
QUERY PLAN                                                                                                              |
------------------------------------------------------------------------------------------------------------------------|
Index Scan using messages_id_idx on messages  (cost=0.42..8.44 rows=1 width=9) (actual time=0.037..0.038 rows=1 loops=1)|
  Index Cond: (id = 33)                                                                                                 |
Planning Time: 0.657 ms                                                                                                 |
Execution Time: 0.053 ms                                                                                                |
*/
-- Время выполнения упало с 34.818 мс до 0.053 мс. Также видно, что вместо полного сканирования теперь выполняется
-- "Index Scan" - сначала в индексе ищется точное положение на диске строки с id 33 и после она извлекается из этого места,
-- т.е. происходит точечное обращение, а не полное сканирование таблицы с диска. 
 
-- Удалить индекс можно так:
drop index test.messages_id_idx;

-- Выполнение этого запроса можно ускорить ещё следующим образом.
-- Создадим индекс по двум полям. Такие индексы назвают композитными.
create index on test.messages(id, msg);

-- EXPLAIN для того же запроса SELECT теперь показывает следующее:
/*
QUERY PLAN                                                                                                                       |
---------------------------------------------------------------------------------------------------------------------------------|
Index Only Scan using messages_id_msg_idx on messages  (cost=0.42..4.44 rows=1 width=9) (actual time=0.026..0.027 rows=1 loops=1)|
  Index Cond: (id = 33)                                                                                                          |
  Heap Fetches: 0                                                                                                                |
Planning Time: 0.109 ms                                                                                                          |
Execution Time: 0.036 ms                                                                                                         |
*/
-- Время выполнения упало с 0.053 мс до 0.036 мс. Также можно видеть, что тип сканирования немного изменился, а именно
-- используется "Index Only Scan". Этот тип сканирования означает, что для получения результата запроса достаточно одного индекса
-- и не нужно дополнительно обращаться к таблице test.messages.





 