use sakila;
# Crie uma consulta que retorne os filmes que não estão no estoque - Usar o banco de dados sakila e as tabelas Film e Inventory
select 
	title
from
	film
		left join inventory using (film_id)
where
	inventory_id is null;
    
--

select 
	title
from
	inventory
		right join film using (film_id)
where
	inventory_id is null;
    
# Crie uma consulta para retornar os produtos que não foram vendidos. Usar as tabelas (products/orderdetails)
use classicmodels;

select
	productName
from
	products
		left join orderdetails using (productCode)
where
	orderNumber is null;
    
--

select
	productName
from
	orderdetails
		right join products using (productCode)
where
	orderNumber is null;

# Crie uma consulta que retorne os clientes que não realizaram pagamentos. Usar as tabelas (customers/payments)
# describe payments;
select 
	customerName
from
	customers
	left join payments using (customerNumber)
where
	paymentdate is null;
    
--

select 
	customerName
from
	payments
	right join customers using (customerNumber)
where
	paymentdate is null;

# Crie uma consulta que retorne os vendedores que não têm clientes. A função do vendedor deverá ser Sales Rep; Usar as tabelas (customers/employees).
#describe employees;
select
	concat(firstname,' ', lastname) as vendedor
from
	employees
		left join customers on salesRepEmployeeNumber = employeeNumber
where
	jobtitle = 'Sales Rep'
and customerNumber is null;

--

select
	concat(firstname,' ', lastname) as vendedor
from
	customers
		right join employees on employeeNumber = salesRepEmployeeNumber
where
	jobtitle = 'Sales Rep'
and customerNumber is null;

# Consulta que unifica as informações:
-- Total de clintes sem vendedores
select
	count(customerNumber), 'Clientes sem Vendedores' as dado
from 
	customers
		left join employees on employeeNumber = salesRepEmployeeNumber
where 
		employeeNumber is null
	union

-- Total de produtos não vendidos
select
	count(productName), 'Produtos Não Vendidos' as dado
from
	products
		left join orderdetails using (productCode)
where
	orderNumber is null
union

-- Total de vendedores sem clientes
select
	count(employeeNumber), 'Vendedores sem Clientes' as dado
from
	employees
		left join customers on salesRepEmployeeNumber = employeeNumber
where
	jobtitle = 'Sales Rep'
and	customerNumber is null;