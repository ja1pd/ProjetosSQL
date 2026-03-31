
create table credito_cliente(
    cliente varchar(200),
    total decimal(10,2),
    limite_credito decimal(10,2),
    analise varchar(100)
) engine=innodb;

create or replace view vw_questao01a as
select
    c.customername as cliente,
    sum(p.amount) as total,
    c.creditlimit as limite_credito,
    e.jobtitle as funcao_empregado,
    o.city as escritorio
from 
	customers c
	inner join payments p using (customernumber)
	inner join employees e on c.salesrepemployeenumber = e.employeenumber
	inner join offices o using (officecode)
where 
	year(p.paymentdate) in (2003, 2005)
	and c.creditlimit > 100000
group by 
	c.customername, c.creditlimit, e.jobtitle, o.city;

delimiter $$
create procedure proc_analise_credito(in p_funcao varchar(50), in p_escritorio varchar(50))
begin
    insert into credito_cliente
    select
        cliente,
        total,
        limite_credito,
        case 
            when limite_credito - total < 0 
				then 'entrar em contato com o cliente'
                
            else 'sugerir aumento de crédito'
        end
    from vw_questao01a
    where funcao_empregado = p_funcao
      and escritorio = p_escritorio;
end $$
delimiter ;

create table analise_lucro(
    produto varchar(50),
    media decimal(10,2),
    analise varchar(200)
) engine=innodb;

delimiter $$
create procedure proc_analise_lucro(in p_escritorio varchar(50), in p_pais varchar(50))
begin
    delete from analise_lucro;

    insert into analise_lucro (produto, media, analise)
    select 
        p.productname as produto,
        round(avg(((od.priceeach / p.buyprice) - 1) * 100), 2) as media,
        case
            when round(avg(((od.priceeach / p.buyprice) - 1) * 100), 2) < 30 
				then 'chamar o representante imediatamente'
            when round(avg(((od.priceeach / p.buyprice) - 1) * 100), 2) < 50 
				then 'aumentar margem de lucro'
                
            when round(avg(((od.priceeach / p.buyprice) - 1) * 100), 2) < 100 
				then 'manter o valor'
                
            else 'conceder mais 10% de desconto'
        end as analise
    from 
		orderdetails od
		inner join products p using (productcode)
		inner join orders o using (ordernumber)
		inner join customers c using (customernumber)
		inner join employees e on c.salesrepemployeenumber = e.employeenumber
		inner join offices f using (officecode)
    where f.city = p_escritorio
      and c.country = p_pais
    group by 
		p.productname;
end $$
delimiter ;

create or replace view vw_faturamento_usa as
select 
    o.city as escritorio,
    round(sum(p.amount),2) as faturamento,
    count(distinct e.employeenumber) as qtd_empregados
from 
	offices o
	inner join employees e using (officecode)
	inner join customers c on e.employeenumber = c.salesrepemployeenumber
	inner join payments p using (customernumber)
where 
	o.country = 'usa'
	and year(p.paymentdate) = 2004
	and quarter(p.paymentdate) = 2
group by 
	o.city;

create or replace view vw_faturamento_usa_clientes as
select 
    o.city as escritorio,
    c.customernumber as codigo_cliente,
    round(sum(p.amount),2) as faturamento
from 
	offices o
	inner join employees e using (officecode)
	inner join customers c on e.employeenumber = c.salesrepemployeenumber
	inner join payments p using (customernumber)
where 
	o.country = 'usa'
	and year(p.paymentdate) = 2004
	and quarter(p.paymentdate) = 2
group by 
	o.city, c.customernumber;

create or replace view vw_motorcycles as
select 
    f.city as escritorio,
    p.productcode,
    round(avg(od.priceeach),2) as media_preco,
    p.msrp
from 
	orderdetails od
	inner join products p using (productcode)
	inner join orders o using (ordernumber)
	inner join customers c using (customernumber)
	inner join employees e on c.salesrepemployeenumber = e.employeenumber
	inner join offices f using (officecode)
where 
	p.productline = 'Motorcycles'
group by 
	f.city, p.productcode, p.msrp;

drop table if exists analise_perda;
create table analise_perda (
    escritorio varchar(30),
    produto varchar(10),
    observacao varchar(200)
) engine = innodb;

delimiter $$
create procedure proc_analise_perda()
begin
    delete from analise_perda;

    insert into analise_perda (escritorio, produto, observacao)
    select 
        escritorio,
        productcode,
        case
            when format((1 - (media_preco / msrp)) * 100,2) < 5 
				then 'aceitável.'
                
            when format((1 - (media_preco / msrp)) * 100,2) between 5 and 10 
				then 'atenção produtos com risco'
                
            else 'solicitar reunião com os vendedores!'
        end as observacao
    from vw_motorcycles;
end $$
delimiter ;