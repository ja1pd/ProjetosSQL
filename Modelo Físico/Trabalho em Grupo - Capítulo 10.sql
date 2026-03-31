create database AgenciaTurismo;
use AgenciaTurismo;

create table clientes(
id_clientes INT not null primary key auto_increment,
nome VARCHAR(70),
cpf CHAR(11),
email VARCHAR(65),
vendedor_id INT,
foreign key (vendedor_id) references vendedor (id) 
);

create table pacotes(
id_pacotes INT not null primary key auto_increment,
destino VARCHAR(100),
horario TIME,
transporte VARCHAR(20),
descricao VARCHAR(200),
data DATE,
preco DOUBLE,
mpagamento VARCHAR(25)
);

create table vendedor(
id INT not null primary key auto_increment,
telefone CHAR(13),
nome VARCHAR(70),
email VARCHAR(65)
);

INSERT INTO vendedor (telefone, nome, email)
VALUES 	('5531123456788', 'joao', 'joao@jao.com'),
		('5531987654321', 'Carlos Silva', 'carlos.silva@example.com'),
		('5531998765432', 'Ana Santos', 'ana.santos@example.com'),
		('5531991256798', 'João Pereira', 'joao.pereira@example.com'),
		('5531996543210', 'Maria Oliveira', 'maria.oliveira@example.com'),
		('5531993456789', 'Pedro Souza', 'pedro.souza@example.com'),
		('5531997654321', 'Beatriz Mendes', 'beatriz.mendes@example.com'),
		('5531995432109', 'Paulo Almeida', 'paulo.almeida@example.com'),
		('5531992345678', 'Fernanda Costa', 'fernanda.costa@example.com'),
		('5531994321567', 'Luiz Ramos', 'luiz.ramos@example.com'),
		('5531993214567', 'Julia Castro', 'julia.castro@example.com');

INSERT INTO clientes (nome, cpf, email, vendedor_id) 
VALUES  ('Lucas Andrade', '12345678901', 'lucas.andrade@gmail.com', 2),
		('Mariana Souza', '23456789012', 'mariana.souza@gmail.com', 2),
		('Roberto Lima', '34567890123', 'roberto.lima@gmail.com', 2),
		('Fernanda Silva', '45678901234', 'fernanda.silva@gmail.com', 7),
		('Gabriela Mendes', '56789012345', 'gabriela.mendes@gmail.com', 5),
		('Ricardo Alves', '67890123456', 'ricardo.alves@gmail.com', 6),
		('Amanda Costa', '78901234567', 'amanda.costa@gmail.com', 1),
		('Juliana Ferreira', '89012345678', 'juliana.ferreira@gmail.com', 1),
		('Paulo Santos', '90123456789', 'paulo.santos@gmail.com', 9),
		('Renata Castro', '01234567890', 'renata.castro@gmail.com', 10);

INSERT INTO pacotes (destino, horario, transporte, descricao, data, preco, mpagamento)
VALUES  ('Rio de Janeiro', '08:00:00', 'Avião', 'Pacote de 5 dias com hospedagem inclusa', '2024-12-20', 3200.00, 'Cartão de Crédito'),
		('Salvador', '10:30:00', 'Ônibus', 'Pacote de 3 dias com passeios culturais', '2025-01-15', 1800.00, 'Boleto Bancário'),
		('Fernando de Noronha', '09:00:00', 'Avião', 'Pacote de 7 dias com mergulho incluso', '2024-11-10', 7200.00, 'Transferência Bancária'),
		('Gramado', '06:00:00', 'Ônibus', 'Pacote de 4 dias com tour pelas vinícolas', '2024-12-05', 2500.00, 'Cartão de Crédito'),
		('Fortaleza', '14:00:00', 'Avião', 'Pacote de 6 dias com passeios de buggy nas dunas', '2024-11-25', 4100.00, 'Pix');

select * from vendedor;
select * from pacotes;
select * from clientes;
select * from vendedor where nome like 'j%';
select nome,clientes.nome from vendedor join clientes on clientes.id_cli = vendas.id_cli group by clientes.id_cli; 
select clientes.nome, clientes.email, vendedor.nome as nome_do_vendedor, vendedor.id from clientes inner join vendedor on clientes.vendedor_id = vendedor.id order by vendedor.id;
