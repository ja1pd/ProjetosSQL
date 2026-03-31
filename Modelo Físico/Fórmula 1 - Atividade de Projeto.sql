CREATE DATABASE formulal;
USE formulal ;
CREATE TABLE gp (
codigo INT UNSIGNED NOT NULL,
circuito VARCHAR (60) NULL,
pais SMALLINT UNSIGNED NULL,
PRIMARY KEY (codigo)
);

CREATE TABLE equipe (
id INT UNSIGNED NOT NULL,
nome VARCHAR (60) NULL,
motor VARCHAR (60) NULL,
pais SMALLINT UNSIGNED NULL,
pontuacao MEDIUMINT UNSIGNED NULL,
PRIMARY KEY (id)
);

CREATE TABLE pais (
id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
nome VARCHAR (80) NULL,
sigla VARCHAR (5) NULL,
PRIMARY KEY (id)
);

CREATE TABLE pontuacao (
posicao TINYINT UNSIGNED NOT NULL,
pontos TINYINT UNSIGNED NULL, pontos2 TINYINT UNSIGNED NULL,
PRIMARY KEY (posicao)
) ;

CREATE TABLE piloto (
id INT UNSIGNED NOT NULL AUTO_INCREMENT,
nome VARCHAR (80) NULL, pais SMALLINT UNSIGNED NULL,
carro TINYINT UNSIGNED NULL,
PRIMARY KEY (id) 
);

CREATE TABLE campeonato (
pontuacao MEDIUMINT UNSIGNED NULL,
gp_codigo INT UNSIGNED NOT NULL,
equipe_id INT UNSIGNED NOT NULL,
PRIMARY KEY (gp_codigo, equipe_id),
FOREIGN KEY (gp_codigo) REFERENCES gp (codigo),
FOREIGN KEY (equipe_id) REFERENCES equipe (id)
);

CREATE TABLE classificacao ( 
gp_codigo INT UNSIGNED NOT NULL, 
piloto_id INT UNSIGNED NOT NULL, 
posicao TINYINT UNSIGNED NULL,
FOREIGN KEY (9P_codigo) REFERENCES gp (codigo),
FOREIGN KEY (piloto_id) REFERENCES piloto (id)
);

CREATE TABLE contrato (
piloto_id INT UNSIGNED NOT NULL, equipe_id INT UNSIGNED NOT NULL,
PRIMARY KEY (piloto_id, equipe_id),
FOREIGN KEY (piloto_id) REFERENCES piloto (id),
FOREIGN KEY (equipe_id) REFERENCES equipe (id)
);

CREATE TABLE carros(

equipe_id INT UNSIGNED NOT NULL,
numero TINYINT UNSIGNED NOT NULL,
FOREIGN KEY (equipe_id) REFERENCES equipe (id)
);
-- 4) Construa uma querie para:
-- Listar todos os países.
SELECT * FROM pais;

-- Listar o nome e a pontuação dos pilotos.
SELECT nome, pontuacao FROM piloto;

-- Listar as equipes e seus respectivos carros.
SELECT nome, numero
FROM equipe JOIN carros
ON equipe.id = carros.equipe_id;

-- Listar todos os dados dos pilotos com menos de 10 pontos.
SELECT * FROM pilotos
WHERE pontuacao < 10;

-- Inserir um novo pais.
INSERT INTO pais (id, nome, sigla)
VALUES (NULL, 'Brasil', 'BRA');

-- Apagar as pontuações acima do 10° lugar.
DELETE FROM pontuacao WHERE posicao > 10;

-- Calcular a média da potuação dos pilotos.
SELECT AVG (pontuacao) FROM piloto;

-- Contar quantos países existem no banco de dados.
SELECT COUNT(*) FROM pais;

-- Construa as seguintes Stored Procedures:
-- Listar todos os países.
DELIMITER |
CREATE PROCEDURE sp_lista_paises ()
BEGIN
SELECT*  FROM pais;
END ;
|
DELIMITER ; CALL sp_lista_paises();
-- Inserir um novo pais.
DELIMITER |
CREATE PROCEDURE sp_novo_pais (IN nomepais VARCHAR (80),
siglapais VARCHAR (5))
BEGIN
INSERT INTO pais (id, nome, sigla)
VALUES (NULL, nomepais,siglapais);
END;
|
DELIMITER;
CALL sp_novo_pais ('Brasil', 'BRA');
-- Alterar a pontuação do piloto 'Antônio José' para 20.
DELIMITER |
CREATE PROCEDURE sp_muda_pontos (IN pilotonome VARCHAR (80),
pilotopontos MEDIUMINT)
BEGIN
UPDATE piloto SET pontuacao = pilotopontos
WHERE nome = pilotonome;
END;
|
DELIMITER;
CALL sp_muda_pontos ('Antônio José', 20);
-- Antes de apagar um piloto, remover todos os seus contratos.
DELIMITER |
CREATE TRIGGER trg_del_piloto BEFORE DELETE ON piloto
FOR EACH ROW
BEGIN
DELETE FROM contrato
WHERE piloto_id = OLD. id;
END;
|
DELIMITER ;
DELETE FROM piloto WHERE id = 123;
-- Quando inserir uma nova equipe, cadastrar automaticamente o carro número Zero para ela.
DELIMITER |
CREATE TRIGGER trg_ins_equipe AFTER INSERT ON equipe
FOR EACH ROW
BEGIN
INSERT INTO carros (equipe_id, numero)
VALUES (NEW.id, 0);
END ;
|
DELIMITER ;
INSERT INTO equipe (id, nome, motor, pais, pontuação)
VALUES (NULL, 'Williams', 'Mercedes', 5, 0)
 