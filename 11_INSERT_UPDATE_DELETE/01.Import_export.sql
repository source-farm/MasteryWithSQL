-- PostgreSQL позволяет импортировать и экспортировать данные с помощью
-- выражения COPY. COPY не является SQL стандартом.

-- Пример импорта данных:
copy playground.users           -- В какую таблицу нужно импортировать данные.
from '/tmp/ch11-users.csv'      -- Расположение файла с данными.
with (format csv, header true); -- Наш файл имеет формат csv и первая строка содержит названия
                                -- колонок из таблицы playground.users.

-- В файле ch11-notes.csv в заголовке указаны только колонки title, note
-- и user_email, но в таблице playground.notes их 6. Колонки таблицы playground.notes,
-- которых нет в импортируемом файле либо имеют значение по-умолчанию (create_ts, edit_ts)
-- либо генерится автоматически (note_id). Поэтому при импортировании мы можем указать
-- что заполнятся из файла ch11-notes.csv должны только колонки title, note и user_email:
copy playground.notes (title, note, user_email)
from '/tmp/ch11-notes.csv'
with (format csv, header true);

-- Экспорт таблицы в файл:
copy playground.users
to '/tmp/ch11-users-out.csv'
with (format csv, header true);

-- Экспортировать можно и SELECT запросы:
copy (
    select first_name || ' ' || last_name as "full name"
      from playground.users
     where is_active = true
)
to '/tmp/ch11-active-users.csv'
with (format csv, header true);

-- При использовании выражения COPY следует знать, что это выражение будет
-- исполняться каким-либо сервером PostgreSQL, т.е. этот сервер должен иметь
-- доступ к файлам, которые мы указываем в выражении. Если мы хотим импортировать
-- локальный файл на удалённую машину, то нужно пользоваться командой copy
-- утилиты psql.
