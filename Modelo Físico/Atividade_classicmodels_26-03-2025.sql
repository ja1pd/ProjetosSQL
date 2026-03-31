use sakila;

   
(select 
	concat(first_name,' ',last_name) as nomeCompleto
from
	customer
where
	active = 1
limit 5)
union
(select 
	concat(first_name,' ',last_name) as nomeCompleto
from
	customer
where
	active = 0
limit 5);


# tabelas envolvidas: payment, customer, adress, city, country
   
(select 
	concat(first_name,' ',last_name) as nomeCompleto
from
	payment
		inner join customer using(customer_id)
		inner join address using(address_id)
		inner join city using(city_id)
		inner join country using(country_id)
where
	month(payment_date) between 8 and 10
and year(payment_date) = 2005
and active = 1
and country like 'A%'
)
union 
(select 
	concat(first_name,' ',last_name) as nomeCompleto
from
	customer    
		inner join address using(address_id)
		inner join city using(city_id)
		inner join country using(country_id)
where
	active = 0
    and country like 'C%'
);

use classicmodels;

select * from customers;
select * from payments;
select * from employees;
select * from offices;
select * from orders;
select * from orderdetails;
select * from products;
select * from productlines;

select
	*
from
(
select
	concat(firstname,' ',lastname)as nomeEmpregado,
    sum(amount) as totalRecebido
from
	employees
    inner join customers on (salesRepEmployeeNumber = employeeNumber)
    inner join payments using(customerNumber)
where 
	year(paymentdate) between 2003 and 2005
and month(paymentdate) in (1,2,3)
group by
	nomeEmpregado

union

select
	offices.city as escritorio,
    sum(amount) as totalRecebido
from
	offices
	inner join employees using (officeCode)
    inner join customers on (salesRepEmployeeNumber = employeeNumber)
    inner join payments using(customerNumber)
where
	year(paymentdate) = 2005
and month(paymentdate) in (4,5,6)
group by
	offices.city
) as resultado
where
	totalRecebido > 100000;
