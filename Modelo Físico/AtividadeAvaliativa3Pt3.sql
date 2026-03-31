use classicmodels;

create table credito_cliente(
cliente varchar(200),
total decimal(10,2),
limite_credito decimal(10,2),
analise varchar(100)
) engine InnoDB;

drop table credito_cliente;

create or replace view vw_Questao01A (nome_cliente,total, limite_credito,funcao_empregado,escritorio) as
	select
		customername,
		sum(amount),
        creditLimit,
        jobtitle,
        offices.city
	from
		customers
        inner join payments using (customernumber)
		inner join employees on salesRepEmployeeNumber = employeeNumber
        inner join offices using (officecode)
	where
		year(paymentdate) in (2003,2005)
        and creditlimit > (100000)
    group by
		creditlimit;
        
select * from vw_Questao01A;

delimiter $

create procedure proc_analise_credito(in funcao_empregado varchar(10), in param_escritorio varchar(20))
begin
	declare funcao_e varchar(10);
    

end$