create database sakila;
use sakila;
drop database sakila;
# 2 - A 
select 
	*
from 
	city
    inner join address using (city_id);
    
# 2 - B
select 
	*
from 
	address
    inner join customer using (address_id);

# 2 - C 
select 
	*
from 
	customer
    inner join payment using (customer_id);
    
# 2 - D
select 
	*
from 
	customer
    inner join payment using (customer_id);
    
# 2 - E
select 
	*
from 
	language
    inner join film using (language_id);
    
# 3 - A
select 
    count(film_id) as qtde,
    rental_rate as taxa,
    count(inventory.film_id) * rental_rate as totalPrevisto
from
	film
		inner join inventory on (film.film_id = inventory.film_id)
group by
	titulo, rental_rate;
    