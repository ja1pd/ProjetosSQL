use classicModels;

-- A)
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

-- B)
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

-- C)
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
    
-- D)
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

-- E)
select 
  productname as NomeProduto,
  sum(quantityordered) as quantidadeVendida
from 
  orders
  inner join orderdetails using (ordernumber)
  inner join products using (productcode)
where 
  year(orderdate) = 2004
  and month(orderdate) between 1 and 6
group by 
  productname
order by 
  sum(quantityordered) asc
limit 15;

-- F)
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
  offices.city = 'Tokyo'
  and year(orders.orderdate) = 2003
group by 
  year(orders.orderdate), month(orders.orderdate)
order by 
  month(orders.orderdate) asc;
-- G)
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
	productName
order by
	count(productCode) desc
limit 1
;

-- H)
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