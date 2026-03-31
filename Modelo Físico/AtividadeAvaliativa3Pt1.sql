use classicmodels;

-- q1
create or replace view questao01 as
select
	productname as produto,
    productcode as codigoproduto,
    sum(quantityordered) as quantidade_comprada,
    sum(priceeach * quantityordered) as total_pago,
    customernumber as codigocliente
from
	products
    inner join orderdetails using (productcode)
    inner join orders using (ordernumber)
where
	year(orderdate) = 2003
    and month(orderdate) in (1,5,10)
group by
	produto;
    
-- q2
with cte_cliente(codigocliente, employeenumber)
as(
	select
		customernumber, salesrepemployeenumber
	from
		customers
),
cte_empregado(employeenumber, officecode)
as(
	select
		employeenumber, officecode
	from
		employees
),
cte_escritorio(officecode, cidade)
as(
	select
		officecode, city
	from
		offices
)

select
	produto,
    quantidade_comprada,
    total_pago
from
	questao01
    inner join cte_cliente using (codigocliente)
    inner join cte_empregado using (employeenumber)
    inner join cte_escritorio using (officecode)
where
	cidade in ('Tokyo','London');
    
-- q3
select
	productname as produto,
	sum(quantityordered) as quantidade_comprada,
    sum(priceeach * quantityordered) as total_pago,
    customernumber as codigo_cliente,
    quantityinstock as estoque
from 
	products
	inner join orderdetails using (productcode)
    inner join orders using (ordernumber)
where
	year(oderdate) = 2003
group by produto;

create table analise_estoque
(
codigoProduto varchar(10),
observacao varchar(200)
) engine = innobd;

delimiter $
create procedure questao03_3()
begin
	declare total_registros int default 0;
    declare contador int default 0;
    declare var_produto varchar(10);
    declare var_descricao varchar(200);
    
    select 
		count(*) into total_registros 
    from 
		products 
        inner join orderdetails using (productcode)
        inner join orders using (ordernumber)
	where
		year(orderdate) = param_ano
	group by
		productcode;
        
	repeat
		insert into analise_estoque values (CodigoProduto, obsevacao)
        select
			productname as produto,
            case
				when format(sum(quantityordered)/sum(quantityordered) + quantityInstock) *100, 2) > 70
					then 'Atenção produto está precisando ser reposto. Por favor, solicite ao fornecedor!'
				when format(sum(quantityordered)/sum(quantityordered) + quantityInstock) *100, 2) between 60 and 70
					then 'O produto precisa ser reposto imediatamente! Ligue agora para o fornecedor!'
				else
					'Produto controlado'
			end as resultado
		from
			products