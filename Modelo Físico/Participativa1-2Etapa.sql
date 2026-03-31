use sakila;

create or replace view Questao_01_A
as

select 
   concat(first_name, ' ', last_name) as cliente, 
   sum(amount) as valor_pago, 
   ifnull(rental_duration - cast(datediff(return_date, rental_date) as decimal), 999) as analise_dia, 
   case 
     when ifnull(rental_duration - cast(datediff(return_date, rental_date) as decimal), 999) = 999
       or ifnull(rental_duration - cast(datediff(return_date, rental_date) as decimal), 999) < 0 
	 then concat('Informar ao cliente ', first_name, ' ', last_name, ' tem restrições para alugar') 
     else 
       concat('Informar ao cliente ', first_name, ' ', last_name, ' que terá 15% de desconto') 
	end as analise
from 
  customer 
    inner join payment using (customer_id)
    inner join rental using (rental_id)
    inner join inventory using (inventory_id)
    inner join film using (film_id)
where 
    month(payment_date) in (6,7)
and year(payment_date) = 2005
and rental_duration > 5
and length > 100
group by
  cliente, analise_dia, analise
limit 10;

create or replace view Questao_01_B
as
select 
  store_id as loja, 
  sum(replacement_cost) as total
from 
  rental
    inner join inventory using (inventory_id)
    inner join film using (film_id)
where 
  return_date is null
group by
  loja;
  
  use classicmodels;

create or replace view Questao_01_C_1
as 

SELECT 
  OBSERVACAO, 
  COUNT(OBSERVACAO)
FROM (
  
SELECT 
   'PRODUTOS' AS OBSERVACAO, 
   
   COUNT(PRODUCTNAME)
FROM 
   PRODUCTS
     INNER JOIN ORDERDETAILS USING (PRODUCTCODE)
     INNER JOIN ORDERS USING (ORDERNUMBER)
WHERE 
   YEAR(ORDERDATE) = 2004
GROUP BY
 PRODUCTNAME
HAVING 
  SUM(QUANTITYORDERED) > 550);
  

create or replace view Questao_01_C_2
as 

SELECT 
  OBSERVACAO, 
  COUNT(OBSERVACAO)
FROM (
  
SELECT 
   'PRODUTOS' AS OBSERVACAO, 
   
   COUNT(PRODUCTNAME)
FROM 
   PRODUCTS
     INNER JOIN ORDERDETAILS USING (PRODUCTCODE)
     INNER JOIN ORDERS USING (ORDERNUMBER)
WHERE 
   YEAR(ORDERDATE) = 2004
GROUP BY
 PRODUCTNAME
HAVING 
  SUM(QUANTITYORDERED) > 550
UNION  
  
SELECT 
   'CLIENTES' AS OBSERVACAO, 
   COUNT(CUSTOMERNAME)
FROM 
  CUSTOMERS 
     INNER JOIN PAYMENTS USING (CUSTOMERNUMBER)
     INNER JOIN EMPLOYEES ON SALESREPEMPLOYEENUMBER = EMPLOYEENUMBER 
     INNER JOIN OFFICES USING (OFFICECODE)
WHERE 
    YEAR(PAYMENTDATE) = 2003
AND OFFICES.CITY IN ('Paris', 'Tokyo')
GROUP BY
  CUSTOMERNAME
HAVING 
  SUM(AMOUNT) > 100000
UNION  
SELECT 
   'VENDEDORES' AS OBSERVACAO, 
   COUNT(CONCAT(FIRSTNAME, ' ', LASTNAME))
FROM 
  CUSTOMERS 
     INNER JOIN PAYMENTS USING (CUSTOMERNUMBER)
     INNER JOIN EMPLOYEES ON SALESREPEMPLOYEENUMBER = EMPLOYEENUMBER 
WHERE 
    YEAR(PAYMENTDATE) = 2005
GROUP BY
  CONCAT(FIRSTNAME, ' ', LASTNAME)
HAVING 
  SUM(AMOUNT) > 200000) AS RESULTADO
GROUP BY 
  OBSERVACAO;
  

create or replace view Questao_01_C
as 

SELECT 
  OBSERVACAO, 
  COUNT(OBSERVACAO)
FROM (
  
SELECT 
   'PRODUTOS' AS OBSERVACAO, 
   
   COUNT(PRODUCTNAME)
FROM 
   PRODUCTS
     INNER JOIN ORDERDETAILS USING (PRODUCTCODE)
     INNER JOIN ORDERS USING (ORDERNUMBER)
WHERE 
   YEAR(ORDERDATE) = 2004
GROUP BY
 PRODUCTNAME
HAVING 
  SUM(QUANTITYORDERED) > 550
UNION  
  
SELECT 
   'CLIENTES' AS OBSERVACAO, 
   COUNT(CUSTOMERNAME)
FROM 
  CUSTOMERS 
     INNER JOIN PAYMENTS USING (CUSTOMERNUMBER)
     INNER JOIN EMPLOYEES ON SALESREPEMPLOYEENUMBER = EMPLOYEENUMBER 
     INNER JOIN OFFICES USING (OFFICECODE)
WHERE 
    YEAR(PAYMENTDATE) = 2003
AND OFFICES.CITY IN ('Paris', 'Tokyo')
GROUP BY
  CUSTOMERNAME
HAVING 
  SUM(AMOUNT) > 100000
UNION  
SELECT 
   'VENDEDORES' AS OBSERVACAO, 
   COUNT(CONCAT(FIRSTNAME, ' ', LASTNAME))
FROM 
  CUSTOMERS 
     INNER JOIN PAYMENTS USING (CUSTOMERNUMBER)
     INNER JOIN EMPLOYEES ON SALESREPEMPLOYEENUMBER = EMPLOYEENUMBER 
WHERE 
    YEAR(PAYMENTDATE) = 2005
GROUP BY
  CONCAT(FIRSTNAME, ' ', LASTNAME)
HAVING 
  SUM(AMOUNT) > 200000) AS RESULTADO
GROUP BY 
  OBSERVACAO;
  
