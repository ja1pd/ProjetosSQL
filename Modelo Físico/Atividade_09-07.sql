use classicmodels;

delimiter $

create procedure proc_cliente()
begin

	declare var_contador int default 0;
    
    repeat 
    
		select customername
        from customers
        limit 1 offset var_contador;
	
		set var_contador = var_contador + 1;
    until var_contador = 10
    
    end repeat;

end$

delimiter ;

drop procedure proc_cliente;

call proc_cliente();