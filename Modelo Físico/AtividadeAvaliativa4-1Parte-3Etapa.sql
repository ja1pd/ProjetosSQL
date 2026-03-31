-- Corretor Eduardo Mapa Avelar Damasceno 22301674

create database lojabancodados2;
use lojabancodados2;

create table produto(
codigoproduto int primary key auto_increment not null,
nome varchar(60),
descricao varchar(200),
qtde_estoque int
) engine = innodb;

create table cliente(
codigocliente int primary key auto_increment not null,
nome varchar(60),
email varchar(60),
cpf char(14)
) engine = innodb;

create table pedido(
codigopedido int primary key auto_increment not null,
datapedido timestamp,
statuspedido varchar(60)
) engine = innodb;

create table itempedido(
codigopedido int,
codigoproduto int,
precovenda decimal(10,2),
qtde int,
foreign key (codigopedido) references pedido(codigopedido),
foreign key (codigoproduto) references produto(codigoproduto)
) engine = innodb;

create table funcionario(
codigofuncionario int primary key auto_increment not null,
nome varchar(60),
funcao varchar(20),
cidade varchar(20)
) engine = innodb;

create table auditoria(
datamodificacao timestamp,
nometabela varchar(20),
historico varchar(60)
) engine = innodb;

delimiter $$

create trigger trg_produto_insert after insert on produto
for each row
begin
insert into auditoria values (now(),'produto',concat('insert ',new.nome));
end $$

create trigger trg_produto_update after update on produto
for each row
begin
insert into auditoria values (now(),'produto',concat('update ',new.nome));
end $$

create trigger trg_produto_delete after delete on produto
for each row
begin
insert into auditoria values (now(),'produto',concat('delete ',old.nome));
end $$

create trigger trg_cliente_insert after insert on cliente
for each row
begin
insert into auditoria values (now(),'cliente',concat('insert ',new.nome));
end $$

create trigger trg_cliente_update after update on cliente
for each row
begin
insert into auditoria values (now(),'cliente',concat('update ',new.nome));
end $$

create trigger trg_cliente_delete after delete on cliente
for each row
begin
insert into auditoria values (now(),'cliente',concat('delete ',old.nome));
end $$

create trigger trg_pedido_insert after insert on pedido
for each row
begin
insert into auditoria values (now(),'pedido',concat('insert pedido ',new.codigopedido));
end $$

create trigger trg_pedido_update after update on pedido
for each row
begin
insert into auditoria values (now(),'pedido',concat('update pedido ',new.codigopedido));
end $$

create trigger trg_pedido_delete after delete on pedido
for each row
begin
insert into auditoria values (now(),'pedido',concat('delete pedido ',old.codigopedido));
end $$

create trigger trg_itempedido_insert after insert on itempedido
for each row
begin
insert into auditoria values (now(),'itempedido',concat('insert pedido ',new.codigopedido));
end $$

create trigger trg_itempedido_update after update on itempedido
for each row
begin
insert into auditoria values (now(),'itempedido',concat('update pedido ',new.codigopedido));
end $$

create trigger trg_itempedido_delete after delete on itempedido
for each row
begin
insert into auditoria values (now(),'itempedido',concat('delete pedido ',old.codigopedido));
end $$

create trigger trg_funcionario_insert after insert on funcionario
for each row
begin
insert into auditoria values (now(),'funcionario',concat('insert ',new.nome));
end $$

create trigger trg_funcionario_update after update on funcionario
for each row
begin
insert into auditoria values (now(),'funcionario',concat('update ',new.nome));
end $$

create trigger trg_funcionario_delete after delete on funcionario
for each row
begin
insert into auditoria values (now(),'funcionario',concat('delete ',old.nome));
end $$

delimiter ;

delimiter $$

create procedure proc_inserir_produto(in p_nome varchar(60), in p_descricao varchar(200), in p_qtde int)
begin
insert into produto (nome,descricao,qtde_estoque) values (p_nome,p_descricao,p_qtde);
end $$

create procedure proc_inserir_cliente(in p_nome varchar(60), in p_email varchar(60), in p_cpf char(14))
begin
insert into cliente (nome,email,cpf) values (p_nome,p_email,p_cpf);
end $$

create procedure proc_inserir_funcionario(in p_nome varchar(60), in p_funcao varchar(20), in p_cidade varchar(20))
begin
insert into funcionario (nome,funcao,cidade) values (p_nome,p_funcao,p_cidade);
end $$

delimiter ;

set @json_carrinho = '{
"codigocliente": 1,
"codigofuncionario": 1,
"itens": [
{"codigoproduto": 1, "qtde": 2, "precovenda": 10.5},
{"codigoproduto": 2, "qtde": 1, "precovenda": 25.0}
]
}';

delimiter $$

create procedure proc_inserir_pedido_item(in p_json json)
begin
declare v_cliente int;
declare v_funcionario int;
declare v_itens int;
declare v_i int default 0;
declare v_prod int;
declare v_qtde int;
declare v_preco decimal(10,2);
declare v_pedido int;

set v_cliente = json_unquote(json_extract(p_json,'$.codigocliente'));
set v_funcionario = json_unquote(json_extract(p_json,'$.codigofuncionario'));
set v_itens = json_length(json_extract(p_json,'$.itens'));

start transaction;
insert into pedido (datapedido,statuspedido) values (now(),'aberto');
set v_pedido = last_insert_id();

while v_i < v_itens do
set v_prod = json_unquote(json_extract(p_json,concat('$.itens[',v_i,'].codigoproduto')));
set v_qtde = json_unquote(json_extract(p_json,concat('$.itens[',v_i,'].qtde')));
set v_preco = json_unquote(json_extract(p_json,concat('$.itens[',v_i,'].precovenda')));
insert into itempedido values (v_pedido,v_prod,v_preco,v_qtde);
update produto set qtde_estoque = qtde_estoque - v_qtde where codigoproduto = v_prod;
set v_i = v_i + 1;
end while;

commit;
select concat('pedido inserido ',v_pedido) as msg;
end $$

delimiter ;

create or replace view vw_produtos_mais_vendidos as
select
p.codigoproduto,
p.nome,
sum(i.qtde) as total_vendido
from produto p
inner join itempedido i on p.codigoproduto = i.codigoproduto
group by p.codigoproduto,p.nome
order by total_vendido desc;

select * from vw_produtos_mais_vendidos;
