-- Основной ключ позволяет уникальным образом идентифицирвать каждую
-- строку таблицы. Он может охватывать как одну колонку так и несколько.
-- Естественный (natural) основной ключ - это ключ по колонке(ам) таблицы
-- без ввода каких-либо дополнительных колонок. Суррогатный ключ - это
-- специальная колонка таблицы, которая вводится для обеспечения уникальной
-- идентификации каждой строки. Предпочтительным является использование
-- естественных ключей, но это не всегда возможно.
-- Основной ключ гарантирует уникальность и неравенство NULL колонок,
-- которые входят в него.

create schema playground;

-- Самый простой способ создания основного ключа - это добавление "primary key"
-- в конце определения колонки:
create table playground.users (
    email      varchar(100) primary key,
    first_name varchar(100),
    last_name  varchar(100),
    is_active  boolean
);

-- Создание основного ключа с заданием ему имени (если имя не указано, то
-- PostgreSQL формирует его сам):
create table playground.users (
    email      varchar(100) constraint pk_users primary key,
    first_name varchar(100),
    last_name  varchar(100),
    is_active  boolean
);

-- Создание основного ключа как констрейнта таблицы (table constraint):
create table playground.users (
    email      varchar(100),
    first_name varchar(100),
    last_name  varchar(100),
    is_active  boolean,
    -- Без задания имени (PostgreSQL задаёт его сам):
    -- primary key (email)
    -- С явным заданием имени:
    constraint pk_users primary key (email)
);

-- Поле типа serial автоматически увеличивается при вставке очередной строки.
-- Первое значение равно 1.
create table playground.notes (
    note_id    serial,
    note       text,
    user_email varchar(100)
);

-- В PostgreSQL есть тип UUID для определения глобально уникального ключа для таблицы.
-- Такой ключ бывает удобен при переносе данных в глобально распределённых базах
-- данных.

-- Использование типа SERIAL вместе с PRIMARY KEY является старым способом
-- создания суррогатного ключа для таблицы. Новый способ, который соответствует
-- SQL стандарту и появился в PostgreSQL 10, приведён ниже:
create table playground.notes (
    note_id    bigint generated by default as identity primary key,
    note       text,
    user_email varchar(100)
);

-- Пример создания композитного ключа (composete key) - ключ, который состоит
-- из нескольких полей:
create table playground.note_tags (
    note_id bigint,
    tag     text,
    primary key (note_id, tag)
);