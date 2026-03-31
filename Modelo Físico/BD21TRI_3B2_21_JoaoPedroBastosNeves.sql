-- Prova B

/* A)
Crie uma consulta para realizar uma conferência da caixa, no mês de JUNHO E JULHO de 2005, tempo maximo de aluguel (rental_duration) maior que 5 e o tamanho (length) maior que 100. 
Neste consulta, você deverá realizar as seguintes informações:
Nome completo do cliente, valor_pago (somatório amount), analise_dia (tempo máximo de aluguel menos o tempo alugado) e analise
O campo analise deve fazer uma verificação, conforme abaixo: 
Se analise_dia for menor que zero e igual a 999 (calculo nulo), então escrever: 'Informar ao cliente ' + NOME_COMPLETO + ' tem restrições para alugar'
Do contrário, deve escrever:  'Informar ao cliente ' + NOME_COMPLETO +   
DICA:
tempo máximo de aluguel = rental_duration, 
tempo de alugado = (dia do aluguel) - (dia de retorno do film)
Utilize: IFNULL , CAST e CONCAT
Importante: Sua consulta deve apresentar apenas 10 linhas.
*/
select
	concat(first_name," ",last_Name) as NomeCompleto,
    sum(amount) as valor_pago,
    rental_duration - (cast(datediff(return_date, rental_date)as decimal)) as analise_dia,
case
		when ifnull(rental_duration - cast(datediff(return_date, rental_date) as decimal),999) < 0 
        or ifnull(rental_duration - cast(datediff(return_date, rental_date) as decimal),999) = 999
        then concat('Informar ao cliente ', concat(first_Name," ",last_Name),' tem restrições para alugar')
        else concat('Informar ao cliente ', concat(first_Name," ",last_Name),' que terá 15% de desconto')
	end 
		as analise
from
	rental
    inner join inventory using (inventory_id)
    inner join film using (film_id)
    inner join store using (store_id)    
    inner join customer using (customer_id)
	inner join payment using (customer_id)
    ;


/* B
Crie uma consulta para retornar o prejuízo para cada loja. 
Neste caso, você deverá considerar somente os aluguéis sem data de retorno. 
No caso, deve-se utilizar o valor de reposição (replacement_cost) para computar o total do prejuízo.
*/
use sakila;

select
	store_id as loja,
    count(rental_duration - datediff(return_date, rental_date) < 0) * replacement_cost
from 
	store
	inner join customer using (store_id)
    inner join rental using (customer_id)
	inner join payment using (customer_id)
	inner join inventory using (store_id)
	inner join film using (film_id)
    group by store_id;
    
    

/* C)
Crie uma consulta que retorne a unificação das consultas abaixo:
Consulta 1: Total de produtos com quantidade de vendas acima de 550 com nota em 2004.
Consulta 2: Total de clientes que pagaram acima de 100 mil em 2003 nos escritorios de Paris e Tokyo.
Consulta 3: Total de vendedores que realizaram vendas acima de 200 mil em 2005.
*/

use classicModels;

select 
	productName as nomeProduto,
    sum(quantityOrdered) as quantidadePedida
from
	products
    inner join orderdetails using (productCode)
    inner join orders using (orderNumber)
where sum(quantityOrdered) > 550
and year(orderdate) = 2004
group by productName
;

select
	customerName as nome,
    amount 
from
	customers 
    inner join payments using (customernumber)
where amount > 100000
and city = "Paris" or "Tokyo"
and year(paymentDate) = 2003
;

select
	count(employeeNumber) as quantidade
from
	employees
	inner join customers on (employees.employeeNumber = customers.salesRepEmployeeNumber)
    inner join orders using (customerNumber)
    inner join orderdetails using (ordernumber)
where
	quantityordered * priceeach > 200000
;







/* D) 
Observe o modelo conceitual abaixo e crie o modelo físico para envolvimento das tabelas Responsável Financeiro e Contrato.
As chaves estrangeiras devem ser criadas com propagação para as exclusões.
Você deverá colocar pelo menos dois atributos em cada uma das entidades.
*/

create table ResponsavelFinanceiro(
id_ResponsavelFinanceiro int not null auto_increment primary key,
idade int
)engine = InnoDB; 

create table Contrato(
id_Contrato int not null auto_increment primary key,
fk_ResponsavelFinanceiro int not null,
foreign key (fk_ResponsavelFinanceiro) references ResponsavelFinanceiro (id_ResponsavelFinanceiro) on delete cascade
)engine = InnoDB; 