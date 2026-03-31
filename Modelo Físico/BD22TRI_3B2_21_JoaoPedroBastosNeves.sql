# a

create or replace view questaoAProvaF as
	select
		(priceEach/buyPrice) as lucro,
		avg(quantityordered) as media
    from
		products
        inner join orderdetails using (productCode)
        inner join orders using (ordernumber)
        inner join customers using (customerNUmber)
		inner join employees on salesrepemployeenumber = employeenumber
	where
		year(orderdate) = 2003
        and month(orderdate) between 9 and 12
        and reportsTo = 1056 or 1143
	group by
		productcode
    limit 5
		
# b

delimiter $$
create procedure proc_questaob (in codigo_loja int)
begin

declare numero_n_devolveram int;
declare total_reposicao double;

set numero_n_devolveram =
	select 

select 
 ('Na loja: ', codigo_loja, ' O Número de clientes que não realizaram a devolução do filme são: ', numero_n_devolveram,', deixando de receber o valor de ', format(total_reposicao,2)
;
end$$
delimiter ;

# c

delimiter $$
create procedure questaoCProvaF (out saida varchar(225))
begin
	select
		title
	from
		film
	where
		film_id = 331;


end$$
delimiter ;

# d

with cte_paises as (

	select
		Country_name,
        (Population/SurfaceArea)
        LifeExpectancy
		CASE
			WHEN LifeExpectancy > 75
                    THEN 'Boa Expectativa de Vida'
			else 'Melhorar Padrões de Vida'
		end as analise
)

# e

delimiter $$
create procedure rotina (in nome varchar(50))
begin
select 
	CASE
			WHEN nome = 'joao'
                    THEN 'acordar, tomar banho, estudar, trabalhar,dormir'
			else 'Nao tem rotina'
		end as rotina;
end$$
delimiter ;

drop procedure rotina;

call rotina('joao')