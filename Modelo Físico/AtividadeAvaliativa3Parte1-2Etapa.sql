USE classicmodels;

-- =====================
-- PARTE 1 - VIEWS, CTE E ANÁLISE DE ESTOQUE
-- =====================

-- Q1: View com produtos vendidos nos meses 1, 5 e 10 do ano 2003
CREATE OR REPLACE VIEW questao01 AS
SELECT
    productname AS produto,
    productcode AS codigoproduto,
    SUM(quantityordered) AS quantidade_comprada,
    SUM(priceeach * quantityordered) AS total_pago,
    customernumber AS codigocliente
FROM products
INNER JOIN orderdetails USING (productcode)
INNER JOIN orders USING (ordernumber)
WHERE YEAR(orderdate) = 2003
  AND MONTH(orderdate) IN (1,5,10)
GROUP BY produto;

-- Q2: Consulta usando CTE para filtrar cidades Tokyo e London
WITH cte_cliente(codigocliente, employeenumber) AS (
    SELECT customernumber, salesrepemployeenumber FROM customers
),
cte_empregado(employeenumber, officecode) AS (
    SELECT employeenumber, officecode FROM employees
),
cte_escritorio(officecode, cidade) AS (
    SELECT officecode, city FROM offices
)
SELECT produto, quantidade_comprada, total_pago
FROM questao01
INNER JOIN cte_cliente USING (codigocliente)
INNER JOIN cte_empregado USING (employeenumber)
INNER JOIN cte_escritorio USING (officecode)
WHERE cidade IN ('Tokyo','London');

-- Q3: Análise de estoque e criação de procedure corrigida
DROP TABLE IF EXISTS analise_estoque;
CREATE TABLE analise_estoque (
    codigoProduto VARCHAR(10),
    observacao VARCHAR(200)
) ENGINE = InnoDB;

DELIMITER $$
CREATE PROCEDURE questao03_3(IN param_ano INT)
BEGIN
    DECLARE total_registros INT DEFAULT 0;
    DECLARE contador INT DEFAULT 0;

    SELECT COUNT(DISTINCT productcode) INTO total_registros
    FROM products
    INNER JOIN orderdetails USING (productcode)
    INNER JOIN orders USING (ordernumber)
    WHERE YEAR(orderdate) = param_ano;

    REPEAT
        INSERT INTO analise_estoque
        SELECT productcode,
            CASE
                WHEN FORMAT((SUM(quantityordered) / (SUM(quantityordered) + quantityinstock)) * 100, 2) > 70
                    THEN 'Atenção: produto precisa ser reposto. Solicite ao fornecedor!'
                WHEN FORMAT((SUM(quantityordered) / (SUM(quantityordered) + quantityinstock)) * 100, 2) BETWEEN 60 AND 70
                    THEN 'O produto precisa ser reposto imediatamente! Contate o fornecedor!'
                ELSE 'Produto controlado'
            END AS observacao
        FROM products
        INNER JOIN orderdetails USING (productcode)
        INNER JOIN orders USING (ordernumber)
        WHERE YEAR(orderdate) = param_ano
        GROUP BY productcode
        LIMIT 1 OFFSET contador;

        SET contador = contador + 1;
    UNTIL contador >= total_registros END REPEAT;
END $$
DELIMITER ;
