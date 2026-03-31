use classicmodels;

select
	*
from
	customers;

start transaction;

update 
	customers
set
	city = 'Belo Horizonte' 
where
	customerNumber = 103;
    
update 
	customers
set
	city = 'Santa Luzia';
    
rollback;

create table log_modificacao(
	idmodificacao int not null primary key auto_increment,
    modificacao text,
    dataModificacao datetime default current_timestamp
)	engine = InnoDB;

select * from log_modificacao;

delimiter $$

create trigger trg_update_clientes after Update on Customers for each row
begin

	insert into log_modificacao (idmodificacao, modificacao)
		values(default, concat('O cliente de nome ', old.customername, ' sofreu uma mudança na cidade. O valor anterior era ', old.city,' e o valor novo é ', new.city));
end$$

delimiter ;

drop trigger trg_update_clientes;