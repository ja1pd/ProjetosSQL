
/*
Crie uma procedure que receberá a função do empregado como entrada e o escritório, e irá preencher uma tabela de crédito de cliente. 
Para isso, crie a tabela chamada CREDITO_CLIENTE com os seguintes campos, cliente, total, limite de crédito e análise. 
Antes, contudo, você deverá criar uma view para retornar o total pago e limite de crédito no ano de 2003 e 2005, filtrando na consulta os parâmetros definidos como entrada e o limite de crédito acima de 100 mil. 
Você deverá retornar, o nome do cliente, o total pago e limite de crédito.
 A tabela deverá receber a avaliação abaixo no campo chamado análise, que seguirá os critérios abaixo:
Se diferença entre o limite de crédito e o total pago for negativo, escrever no campo analise	: " Entrar em contato com o cliente"
Do contrário, escrever no campo análise: " Sugerir aumento de crédito"
*/

use classicmodels;

create table credito_cliente(
cliente varchar(200),
total decimal(10,2),
limite_credito decimal(10,2),
analise varchar(100)
) engine InnoDB;

drop table credito_cliente;

create or replace view vw_Questao01A as
	select
		customername as cliente,
		sum(amount) as total,
        creditLimit as limite_credito,
        jobtitle as funcao_empregado,
        offices.city as escritorio
	from
		customers
        inner join payments using (customernumber)
		inner join employees on salesRepEmployeeNumber = employeeNumber
        inner join offices using (officecode)
	where
		year(paymentdate) in (2003,2005)
        and creditlimit > (100000)
    group by
		cliente, limite_credito, funcao_empregado, escritorio;
        
select * from vw_Questao01A;

delimiter $

create procedure proc_analise_credito(in p_funcao varchar(50), in p_escritorio varchar(50))
begin
    insert into credito_cliente
    select
        cliente,
        total,
        limite_credito,
        case 
            when limite_credito - total < 0 
				then 'Entrar em contato com o cliente'
                
            else 'Sugerir aumento de crédito'
        end
    from vw_Questao01A
    where funcao_empregado = p_funcao
      and escritorio = p_escritorio;
end $

delimiter ;

call proc_analise_credito('Sales Rep','Paris');

select * from credito_cliente;

drop procedure proc_analise_credito;

/*
Crie uma procedure com entrada igual ao escritório e pais e  que retorne o nome do produto e a média do percentual de lucro sobre o preço de compra, veja o cálculo: round(avg(((priceEach/buyPrice)-1)*100),2). 
Além disso, o país do cliente deve ser aquele definido no parâmetro. 
Todos os valores devem ser armazenados na tabela Analise_Lucro que deve ter os campos: produto, média e análise. 
Além disso, você deverá colocar um campo de análise, que deve seguir a regra abaixo: 
Se a média for menor que 30, escrever “Chamar o representante imediatamente”
Se a média for menor que 50, escrever “Aumentar margem de lucro”
Se a média for menor que 100, escrever “Manter o valor”
Do contrário, escrever “Conceder mais 10% de desconto”
	
Dicas: buyPrice -> Tabela Products
*/

create table Analise_Lucro (
    produto varchar(200),
    media decimal(10,2),
    analise varchar(100)
) engine = InnoDB;

delimiter $

create procedure proc_analise_lucro(in p_escritorio varchar(50), in p_pais varchar(50))
begin
	insert into Analise_Lucro (produto, media, analise)
    select 
        productName as produto,
        round(avg(((priceEach / buyPrice) - 1) * 100), 2) as media,
        case
            when round(avg(((priceEach / buyPrice) - 1) * 100), 2) < 30 
				then 'Chamar o representante imediatamente'
                
            when round(avg(((priceEach / buyPrice) - 1) * 100), 2) < 50 
				then 'Aumentar margem de lucro'
                
            when round(avg(((priceEach / buyPrice) - 1) * 100), 2) < 100 
				then 'Manter o valor'
				
            else 'Conceder mais 10% de desconto'
        end as analise
    from 
		orderdetails 
		inner join products using (productCode)
		inner join orders using (orderNumber)
		inner join customers using (customerNumber)
		inner join employees on customers.salesRepEmployeeNumber = employees.employeeNumber
		inner join offices using (officeCode)
    where offices.city = p_escritorio
      and customers.country = p_pais
    group by productName;
end $

delimiter ;

drop procedure proc_analise_lucro;

call proc_analise_lucro('Paris', 'France');

select * from Analise_Lucro;