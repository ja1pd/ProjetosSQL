use classicmodels;
-- informações
-- 



-- Prova B

-- Informações
# ano (2005) - PaymentDate
# mês (6,7) - PaymentDate
# tempo máximo de aluguel (>5) - Rental_Duration
# tamanho (>100) - Length

-- Tabelas
# Payment
# Rental
# Inventory
# Film

--
# Função de agregação
# Case
# Where
# Group By

use sakila;

select
	concat(first_name," ",last_Name) as NomeCompleto,
	sum(amount) as Valor_Total
from
	payment
	inner join customer using (customer_id)
    inner join rental using (rental_id)
    inner join inventory using (inventory_id)
	inner join film using (film_id)
where
	year(Payment_Date) = 2005 and
    month(Payment_Date) between (6,7) and
    Rental_duration > 5 and 
    Length > 100
group by
	NomeCompleto;

    