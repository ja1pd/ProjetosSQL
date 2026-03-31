use classicmodels;

CREATE TABLE cliente SELECT * FROM
    customers;
CREATE OR REPLACE VIEW vw_cliente (nome , valor_total) AS
    SELECT 
        customername, SUM(amount)
    FROM
        customers
            INNER JOIN
        payments USING (customernumber)
    GROUP BY customername;

select
	*
from
	vw_cliente
;

SELECT 
    *
FROM
    cliente;

UPDATE cliente 
SET 
    phone = 99999999
WHERE
    customernumber = 103;
    
SELECT 
    *
FROM
    customers;

update tab_cliente set valor_total = 100000 where nome = 'Atelier graphique';

CREATE TABLE tab_cliente SELECT * FROM
    vw_cliente;
    
    
    
select
	productcode,
    productname,
    priceEach,
    buyPrice,
    msrp,
    round(((priceEach/buyPrice) - 1)*100,2) as lucro_prec_compra,
	round(((priceEach/msrp) - 1)*100,2) as lucro_prec_sugerido
from
	products
		inner join orderdetails using(productcode)
		inner join orders using(ordernumber)
		inner join customers using(customernumber)
		inner join employees on salesRepEmployeeNumber = employeeNumber
        inner join offices using (officecode)
where
	year(orderdate) in (2004,2005)
and month(orderdate) in (10,11,12)
and offices.city in ('London','Paris','Tokyo');



with cte_produto 
(codigoProduto, nomeProduto, precoCompra, precoSugerido)
as 
(
	select productcode, productname, buyprice, msrp from products
),
cte_itemPedido (codigoProduto,numeroNota,precoUnitario)
as
(
	select productCode, orderNumber, priceEach from orderdetails
),
cte_pedido (numeroNota, dataPedido, codigoCliente)
as
(
	select
    ordernumber, orderdate, customernumber from orders
    where
    year(orderdate) in (2004,2005)
    and month(orderdate) in (10,11,12)
),
cte_cliente ( codigoCliente, CodigoVendedor)
as
(
	select customernumber, salesRepEmployeeNumber from customers 
),
cte_vendedor (codigoVendedor, codigoEscritorio)
as
(
	select employeenumber, officecode from employees
),
cte_escritorio ( codigoEscritorio, cidade)
as
(
	select
    officecode, city from offices
    where
    city in ('Paris','London','Tokyo')
)
select 
    nomeProduto,
    precoUnitario,
    precoCompra,
    precoSugerido,
    round(((precoUnitario/precoCompra) - 1)*100,2) as lucro_prec_compra,
	round(((precoUnitario/precoSugerido) - 1)*100,2) as lucro_prec_sugerido
from
    cte_produto
	inner join cte_itemPedido using (codigoProduto)
	inner join cte_Pedido using (numeroNota)
    inner join cte_cliente using (codigoCliente)
    inner join cte_vendedor using (codigovendedor)
    inner join cte_escritorio using (codigoescritorio)
;

    