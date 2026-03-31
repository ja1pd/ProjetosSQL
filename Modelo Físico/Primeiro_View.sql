use sakila;

create or replace view vw_cliente_pagamento
as
select
	concat(first_name,' ', last_name) as nome_completo,
    sum(amount) as valor_pago,
    country as pais
from
	country
    inner join city using (country_id)
    inner join address using (city_id)
    inner join customer using (address_id)    
    inner join payment using (customer_id)
group by 
	nome_completo, pais;

select * from vw_cliente_pagamento;