-- Preparatoria 3

###############################################################
#                    QUESTÃO 1 – A
###############################################################
-- Criar uma VIEW para retornar:
-- NomeAluno, NomeDisciplina, ano, nomeSituacao e nomeDepartamento

CREATE VIEW vw_info_cotemig AS
SELECT 
    A.nomeAluno,
    D.nomeDisciplina,
    M.ano,
    S.nomeSituacao,
    Dep.nomeDepartamento
FROM Matricula_Aluno M
JOIN Aluno A ON M.codigoAlunoMatricula = A.codigoAluno
JOIN Disciplina D ON M.codigoDisciplinaMatricula = D.codigoDisciplina
JOIN Situacao S ON M.situacaoMatricula = S.codigoSituacao
JOIN Departamento Dep ON D.codigoDepartamentoDisciplina = Dep.codigoDepartamento;


###############################################################
#                    QUESTÃO 1 – B
###############################################################
-- Criar uma VIEW para retornar:
-- A quantidade de alunos existente em cada ano por situação

CREATE VIEW vw_qtd_alunos_ano_situacao AS
SELECT 
    ano,
    situacaoMatricula,
    COUNT(*) AS quantidade
FROM Matricula_Aluno
GROUP BY ano, situacaoMatricula;


###############################################################
#                    QUESTÃO 1 – C
###############################################################
-- Criar uma TABELA baseada em uma consulta que retorna:
-- Quantidade de disciplinas existente por departamento

CREATE TABLE qtd_disc_por_departamento AS
SELECT 
    codigoDepartamentoDisciplina AS departamento,
    COUNT(*) AS qtd_disciplinas
FROM Disciplina
GROUP BY codigoDepartamentoDisciplina;


###############################################################
#                    QUESTÃO 1 – D
###############################################################
-- Criar a tabela RECUPERACAO com campos:
-- codigoAlunoRecuperacao, codigoDisciplinaRecuperacao, nota

CREATE TABLE recuperacao (
    codigoAlunoRecuperacao INT,
    codigoDisciplinaRecuperacao INT,
    nota DECIMAL(5,2),
    FOREIGN KEY(codigoAlunoRecuperacao) REFERENCES Aluno(codigoAluno),
    FOREIGN KEY(codigoDisciplinaRecuperacao) REFERENCES Disciplina(codigoDisciplina)
);


###############################################################
#                    QUESTÃO 1 – E
###############################################################
-- Criar tabela LOG_RECUPERACAO com:
-- idLog, descricao, data

CREATE TABLE log_recuperacao (
    idLog INT AUTO_INCREMENT PRIMARY KEY,
    descricao TEXT,
    data TIMESTAMP
);


###############################################################
#             QUESTÃO 1 – F – I (Trigger BEFORE INSERT)
###############################################################
-- Criar TRIGGER BEFORE INSERT na tabela RECUPERACAO
-- Registrar: “Foi incluído na recuperação: NomeAluno – para a disciplina: NomeDisciplina”

DELIMITER $$

CREATE TRIGGER trg_recuperacao_before_insert
BEFORE INSERT ON recuperacao
FOR EACH ROW
BEGIN
    DECLARE nomeAluno VARCHAR(100);
    DECLARE nomeDisc VARCHAR(100);

    SELECT nomeAluno INTO nomeAluno 
    FROM Aluno WHERE codigoAluno = NEW.codigoAlunoRecuperacao;

    SELECT nomeDisciplina INTO nomeDisc
    FROM Disciplina WHERE codigoDisciplina = NEW.codigoDisciplinaRecuperacao;

    INSERT INTO log_recuperacao(descricao, data)
    VALUES (
        CONCAT('Foi incluído na recuperação: ', nomeAluno,
               ' - para a disciplina: ', nomeDisc),
        CURRENT_TIMESTAMP()
    );
END$$



###############################################################
#            QUESTÃO 1 – F – II (Trigger AFTER UPDATE)
###############################################################
-- Criar TRIGGER AFTER UPDATE para registrar alteração da nota

CREATE TRIGGER trg_recuperacao_after_update
AFTER UPDATE ON recuperacao
FOR EACH ROW
BEGIN
    DECLARE nomeAluno VARCHAR(100);

    SELECT nomeAluno INTO nomeAluno
    FROM Aluno WHERE codigoAluno = NEW.codigoAlunoRecuperacao;

    INSERT INTO log_recuperacao(descricao, data)
    VALUES (
        CONCAT('Foi alterada a nota do aluno: ', nomeAluno,
               ' - nota antiga: ', OLD.nota,
               ' - nota nova: ', NEW.nota),
        CURRENT_TIMESTAMP()
    );
END$$



###############################################################
#            QUESTÃO 1 – F – III (Trigger AFTER DELETE)
###############################################################
-- Criar TRIGGER AFTER DELETE na tabela MATRICULA_ALUNO
-- Registrar: “A disciplina X foi excluída”

CREATE TRIGGER trg_matricula_delete
AFTER DELETE ON Matricula_Aluno
FOR EACH ROW
BEGIN
    DECLARE nomeDisc VARCHAR(100);

    SELECT nomeDisciplina INTO nomeDisc
    FROM Disciplina WHERE codigoDisciplina = OLD.codigoDisciplinaMatricula;

    INSERT INTO log_recuperacao(descricao, data)
    VALUES (
        CONCAT('A disciplina: ', nomeDisc, ' - foi excluída'),
        CURRENT_TIMESTAMP()
    );
END$$

DELIMITER ;



###############################################################
#                    QUESTÃO 1 – G
###############################################################
-- Criar PROCEDURE com CURSOR para incluir alunos em recuperação:
-- codigoAlunoRecuperacao = codigoAlunoMatricula
-- codigoDisciplinaRecuperacao = codigoDisciplinaMatricula
-- nota = NULL

DELIMITER $$

CREATE PROCEDURE incluir_recuperacao()
BEGIN
    DECLARE vAluno INT;
    DECLARE vDisc INT;
    DECLARE fim INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT codigoAlunoMatricula, codigoDisciplinaMatricula
        FROM Matricula_Aluno
        WHERE situacaoMatricula = 2;  -- Exemplo: 2 = recuperação

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim = 1;

    OPEN cur;

    loop_cursor: LOOP
        FETCH cur INTO vAluno, vDisc;

        IF fim = 1 THEN
            LEAVE loop_cursor;
        END IF;

        INSERT INTO recuperacao VALUES (vAluno, vDisc, NULL);
    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;



###############################################################
#                    QUESTÃO 1 – H
###############################################################
-- Criar FUNÇÃO:
-- Se nota >= 60 → "Aprovado - Boas Férias"
-- Se nota < 60 → "Ainda há mais uma chance! Bora estudar"

DELIMITER $$

CREATE FUNCTION fn_avaliar_nota(notaAluno INT)
RETURNS VARCHAR(50)
BEGIN
    IF notaAluno >= 60 THEN
        RETURN 'Aprovado - Boas Férias';
    ELSE
        RETURN 'Ainda há mais uma chance! Bora estudar';
    END IF;
END$$

DELIMITER ;



###############################################################
#                    QUESTÃO 1 – I
###############################################################
-- Criar PROCEDURE para excluir matrículas de um ano informado

DELIMITER $$

CREATE PROCEDURE excluir_matriculas_por_ano(IN anoEntrada INT)
BEGIN
    DELETE FROM Matricula_Aluno
    WHERE ano = anoEntrada;
END$$

DELIMITER ;

-- Preparatoria 4

use classicmodels;

###############################################################
#                  QUESTÃO ÚNICA – A
###############################################################
-- Criar VIEW com:
-- customerNumber, creditLimit, totalPago, saldo (creditlimit - totalPago)

CREATE OR REPLACE VIEW vw_financeiro_clientes AS
SELECT 
    C.customerNumber,
    C.creditLimit,
    IFNULL(SUM(P.amount), 0) AS totalPago,
    (C.creditLimit - IFNULL(SUM(P.amount), 0)) AS saldo
FROM customers C
LEFT JOIN payments P ON C.customerNumber = P.customerNumber
GROUP BY C.customerNumber, C.creditLimit;


###############################################################
#                  QUESTÃO ÚNICA – B
###############################################################
-- Criar tabela baseada na VIEW acima

CREATE TABLE tabela_financeiro AS
SELECT *
FROM vw_financeiro_clientes;


###############################################################
#                  QUESTÃO ÚNICA – C
###############################################################
-- Criar tabela de auditoria para monitorar alterações:
-- campos: id, descricao, dataModificacao

CREATE TABLE auditoria_financeiro (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descricao TEXT,
    dataModificacao TIMESTAMP
);


###############################################################
#                  QUESTÃO ÚNICA – D
###############################################################
-- Alterar tabela criada na letra B:
-- Incluir campos JURO e MONTANTE

ALTER TABLE tabela_financeiro
ADD COLUMN juro DECIMAL(10,2) NULL,
ADD COLUMN montante DECIMAL(10,2) NULL;


###############################################################
#                  QUESTÃO ÚNICA – E
###############################################################
-- Criar TRIGGER para disparar em alterações da tabela da letra B
-- Registrar dados na tabela de auditoria

DELIMITER $$

CREATE TRIGGER trg_financeiro_update
AFTER UPDATE ON tabela_financeiro
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_financeiro(descricao, dataModificacao)
    VALUES (
        CONCAT('Alteração realizada para o cliente ', NEW.customerNumber,
               ' | Novo Juro: ', NEW.juro,
               ' | Novo Montante: ', NEW.montante),
        CURRENT_TIMESTAMP()
    );
END$$

DELIMITER ;


###############################################################
#                  QUESTÃO ÚNICA – F
###############################################################
-- Criar FUNÇÃO para cálculo de juros simples:
-- J = C * T * I

DELIMITER $$

CREATE FUNCTION fn_juros_simples(capital DECIMAL(10,2), taxa DECIMAL(10,2), periodo INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN capital * taxa * periodo;
END$$

DELIMITER ;


###############################################################
#                  QUESTÃO ÚNICA – G
###############################################################
-- Criar PROCEDURE conforme instruções:
-- Parâmetros: taxa (decimal), periodo (int)
-- Cursor baseado na tabela da letra B
-- Atualizar JURO e MONTANTE para saldos negativos
-- Realizar transação

DELIMITER $$

CREATE PROCEDURE pr_calcular_juros(
    IN p_taxa DECIMAL(10,4),
    IN p_periodo INT
)
BEGIN
    DECLARE v_customerNumber INT;
    DECLARE v_creditLimit DECIMAL(10,2);
    DECLARE v_totalPago DECIMAL(10,2);
    DECLARE v_saldo DECIMAL(10,2);
    DECLARE fim INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT customerNumber, creditLimit, totalPago, saldo
        FROM tabela_financeiro;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim = 1;

    START TRANSACTION;

    OPEN cur;

    loop_clientes: LOOP

        FETCH cur INTO v_customerNumber, v_creditLimit, v_totalPago, v_saldo;

        IF fim = 1 THEN
            LEAVE loop_clientes;
        END IF;

        -- Apenas clientes com saldo negativo
        IF v_saldo < 0 THEN

            -- Cálculo do juro (função criada)
            SET @juros := fn_juros_simples(v_saldo, p_taxa, p_periodo);

            -- Montante = juros + saldo
            SET @montante := @juros + v_saldo;

            -- Atualizar tabela
            UPDATE tabela_financeiro
            SET 
                juro = @juros,
                montante = @montante
            WHERE customerNumber = v_customerNumber;

        END IF;

    END LOOP;

    CLOSE cur;

    COMMIT;
END$$

DELIMITER ;


###############################################################
#                  QUESTÃO ÚNICA – H
###############################################################
-- Executar a procedure criada e validar resultados

CALL pr_calcular_juros(0.05, 2);
-- Exemplo: taxa de juros 5% e período 2 meses

-- Verificar resultados:
SELECT * FROM tabela_financeiro;
SELECT * FROM auditoria_financeiro;
