-- Выбор каждой строки каждой колонки, т.е. получение всей таблицы.
select * from customer;

-- Выбор значений определённых колонок.
select first_name, last_name, email
  from customer;

-- Aliasing колонки
select first_name as "First Name"
  from customer;
-- Aliasing работает и без as, но лучше его вставлять для увеличения читаемости кода.
select first_name "First Name"
  from customer;
