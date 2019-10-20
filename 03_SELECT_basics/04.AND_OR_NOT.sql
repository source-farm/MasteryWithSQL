-- and
select title, rental_duration, length
  from film
 where length > 100 and rental_duration = 5;

-- or
select title, rental_duration, length
  from film
 where length > 100 or rental_duration = 5;

-- parentheses
select title, rental_duration, length
  from film
 where (length > 100 or rental_duration = 5) and left(title, 1) = 'A';

-- not
select title, rental_duration, length
  from film
 where not rental_duration = 5;
