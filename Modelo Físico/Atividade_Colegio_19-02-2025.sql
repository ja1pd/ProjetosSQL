create database colegio;
use colegio;

create table aluno(
id_aluno int not null auto_increment primary key,
nome varchar(200),
idade int
) engine = InnoDB;

create table disciplina(
id_disciplina int not null auto_increment primary key,
nome varchar(200)
)engine = InnoDB; 

create table aluno_disciplina(
fk_aluno int not null,
fk_disciplina int not null,
ano int,

foreign key (fk_aluno) references aluno (id_aluno) on delete restrict,
foreign key (fk_disciplina) references disciplina (id_disciplina) on delete cascade

) engine = InnoDB;

insert into aluno (id_aluno, nome, idade) values (default, 'Bernardo',100);
insert into disciplina (id_disciplina, nome) values (default, 'Matematica');
insert into disciplina (id_disciplina, nome) values (default, 'BD2');

insert into aluno_disciplina (fk_aluno, fk_disciplina, ano) values (1, 1, 2022);
insert into aluno_disciplina (fk_aluno, fk_disciplina, ano) values (1, 2, 2023);

delete from aluno where id_aluno = 1;
delete from disciplina where id_disciplina = 1;
delete from aluno_disciplina where fk_aluno = 1;

alter table disciplina add column status int default 0;

select * from aluno;
select * from disciplina;
select * from aluno_disciplina;


#drop database colegio;