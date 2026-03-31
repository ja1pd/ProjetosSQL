-- Questao 01

use sakila;

/*
a) Crie uma consulta que retorne o total de valores recebidos por país em cada uma das lojas nos meses 8 e 5 de 2005.
Calcule uma retirada de 25% do valor total recebido. 
Dica: 
● Lembre-se que todos os nomes das colunas devem estar em português. ● Funções úteis: Year(), Month(), Day(); 
● 25% -> 0.25 
*/

select 
  country as pais,
  store_id as loja,
  month(payment_date) as mes,
  sum(amount) as valorTotal,
  sum(amount) * 0.25 as retirada
from 
  payment
  inner join customer using (customer_id)
  inner join address using (address_id)
  inner join city using (city_id)
  inner join country using (country_id)
  inner join store using (store_id)
where 
  year(payment_date) = 2005
  and month(payment_date) in (5,8)
group by 
  country,
  store_id,
  month(payment_date)
order by
	country asc
;
/*
b) Crie um consulta para unificar as duas consultas abaixo: 
i) A quantidade de clientes, total de pagamentos por loja quando o meses de pagamento estiverem entre 5 e 8 de 2005, considerando apenas clientes ativos; (Cuidado para não fazer joins desnecessários) 
ii) A quantidade de clientes, total de pagamentos por loja quando a quantidade de países (Use distinct) for maior que 5. 
*/

-- i)
select 
  store_id as loja,
  count(distinct customer_id) as totalClientes,
  sum(amount) as totalPagamentos
from 
  payment
  inner join customer using (customer_id)
  inner join store using (store_id)
where 
  year(payment_date) = 2005
  and month(payment_date) between 5 and 8
  and active = 1
group by 
  store_id

union

-- ii)	
select 
  store_id as loja,
  count(distinct customer_id) as totalClientes,
  sum(amount) as totalPagamentos
from 
  payment
  inner join customer using (customer_id)
  inner join address using (address_id)
  inner join city using (city_id)
  inner join country using (country_id)
  inner join store using (store_id)
group by 
  store_id
having 
  count(distinct country) > 5;

-- c) Informe o total de pagamento recebidos por categoria, quando o filme tiver duração de aluguel (rental_duration) for igual a 3 ou 5 e tamanho (length) for maior que 100.
select 
  name as categoria,
  sum(amount) as totalPagamento
from 
  payment
  inner join rental using (rental_id)
  inner join inventory using (inventory_id)
  inner join film using (film_id)
  inner join film_category using (film_id)
  inner join category using (category_id)
where 
  rental_duration in (3, 5)
  and length > 100
group by 
  name;
  
-- d) Crie o modelo físico para a representação lógica demonstrada abaixo das tabelas Desafio e Regras. Considere que a chave estrangeira terá restrição de exclusão.
create table desafio (
  id_desafio int primary key auto_increment,
  nome varchar(100) not null
);

create table regra (
  id_regra int primary key auto_increment,
  descricao varchar(255) not null,
  id_desafio int not null,
  foreign key (id_desafio) references desafio(id_desafio)
    on delete restrict
);

-- Questao 02

use world;
-- Utilizando a base de dados World faça uma consulta que retorne o total de pessoas falantes por idioma e por país do continente Asiático (Asia). 
/*
Dica: 
Somatório(Percentual * População)/100 -> total de pessoas falantes. 
● CountryLanguage (Tabela) | Percentage 
● Country (tabela) | Population
*/

desc country;
 desc countrylanguage;
select 
  name as pais,
  language as idioma,
  population * percentage / 100 as total_falantes
from 
  country
  inner join countrylanguage on country.code = countrylanguage.countrycode
where 
  country.continent = 'Asia'
order by 
  name asc;
