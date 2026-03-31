use sakila;

# comentario de linha 
-- comentario de linha

/*
varias linhas
*/

select * from actor;

select 
	actor_id as codigo,
	first_name as primeiro_nome,
	last_name as ultimo_nome
from 
	actor as ator;

select 
* 
from (
	select 
		actor_id as codigo,
		first_name as primeiro_nome,
		last_name as ultimo_nome
	from actor) as ator
where 
codigo = 1;


select 
	actor_id as codigo,
	first_name as primeiro_nome,
	last_name as ultimo_nome,
	concat(first_name,' ',last_name) as nome_completo
from 
	actor as ator;

select * from film;

select 
	* 
from 
	film
where
	title like '%a__n_a%'
    and rental_duration <> 5
;
    
-- != é a mesma coisa de <>
    
select 
	* 
from 
	film
where
	title like '%a__n_a%'
    and rental_duration != 5
    and length between 60 and 92
    and rental_rate in (4.99, 0.99)
;
    
select 
	* 
from 
	film
where
	title like '%a__n_a%'
    and rental_duration != 5
    or length between 60 and 92
    and rental_rate in (4.99, 0.99)
;
    
select 
	* 
from 
	film
where
	title like '%a__n_a%'
    and rental_duration != 5
    or length > 60 and length <= 92
    and rental_rate in (4.99, 0.99)
;
    
select distinct
	rental_duration
from
	film
;

    
select 
	* 
from 
	film
where
	title like '%a__n_a%'
    and rental_duration != 5
    and length > 60 and length <= 92
    and rental_rate not in (4.99, 0.99)
;

select 
	* 
from
	film
limit
	10    
offset 
	3
;

select 
	payment_date,
    day(payment_date) as dia,
    month(payment_date) as mes,
    year(payment_date) as ano
from
	payment
where
	year(payment_date) = 2005
	and month(payment_date) between 1 and 6
;

select
	payment_date,
    day(payment_date) as dia,
    month(payment_date) as mes,
    year(payment_date) as ano
from
	payment
where
	year(payment_date) = 2005
	and month(payment_date) between 7 and 9
;