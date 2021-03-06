-- Констрейнт CHECK проверяет выполнение указанных условий при
-- выполнении операции вставки.
create table playground.users (
    -- Длина почтового ящика должна быть больше 3 и он должен содержать символ '@'.
    email      varchar(100) check (length(email) > 3 and position('@' in email) > 0),
    first_name varchar(100),
    last_name  varchar(100),
    -- is_active не может быть равно NULL, значение по-умолчанию true.
    -- Значение по-умолчанию используется, если поле is_active не было
    -- задано при добавлении записи.
    is_active  boolean not null default true,
    constraint pk_users primary key (email)
);

create table playground.note_tags (
    note_id bigint,
    -- Перечисление значений, которым может быть равно поле tag.
    tag     text check (tag in ('work', 'personal', 'todo')),
    primary key (note_id, tag),
    foreign key (note_id) references playground.notes (note_id)
);

create table playground.notes (
    note_id    bigint generated by default as identity primary key,
    note       text,
    -- Констрейнт UNIQUE гарантирует уникальность значений поля или
    -- комбинации полей:
    title      text unique,
    created_on timestamptz,
    updated_on timestamptz,
    user_email varchar(100) references playground.users (email),
    -- Констрейнт CHECK можно также создавать по нескольким полям:
    check (updated_on >= created_on)
);
