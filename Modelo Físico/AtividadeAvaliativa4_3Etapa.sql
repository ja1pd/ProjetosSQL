/*
Caros, 

Conforme conversamos segue a atividade para hoje. 

Utilizando todos os conceitos dados na 3ª Etapa, até o momento, crie uma procedure no SAKILA para realizar um aluguel de filme para 5 clientes inativos, considerando os pontos a seguir:

1 - Clientes inativos que já tenham gasto acima de U$ 50,00. 
2 - Criação de transação para controle de processo. 
3 - Monitoramento de três tabelas (customer, payment, e rental) para os campos que sofrerão alteração. (triggers e logs)
4 - Realizar o aluguel de 5 filmes mais alugados. 
5 - Realizar o pagamento dos filmes, considerando o tempo mais curto de duração (rental_duration) entre os filmes.
*/

use sakila;

-- 1 - Clientes inativos que já tenham gasto acima de U$ 50,00. 
select
	customer_id
from
	customer
	inner join payment using (customer_id)
where 
	active = 0
group by
	customer_id
having
	sum(amount) > 50
limit 5;

-- start transaction;

-- 4 - Realizar o aluguel de 5 filmes mais alugados. 
select	
	film_id
from
	rental
	inner join inventory using (inventory_id)
    inner join film using (film_id)
group by
	film_id
order by
	count(rental_id) desc, rental_duration asc
limit 5;

create table alteracoes(
	id int auto_increment primary key not null,
    tabela varchar(10),
    modificacao text,
    datamodificacao datetime default current_timestamp
) engine = InnoDB;

delimiter $$


create trigger trg_update_customer after update on cutomer for each row
begin

	insert into alteracoes(id,modificacao,tabela)
		values (default,concat('O cliente ', old.customer_id, ' foi alterado de inativo para ativo'  ), 'Customer');
end$$


create trigger trg_update_rental after update on rental for each row
begin
	declare var_filme varchar(50);
    declare var_filme_id int;
    
    select
		title into var_filme
	from
		film
        inner join inventory using (film_id)
	where
	inventory_id = new.invetory_id;
    
	insert into alteracoes(id,modificacao,tabela)
		values (default,concat('O cliente ', old.customer_id, ' alugou o filme ', var_filme, ' no dia ', new.rental_date), 'Rental');
end$$

create trigger trg_update_customer after update on rental for each row
begin
	insert into alteracoes(id,modificacao,tabela)
		values (default,concat('O cliente ', old.customer_id, ' realizou o pagamento no dia ', new.payment_date, ' no valor de  ', new.amount), 'Payment');
end$$

create procedure pr_incluir_filme_cliente_inativo()
begin

declare done bool default false;
declare var_cliente int;
	
declare cursor_clientes_inativos cursor for
select
	customer_id
from
	customer
	inner join payment using (customer_id)
where 
	active = 0
group by
	customer_id
having
	sum(amount) > 50
limit 5;

declare continue handler for
	not found set done = true;

start transaction;

open cursor_clientes_inativos;

	lista_clie_inativos: loop
		fetch cursor_clientes_inativos into var_cliente;
        
	if done = true then
		leave lista_cli_inativos;
	end if;
    
    call pr_alugar_filmes(var_cliente);
    
    end loop;
    
    close  cursor_clientes_inativos;

end$$

create procedure pr_incluir_filme()
begin

declare done bool default false;
declare var_filme int;
	
end$$

create procedure pr_alugar_filmes()
begin

declare done bool default false;
declare var_filme int;
declare var_duration int;

	declare cursor_filmes_alugados cursor for

select	
	film_id
from
	rental
	inner join inventory using (inventory_id)
    inner join film using (film_id)
group by
	film_id
order by
	count(rental_id) desc, rental_duration asc
limit 5;


declare continue handler for
	not found set done = true;

start transaction;

open cursor_filmes_alugados;

lista_filmes: loop
		fetch cursor_filmes_alugados into var_filme, var_duration;
        
	if done = true then
		leave lista_cli_inativos;
	end if;
    
    call pr_alugar_filmes(var_cliente);
    
    end loop;
    
    close  cursor_filmes_alugados;


end$$


delimiter ;