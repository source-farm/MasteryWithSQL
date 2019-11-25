-- Язык SQL можно разбить на несколько групп по функциональному признаку:
--
--     DDL (Data Definition Language): CREATE, ALTER, DROP
--     DML (Data Manipulation Language): INSERT, UPDATE, DELETE, SELECT
--     DCL (Data Control Language): GRANT, REVOKE
--     TCL (Transaction Control Language): BEGIN, COMMIT, ROLLBACK
--
-- Общая схема создания  таблицы выглядит так:
--
-- create table table_name (
--     col1_name col_type(field_length) col1_constraints,
--     col2_name col_type(field_length),
--     col3_name col_type(field_length),
--     ...
--     table constraints
-- );
-- Констрейнты могут быть указаны как сразу после определения столбца так
-- и в конце выражения create table.

-- Создание таблицы без каких-либо констрейнтов:
create table users (
    first_name varchar(100),
    second_name varchar(100),
    email varchar(100),
    dob date -- date of birth
);

-- Если какая-либо табица уже есть в БД, то при попытке её создания ещё
-- раз будет ошибка. Чтобы запрос выполнился без ошибок (необходимо,
-- например, для продолжения выполнения скрипта) можно создать таблицу
-- только если её нет в БД:
create table if not exists users (
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100),
    dob date -- date of birth
);

-- Добавление данных в таблицу:
insert into users (first_name, last_name, email, dob)
     values ('neil', 'sainsbury', 'neil@masterywithdata.com', '1984-10-04');

-- Добавление ещё одной колонки в таблицу:
alter table users
        add is_active boolean;

-- Удаление колонки из таблицы:
alter table users
       drop dob;

-- Удаление таблицы:
drop table users;

-- Схема (schema) - этот способ организации объектов БД (таблицы, индексы и т.д.)
-- в группы. По-умолчанию PostgreSQL создаёт группу public после установки. Если
-- таблиц не очень много, то можно пользоваться и ей, но при большом количестве
-- таблиц лучше их добавлять в определённую схему.
-- Создать схему можно так:
create schema playground;

-- Создание таблицы внутри схемы playground:
create table if not exists playground.users (
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100),
    dob date -- date of birth
);

-- Теперь перед каждым обращением к таблице users должно стоять название схемы
select * from playground.users;
-- select * from users; -- Не работает, т.к. таблица users находится в схеме playground.

-- Если не хочется каждый раз писать название схемы перед таблицей, то можно
-- обновить так называемый путь поиска (search path) PostgreSQL.

-- Удаление схемы playground вместе со всем её содержимым:
drop schema playground cascade;



