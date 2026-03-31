create database sinuca;
use sinuca;

create table sacola(
numeroBola int not null primary key,
cor varchar(20),
qtde int
)engine = innoDB;

delimiter $
create procedure inserir_bola_sacola(in param_numero int, in param_cor varchar(20), in param_quantidade int)
begin

	declare var_quantidade_atual int default 0;
    declare var_capacidade_sacola int default 200;
	declare var_quantidade_final_inserir int default 0;
    declare var_bola_existe int default 0;
    declare var_espaco_disponivel int default 0;
    
	select sum(qtde) into var_quantidade_atual from sacola;
    
    set var_quantidade_final_inserir = param_quantidade + var_quantidade_atual;
    
    if var_quantidade_final_inserir <= var_capacidade then
    
		select numeroBola into var_bola_existe from sacola where numeroBola = param_numero;
        
			if var_bola_existe = 0 then
				insert into sacola (numeroBola, cor, qtde) values (param_numero,param_cor,param_quantidade);
			else
				call alterar_bola_sacola(param_numero, param_cor, param_quantidade);
			end if;
	else
		set var_espaco_disponivel = var_capacidade - var_quantidade_atual;
		
		insert into sacola (numeroBola, cor, qtde) values (param_numero,param_cor, var_espaco_disponivel);
        
        select concat('Foi ultrapassado o limitr da sacola em: ', (param_quantidade - var_espaco_disponivel), ' bolas.');
    end if;

end$

create procedure alterar_bolas_sacola(in param_numero int, in param_cor varchar(20), in param_quantidade int)
begin

	declare var_quantidade_atual int default 0;
    declare var_capacidade_sacola int default 200;
	declare var_quantidade_final_alterar int default 0;
    declare var_bola_existe int default 0;
    declare var_espaco_disponivel int default 0;
    
    select sum(qtde) into var_quantidade_atual from sacola;
    
    set var_quantidade_final_inserir = param_quantidade + var_quantidade_atual;
    
	if var_quantidade_final_inserir <= var_capacidade then
    
		select numeroBola into var_bola_existe from sacola where numeroBola = param_numero;
        
			if var_bola_existe > 0 then
				-- Paramos aqui
			else
				call inserir_bola_sacola(param_numero,param_cor,param_quantidade);
			end if;
    end if;
    

end$

delimiter ;