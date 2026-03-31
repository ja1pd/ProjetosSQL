select datediff('2025-05-12','2025-04-09') * 2 + 10 as resultado;

use sakila;

select
	datediff(return_date, rental_date) as dias
from
	rental;
    

select
    customer_id as CodCliente,
    rental_id as CodAluguel,
    rental_rate as TaxaAluguel,
    replacement_cost as TaxaReposicao,
    title as Titulo,
    rental_duration as TempoAluguel,
    ifnull(datediff(return_date, rental_date),999) as DiasAlugados,
    ifnull(rental_duration - cast(datediff(return_date, rental_date) as decimal),999) as DiasAtrasado,
    case
		when ifnull(rental_duration - cast(datediff(return_date, rental_date) as decimal),999) < 0 
        or ifnull(rental_duration - cast(datediff(return_date, rental_date) as decimal),999) = 999
        then 'Caloteiro'
        else 'Gente Boa'
	end 
		as Caráter,
	case
		when ifnull(rental_duration - cast(datediff(return_date, rental_date) as decimal),999) < 0 
        then ifnull(rental_duration - cast(datediff(return_date, rental_date) as decimal),999) * rental_rate *(-1)
			when ifnull(rental_duration - cast(datediff(return_date, rental_date) as decimal),999) =999 
			then replacement_cost
        else 'Sem Taxa'
	end 
		as Multa
from
	rental
    inner join inventory using (inventory_id)
    inner join film using (film_id);
    
describe inventory;
describe film;

select
	customer_id,
    case
		when active = 1 then 'Ativo'
        else 'Inativo'
	end as situacao_cliente
from
	customer;
    
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
use classicmodels;

select
	*,
	quantityOrdered * priceEach as PrecoTotal
from orderdetails where ordernumber = 10100;

select
	sum(quantityOrdered * priceEach) as ValorTotal
from orderdetails where ordernumber = 10100;


select
	*
from orders where ordernumber = 10100;

select
	sum(quantityOrdered * priceEach) as ValorTotal,
	amount,
    customerName,
    paymentDate
from
	orderdetails
    inner join orders using (orderNumber)
    inner join customers using (customernumber)
    inner join payments using (customernumber)
where
	year(paymentdate) = 2003
and ordernumber = 10100
and month(paymentdate) = month(orderdate)
group by
	amount,
	customerName,
    paymentdate;
    
    select
	sum(quantityOrdered * priceEach) as ValorTotal,
	amount,
    customerName,
    paymentDate,
    case
		when sum(quantityOrdered * priceEach) = amount
        then 'Valor Correto'
			when sum(quantityOrdered * priceEach) > amount
            then 'Pagamento Menor'
		else 'Pagamento Maior'
        
	end 
		as Situacao
from
	orderdetails
    inner join orders using (orderNumber)
    inner join customers using (customernumber)
    inner join payments using (customernumber)
where
	year(paymentdate) = 2003
and month(paymentdate) = month(orderdate)
group by
	amount,
	customerName,
    paymentdate;
    