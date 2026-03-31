use sakila;

with Questao_01_A as (
    select 
        concat(first_name, ' ', last_name) as cliente, 
        sum(amount) as valor_pago, 
        ifnull(rental_duration - cast(datediff(return_date, rental_date) as decimal), 999) as analise_dia, 
        case 
            when ifnull(rental_duration - cast(datediff(return_date, rental_date) as decimal), 999) = 999
              or ifnull(rental_duration - cast(datediff(return_date, rental_date) as decimal), 999) < 0 
            then concat('Informar ao cliente ', first_name, ' ', last_name, ' tem restrições para alugar') 
            else concat('Informar ao cliente ', first_name, ' ', last_name, ' que terá 15% de desconto') 
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
    limit 10
)
select * from Questao_01_A;

with Questao_01_B as (
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
        loja
)
select * from Questao_01_B;

use classicmodels;

with
Produtos as (
    select 
        'produtos' as observacao, 
        count(productname) as total
    from 
        products
        inner join orderdetails using (productcode)
        inner join orders using (ordernumber)
    where 
        year(orderdate) = 2004
    group by
        productname
    having 
        sum(quantityordered) > 550
),
Clientes as (
    select 
        'clientes' as observacao, 
        count(customername) as total
    from 
        customers 
        inner join payments using (customernumber)
        inner join employees on salesrepemployeenumber = employeenumber 
        inner join offices using (officecode)
    where 
        year(paymentdate) = 2003
        and offices.city in ('paris', 'tokyo')
    group by
        customername
    having 
        sum(amount) > 100000
),
Vendedores as (
    select 
        'vendedores' as observacao, 
        count(concat(firstname, ' ', lastname)) as total
    from 
        customers 
        inner join payments using (customernumber)
        inner join employees on salesrepemployeenumber = employeenumber 
    where 
        year(paymentdate) = 2005
    group by
        concat(firstname, ' ', lastname)
    having 
        sum(amount) > 200000
),
Questao_01_C as (
    select * from Produtos
    union
    select * from Clientes
    union
    select * from Vendedores
)
select * from Questao_01_C;