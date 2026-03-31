-- Simulado A


-- Simulado B

-- Questao 01

-- Identifique o idioma e a categoria dos filmes mais alugados, mostrando a quantidade alugada e o valor acumulado em 2005. Você deve mostrar em seu resultado o idioma, a categoria e as demais informações solicitadas.

use sakila;

select
	title as titulo, 
	language.name as Idioma,
    category.name as category,
    sum(amount) as total,
    rental_rate as aluguel,
    count(rental.inventory_id) as quantidadeAlugada,
    year(rental_date) as ano
from
	film
	inner join inventory using (film_id)
	inner join language using (language_id)
	inner join rental using (inventory_id)
	inner join payment using (rental_id)
    inner join film_category using (film_id)
    inner join category using (category_id)
where
	year(rental_date) = 2005
group by
	film_id
order by 
	count(rental.inventory_id) desc;
    
-- -------------------------------------------------------------------------------------------------------------

-- Questao 02


use classicModels;

-- A) Relacione os 20 produtos mais vendidos em 2003; 
select 
	productName as Nome,
    sum(quantityOrdered) as Quantidade
from 
	products
    inner join orderdetails using (productCode)
    inner join orders using (orderNumber)
where
	year(orderDate) = 2003
group by productCode
order by sum(quantityOrdered) desc
limit 20;

-- B) Informe o valor médio, máximo e mínimo dos produtos vendidos por mês para o escritório de Paris no ano de 2004;
select 
  year(orders.orderdate) as ano,
  month(orders.orderdate) as mes,
  avg(orderdetails.priceeach) as preco_medio,
  max(orderdetails.priceeach) as preco_maximo,
  min(orderdetails.priceeach) as preco_minimo
from 
  offices
  inner join employees using (officecode)
  inner join customers on employees.employeenumber = customers.salesrepemployeenumber
  inner join orders using (customernumber)
  inner join orderdetails using (ordernumber)
where 
  offices.city = 'Paris'
  and year(orders.orderdate) = 2004
group by 
  year(orders.orderdate), month(orders.orderdate)
order by 
  month(orders.orderdate) asc;
  
-- C) Qual a quantidade por produtos que têm ordem de pagamento requeridas entre setembro e dezembro;
select 
	productName as Nome,
	count(productCode) quantidade,
    month(orderDate)
from
	products
    inner join orderdetails using (productCode)
    inner join orders using (orderNumber)
where
		month(orderDate) between 9 and 12
group by
	productName;
    
-- D) Informe o total de clientes existentes em cada escritório, ordenado do maior para o menor.
    select
	officeCode as Escritorio,
	count(employees.officeCode) as funcionarios,
	count(customers.salesRepEmployeeNumber) as clientes
from
	employees
    inner join offices using (officeCode)
    inner join customers on (employees.employeeNumber = customers.salesRepEmployeeNumber)
group by
	officeCode
order by 
	count(employees.officeCode) desc;