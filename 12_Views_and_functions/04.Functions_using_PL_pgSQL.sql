-- PostgreSQL позволяет также писать функции на специфичном для него языке PL/pgSQL.
-- Предпочтительным является использование стандартного SQL, но если его функционала
-- мало, то можно воспользоваться и PL/pgSQL, который содержит стандартные операторы
-- любого языка программирования как ветвление, циклы и т.д.

-- Пример очень простой функции на  языке PL/pgSQL, которая увеличивает число на 1:
create or replace function foo
(
)
returns int
language plpgsql
as $$
    -- После declare можно объявить переменные и константы, которые использует функция.
    declare
    -- Создаём целочисленную переменную с начальным значением 1.
        n int := 1;

    -- Тело функции должно находиться между begin и end.
    begin
        return n + 1;
    end
$$;

-- Вызов функции.
select foo();

-- Функция для нахождения площади круга.
create or replace function circle_area(r int)
returns numeric
language plpgsql
as $$
    declare
    -- Объявление константы.
        PI constant numeric := 3.14159;

    begin
        return PI * r * r;
    end
$$;

-- Оператор if:
create or replace function circle_area_desc(r int)
returns text
language plpgsql
as $$
    declare
        PI constant numeric := 3.14159;
        circle_area numeric;

    begin
        circle_area := PI * r * r;
        if circle_area < 20 then
            return 'small circle';
        else
            return 'big circle';
        end if;
    end
$$;

-- Цикл for:
create or replace function sum_to_n(n int)
returns int
language plpgsql
as $$
    declare
        total int := 0;

    begin
        for i in 1..n loop
            total := total + i;
        end loop;

        return total;
    end
$$;

-- Удалить функцию можно так:
drop function sum_to_n;
-- Если поменять параметры функции и попытаться пересоздать её,
-- то create or replace в начале объявления функции не сработают так же
-- как и в случае, если поменять что-либо в заголовке, а не в теле функции.
-- В таком случае необходимо сначала удалить функцию с помощью drop,
-- а затем пересоздать её.

-- Если SELECT возвращает только одно значение, то это значение можно
-- записать прямо в переменную внутри тела функции:
create or replace function bar()
returns int
language plpgsql
as $$
    declare
        n int := 0;

    begin
        select count(*) into n
          from customer;

        return n;
    end
$$;

select bar();










