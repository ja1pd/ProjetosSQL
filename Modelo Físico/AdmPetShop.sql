create database AdmPetShop;
use AdmPetShop;

create table cliente (
id int not null,
cpf int not null,
nome_completo varchar(150) not null,
uf varchar(100) not null,
cidade varchar(65) not null,
bairro varchar(60) not null,
rua varchar(60) not null,
numero smallint not null,
complemento varchar(20) not null,
cep char(9) not null,
email varchar(200) not null,
celular varchar(20) not null
);

create table animal(
tipo_animal varchar(20) not null,
nome_animal varchar(100) not null,
cliente_id int not null,
dono varchar(100) not null,
sexo char(1) not null,
data_nascimento date not null,
raça varchar(150) not null
);

create table serviço(
id int not null,
descricao varchar(500) not null,
valor int not null,
tempo_servico time not null
);
