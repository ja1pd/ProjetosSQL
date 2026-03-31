use classicmodels;

delimiter %
create procedure sp_make(in creme varchar(30), out resultado_final varchar(50), inout corretivo varchar(30))
begin

	select concat('Passar o creme ', creme,' e depois hidratar a pele') as result;

	set resultado_final = concat('Pele Hidratada! Usar o corretivo: ', corretivo);

	set corretivo = 'Escolha o próximo passo';

end%
delimiter ;

drop procedure sp_make;

set @corretivo = 'creamy';

call sp_make('Nivea', @rosto, @corretivo);	

select @rosto;
select @corretivo;