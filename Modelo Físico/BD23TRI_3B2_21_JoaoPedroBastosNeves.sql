use classicmodels;


##################################################################### Questao A #####################################################################

create view ProvaBQuestaoA as
select 
    productcode,
    sum(quantityordered),
	avg(priceeach),
    buyprice
from 
	products
inner join 
		orderdetails using(productcode)
group by
	productcode
;

select * from ProvaBQuestaoA;


##################################################################### Questao B #####################################################################

create table ProvaBQuestaoB as
select 
	*
from
	ProvaBQuestaoA
;

select 
	*
from
	ProvaBQuestaoB
;

##################################################################### Questao C #####################################################################

create table auditoria(
	Id varchar(15) primary key,
    Descricao text,
    dataModificacao timestamp
)engine = InnoDB;

drop table auditoria;


##################################################################### Questao D #####################################################################

alter table ProvaBQuestaoB
add column Lucro_Esperado decimal(10,2) null,
add column Observacao decimal(10,2) null;

##################################################################### Questao E #####################################################################

delimiter $$

CREATE TRIGGER ProvaBQuestaoE
AFTER UPDATE ON ProvaBQuestaoB
FOR EACH ROW
BEGIN
    INSERT INTO auditoria(id, descricao, dataModificacao)
    VALUES (
		productcode,
        CONCAT('Alteração realizada no produto ', new.productcode,
               ' | Novo Preço de compra: ', new.buyprice),
        CURRENT_TIMESTAMP()
    );
end$$

delimiter ;

drop trigger ProvaBQuestaoE;

##################################################################### Questao F #####################################################################


DELIMITER $$

CREATE FUNCTION ProvaBQuestaoF(preco_compra DECIMAL(10,2), preco_medio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
BEGIN
    RETURN preco_medio - preco_compra;
END$$

DELIMITER ;

drop function ProvaBQuestaoF;

##################################################################### Questao G #####################################################################
