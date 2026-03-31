use SAKILA;

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
    
use CLASSICMODELS;

SELECT
  CONCAT('O cliente: ' , customerName, ' pagou o valor: ', sum(amount)) OBSERVACAO
FROM
  CUSTOMERS
    INNER JOIN PAYMENTS USING (CUSTOMERNUMBER)
GROUP BY
	customerName;