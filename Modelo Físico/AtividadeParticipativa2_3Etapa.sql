/*
Crie uma trigger para a tabela OrderDetails. 

O que trigger deve fazer:
Essa trigger deverá monitorar a tabela acima e realizar uma verificação na tabela products. 
Se a quantidade de produto no estoque (quantityInStock) for menor que a quantidade solicitada pelo cliente (quantityOrdered), você deverá abortar a venda. 
Do contrário, a venda deverá ser realizada e atualizar por meio da mesma trigger a quantidade atual do produto. 
Além disso, crie uma tabela de log_modificação para monitorar as mudanças que acontecerão nas tabelas OrderDetails e Products.
*/

use classicmodels;

create table log_modificacao_orderdetails (
    id_log int auto_increment primary key,
    tabela_afetada varchar(50),
    operacao varchar(50),
    data_modificacao timestamp default current_timestamp,
    detalhes text
) engine = innoDB;

delimiter $$

create trigger trg_before_insert_orderdetails before insert on orderdetails for each row
begin
    declare estoque_atual int;

    select 
      quantityinstock 
    into 
      estoque_atual
    from 
      products
    where 
      productcode = new.productcode;

    if estoque_atual < new.quantityordered then
        signal sqlstate '45000'
            set message_text = 'estoque insuficiente para realizar a venda';
    else
        update 
          products
        set 
          quantityinstock = quantityinstock - new.quantityordered
        where 
          productcode = new.productcode;

        insert into log_modificacao_orderdetails (tabela_afetada, operacao, detalhes)
        values (
            'products',
            'update',
            concat('produto ', new.productcode, 
                   ' teve estoque atualizado. quantidade vendida: ', new.quantityordered)
        );

        insert into log_modificacao_orderdetails (tabela_afetada, operacao, detalhes)
        values (
            'orderdetails',
            'insert',
            concat('pedido inserido: ordernumber=', new.ordernumber, 
                   ', productcode=', new.productcode,
                   ', quantityordered=', new.quantityordered)
        );
    end if;
end$$

delimiter ;

delimiter $$

create trigger trg_inserir_pedido before insert on OrderDetails for each row
begin

declare var_estoque int default 0;

select quantityinstock into var_estoque from products where new.productcode;

if var_estoque >= new.quantityOrdered then
	update products set quantityInStock = var_estoque - new quantityOrdered where new.productcode;
    insert into log_modificacao (idmodificacao, modificacao) values (default, concat('O Produto ', new.productcode, ' foi incluido no pedido ', new.ordernumber, ' com a quantidade ', new.quantityOrdered))
else
	signal sqlstate '4500'
    set message_text = 'A venda deste produto foi interrompida por falta de estoque.';
end if;
end$


delimiter ;