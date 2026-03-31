create database clinica_enfermagem;
use clinica_enfermagem;   

create table clinicas(
id_clinica int not null auto_increment primary key,
nome_clinica varchar(150)not null,
rua varchar(150)not null,
cidade varchar(150)not null,
bairro varchar(150)not null,
uf varchar(150)not null,
numero varchar(150)not null,
telefone char(12)not null
);

create table medico(
id_medico int not null auto_increment primary key,
nome_medico varchar(150)not null,
especialidade varchar(150)not null,
rua varchar(150)not null,
cidade varchar(150)not null,
bairro varchar(150)not null,
uf varchar(150)not null,
numero varchar(150)not null,
telefone char(12)not null,
cpf char(13)not null,
nome_clinica varchar(150)not null,
foreign key (nome_clinica) references clinicas (nome_clinica)
);

create table consulta(
id_consulta int not null auto_increment primary key,
hora_entrada time not null,
hora_saida time not null,
data_consulta date not null,
nome_medico varchar(150)not null,
foreign key (nome_medico) references medico (nome_medico)
);

create table pacientes(
id_paciente int not null auto_increment primary key,
nome_paciente varchar(150)not null,
rua varchar(150)not null,
cidade varchar(150)not null,
bairro varchar(150)not null,
uf varchar(150)not null,
numero varchar(150)not null,
telefone char(12)not null,
cpf char(13)not null,
id_consulta int not null,
foreign key (id_consulta) references consulta (id_consulta)
);

create table prescricao(
id_prescricao int not null auto_increment primary key,
medicamento varchar(150) not null,
tratamento varchar(150) not null,
retorno date,
nome_medico varchar(150)not null,
foreign key (nome_medico) references medico (nome_medico)
);
 																																								

