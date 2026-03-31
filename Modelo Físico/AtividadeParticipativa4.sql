-- Atividade Participativa 4
/*
Caros, 
Conforme combinado em sala de aula, foi apresentada a procedure da sacola. Você deverá chamar as procedures e testá-la. 
Caso encontre algum erro. Você deverá corrigi-la, explicando tudo que foi feito. 
Espero na entrega um relatório dos testes feitos, erros encontrados e soluções propostas para as correções.
*/


create database sinuca;

use sinuca;

/*Sacola para armazenar as bolas de sincuca*/
create table sacola (
  numeroBola int not null primary key, 
  cor varchar(10), 
  qtde int
) engine = innodb;

call incluir_bolas_sacola(1,'verde',1); 
drop procedure incluir_bolas_sacola;

delimiter $
create procedure incluir_bolas_sacola(in param_numeroBola int, 
                                      in param_cor varchar(10), 
                                      in param_qtde int)
begin                                      
   declare var_capacidade_sacola int default 200; # identifica a capacidade máxima de bolas dentro da sacola
   declare var_quantidade_atual int default 0;              # identifica a quantidade de bolas existente na sacola no momento
   declare var_quantidade_final_sacola int default 0;		  # armazena a quantidade de uma bola especifica mais (+) a quantidade que será incluida (param_qtde)
   declare var_espaco_disponivel int default 0;             # armazena o espaço disponível para incluir bolas na sacola (capacidade - quantidade atual)
   declare var_existe_bola int default 0;					  # identificar a existência da bola na sacola
   
   /*
   Verifica se a bola existe ou não na sacola. 
   Caso não existe, há um tratamento de nulo. 
   Nesta situação, o valor atribuido à variável será zero.
   */
   select ifnull(count(numeroBola),0) into var_existe_bola
   from sacola where numeroBola = param_numeroBola;

   /*
    Se não existir a bola na sacola, permitirá fazer a inclusão da bola.
    Do contrário, será chamada a procedure de alteração. 
   */
   if var_existe_bola = 0 then
      
      if 
      (param_cor = 'Azul' and param_numeroBola = (2,10)) || 
      (param_cor = 'Amarela' and param_numeroBola = (1,9))  || 
      (param_cor = 'Vermelha' and param_numeroBola = (3,11)) ||
      (param_cor = 'Roxa'  and param_numeroBola = (4,12)) ||
      (param_cor = 'Laranja' and param_numeroBola = (5,13)) ||
      (param_cor = 'Verde' and param_numeroBola = (6,14)) ||
      (param_cor = 'Marrom' and param_numeroBola = (7,15)) ||
	  (param_cor = 'Preta' and param_numeroBola = (8))
      then
      
		/*Verifica a quantidade total atual de bolas existentes na sacola*/
		select ifnull(sum(qtde),0) into var_quantidade_atual
		from sacola;

		/* Realiza o calculo de quantas bolas ficarão na sacola. */
		set var_quantidade_final_sacola = var_quantidade_atual + param_qtde;
   
		/* Validar se valor final irá ultrapassar a capacidade da sacola.
			Caso ultrapasse e exista espaço disponível para incluir bolas na sala, 
			será incluida apenas a quantidade para igualar a capacidade. 
			O restante, será informado para o usuario.
		*/
			if var_quantidade_final_sacola <= var_capacidade_sacola then
				insert into sacola (numeroBola, cor, qtde) values (param_numeroBola, param_cor, param_qtde);
			else
				# Identificação do espaço disponível na sacola
				set var_espaco_disponivel = var_capacidade_sacola - var_quantidade_atual;
				insert into sacola (numeroBola, cor, qtde) values (param_numeroBola, param_cor, var_espaco_disponivel);
				# Mensagem para o usuario.
				select concat('Você excedeu a capacidade em: ', (param_qtde - var_espaco_disponivel));
			end if;
	  end if;
  else 
     #Chamada da procedure de altearção
	 call alterar_bolas_sacola(param_numeroBola, param_cor, param_qtde);
  end if;
end$

create procedure alterar_bolas_sacola (in param_numeroBola int, 
                                      in param_cor varchar(10), 
                                      in param_qtde int)
begin
   declare var_capacidade_sacola int default 200; # identifica a capacidade máxima de bolas dentro da sacola
   declare var_quantidade_atual int;              # identifica a quantidade de bolas existente na sacola no momento
   declare var_quantidade_final_sacola int;		  # armazena a quantidade de uma bola especifica mais (+) a quantidade que será incluida (param_qtde)
   declare var_espaco_disponivel int;             # armazena o espaço disponível para incluir bolas na sacola (capacidade - quantidade atual)
   declare var_existe_bola int;					  # identificar a existência da bola na sacola
   declare var_quantidade_bolas_por_cor int;	  # Verifica quantidade bolas de uma cor especifica.
   
   /*
   Verifica se a bola existe ou não na sacola. 
   Caso não existe, há um tratamento de nulo. 
   Nesta situação, o valor atribuido à variável será zero.
   */ 
   select ifnull(numeroBola,0) into var_existe_bola
   from sacola where numeroBola = param_numeroBola;

   /*
    Se não existir a bola na sacola, permitirá fazer a inclusão da bola.
    Do contrário, será chamada a procedure de alteração. 
   */
   if var_existe_bola > 0 then
   
      /*Verifica a quantidade total atual de bolas existentes na sacola*/
	  select ifnull(sum(qtde),0) into var_quantidade_atual
      from sacola;
      
      /* Realiza o calculo de quantas bolas ficarão na sacola. */
      set var_quantidade_final_sacola = var_quantidade_atual + param_qtde;
      
      /* Validar se valor final irá ultrapassar a capacidade da sacola. 
         Se não ultrapassar, o processo de Update continuará.      
         Caso ultrapasse e exista espaço disponível para incluir bolas na sala, 
         será incluida apenas a quantidade para igualar a capacidade. 
         O restante, será informado para o usuario.
      */
      if var_quantidade_final_sacola <= var_capacidade_sacola then
      
         # Verifica existe a bola daquela cor especifica.
         select qtde into var_quantidade_bolas_por_cor
         from sacola
         where numeroBola = param_numeroBola;
         
         /*
            Certifica que a quantidade final será superior a zero.
            Caso seja maior, o update ser realizado dentro do esperado. 
            Do contrário, compreende-se que não existir mais bolas na sacola, 
            em função disso será excluida a bola da sacola.
         */
         if (var_quantidade_bolas_por_cor + param_qtde) > 0 then         
            update sacola set qtde = var_quantidade_bolas_por_cor + param_qtde where numeroBola = param_numeroBola;
		 else
            # Chamada da procedure de exclusão.
            call excluir_bolas_sacola(param_numerobola);
		 end if;
	  else 
          # Identificação do espaço disponível na sacola
		  set var_espaco_disponivel = var_capacidade_sacola - var_quantidade_atual;
		  update sacola set qtde = var_espaco_disponivel where numeroBola = param_numeroBola;
          # Mensagem para o usuario.
          select concat('Você excedeu a capacidade em: ', (param_qtde - var_espaco_disponivel));
	  end if;
   else
     call incluir_bolas_sacola (param_numeroBola, param_cor, param_qtde);
   end if;
end$

create procedure excluir_bolas_sacola(in param_numeroBola int)
begin
   declare var_existe_bola int; 
   
   /*
   Verifica se a bola existe ou não na sacola. 
   Caso não existe, há um tratamento de nulo. 
   Nesta situação, o valor atribuido à variável será zero.
   */ 
   select ifnull(numeroBola,0) into var_existe_bola
   from sacola
   where numeroBola = param_numeroBola;
   
   # Se a bola existir será excluida da Sacola. Do contrário, será enviada uma mensagem para o usuário.
   if var_existe_bola > 0 then
      delete from sacola where numerobola = param_numeroBola;
   else
      select concat('A bola de numero: ', param_numeroBola, ' não existe');
   end if;

end$
delimiter ;