/* ==========================================
   RESUMO DE COMANDOS SQL - PROVA DE BD (COM EXPLICAÇÃO DETALHADA)
   ========================================== */

/* =====================
   CONCEITOS IMPORTANTES
   =====================
VIEW: Uma view é uma "tabela virtual" criada a partir de uma consulta SQL. Não armazena dados fisicamente (salvo quando é materializada), mas facilita consultas complexas e reutilização.
- CREATE OR REPLACE VIEW: cria ou substitui uma view.
- Útil para simplificar relatórios e manter a lógica de consulta centralizada.

PROCEDURE: Uma procedure é um bloco de código armazenado no banco, que pode ser chamado para executar tarefas complexas.
- Suporta variáveis, loops, condições.
- Pode receber parâmetros (IN, OUT, INOUT).
- Usada para automatizar processos, cálculos ou manipulação de dados.

CTE (Common Table Expression): Uma CTE é uma expressão temporária que age como uma tabela virtual para consultas complexas.
- Sintaxe: WITH nomeCTE AS (consulta)
- Permite dividir consultas em partes mais legíveis e reutilizáveis.
*/

/* =====================
   QUESTÃO A - CLASSICMODELS
   =====================
Objetivo: Criar uma VIEW mostrando empregados subordinados a 1102, com vendas de 2003.
*/

/*
VIEW
Uma view é uma tabela virtual derivada de uma consulta SQL. Ela não armazena dados fisicamente (exceto as views materializadas).
Serve para simplificar consultas complexas, facilitar relatórios e garantir que a lógica de consulta fique centralizada num único lugar.
Comando básico:
sql
CREATE OR REPLACE VIEW nome_view AS
SELECT colunas FROM tabelas WHERE condições;
Pode ser usada para juntar dados complexos, agregar ou filtrar informações específicas.

PROCEDURE (Procedure Armazenada)
Um procedure é um bloco de código SQL armazenado no banco, que pode conter múltiplos comandos, variáveis, loops e condições lógicas.
Pode receber parâmetros de entrada (IN), saída (OUT) ou ambos (INOUT).
Serve para automatizar tarefas como cálculos, análises, manipulação complexa de dados.
Exemplo sintaxe básica:
sql
DELIMITER $$
CREATE PROCEDURE nome_procedure(parâmetros)
BEGIN
    -- instruções SQL complexas
END$$
DELIMITER ;
Para executar: CALL nome_procedure();

CTE (Common Table Expression)
Uma CTE é uma expressão temporária que funciona como uma tabela virtual dentro de uma consulta SQL.
Sintaxe para facilitar consultas legíveis e reutilizar subconsultas:
sql
WITH cte_nome AS (SELECT ...)
SELECT * FROM cte_nome WHERE ...;


Exemplos do Arquivo SQL (explicação de cada questão)
Questão A - VIEW empregados subordinados a 1102 com vendas de 2003
Cria uma view para listar empregados que respondem ao gerente com ID 1102 e que realizaram vendas no ano de 2003, mostrando nome, quantidade de pedidos, faturamento e total de produtos vendidos.

Questão B - VIEW produtos não vendidos
Lista todos os produtos que não tiveram nenhum pedido. Usa LEFT JOIN entre produtos e orderdetails, com filtro para ordernumber IS NULL.

Questão C - PROCEDURE análise de lucro
Uma view cria um conjunto com produtos, preço de venda e preço de fábrica (MSRP) no ano de 2004.
Uma tabela chamada ANALISE_DE_VENDA é criada para armazenar observações sobre o lucro.
A procedure percentual_lucro_produto percorre cada produto da view, calcula a margem e insere um comentário na tabela, com uma lógica condicional para alertas.
Exemplo típico de uso de variáveis, laço REPEAT, controle de fluxo e inserção de resultados.

Questão D - PROCEDURE filmes por categoria na loja (Sakila)
Procedure parametrizada que recebe o ID de uma loja e retorna a quantidade de filmes por categoria naquela loja.

Questão E - Tabela de países da América do Norte que falam português
Cria uma tabela com países da América do Norte cujo idioma é português, calculando a quantidade de falantes baseada na população e percentual falante, agrupando por país.

Exemplo de CTE
Uso de duas CTEs para facilitar leitura e divisão de subconsultas: uma para produtos, outra para itens de pedido, e combinação dos dados para exibir nome do produto, quantidade e preço.
Conteúdo dos Vídeos Indicados (adaptado e resumido)
O que são views e como criar/utilizar views no SQL
As views são usadas para criar consultas reutilizáveis que facilitam a leitura e reduzem a repetição de código.
Views funcionam como tabelas virtuais: não armazenam dados, apenas armazenam a consulta.
São importantes para manter segurança porque você pode limitar o acesso aos dados reais.
Exemplo prático de criação de view para juntar dados e apresentar resultados consolidados.
Introdução ao conceito de procedures
Procedimentos armazenados são usados para automatizar rotinas mais complexas.
Podem receber parâmetros para flexibilizar o comportamento da rotina.
Exemplo mostrava um procedimento simples que retorna listas de dados e como executar uma procedure.
Destaca o uso de variáveis e estruturas condicionais dentro da procedure para análises ou atualizações.
Exemplos práticos de uso de procedures e views em bancos de dados comerciais
Demonstração de criação de procedures com parâmetros de entrada e saída.
Estudo de caso para análise de vendas e margens de lucro com manipulação de dados em tabelas temporárias e views.
Uso avançado de CTEs para consultas complexas
Explicação detalhada de como dividir uma consulta complexa em partes menores com CTEs.
Melhora a legibilidade e manutenção do código SQL, facilitando o debug e expansão.
Como integrar views, procedures e CTEs para relatórios eficientes
Demonstra que o uso integrado dessas tecnologias no SQL permite criar sistemas robustos e com alta performance.
Exemplos de relatórios dinâmicos que utilizam views como bases, procedures para lógica e CTEs para fragmentar consultas.
*/

CREATE OR REPLACE VIEW questao1 AS
SELECT 
  CONCAT(firstname, ' ', lastname) AS nome_empregado, -- CONCAT: junta firstname + lastname em uma string
  COUNT(ordernumber) AS quantidade_pedido,            -- COUNT: conta o número de pedidos por empregado
  SUM(priceEach * quantityOrdered) AS faturamento,    -- SUM: soma o valor total (preço x quantidade)
  SUM(quantityOrdered) AS total_produto               -- Soma quantidade total de produtos vendidos
FROM orderdetails 
INNER JOIN orders USING (ordernumber)                 -- INNER JOIN: junta detalhes do pedido com a tabela orders pelo ordernumber
INNER JOIN customers USING (customernumber)           -- Junta com clientes usando customernumber
INNER JOIN employees ON (salesRepEmployeeNumber = employeeNumber) -- Junta com empregados pelo código do vendedor
WHERE reportsTo = 1102                                -- Filtra empregados que reportam ao gerente 1102
  AND YEAR(orderdate) = 2003                          -- Filtra pedidos do ano 2003
GROUP BY nome_empregado;                              -- Agrupa por empregado para aplicar SUM e COUNT corretamente

/* =====================
   QUESTÃO B - PRODUTOS NÃO VENDIDOS
   =====================
Objetivo: Encontrar produtos que nunca foram vendidos.
*/
CREATE OR REPLACE VIEW questao2 AS
SELECT 
  productname,                                        -- Nome do produto
  productcode                                         -- Código do produto
FROM products 
LEFT JOIN orderdetails USING (productcode)            -- LEFT JOIN: traz todos os produtos e combina com pedidos se houver
WHERE ordernumber IS NULL;                            -- Condição: só pega produtos que não têm pedido (ordernumber nulo)

/* =====================
   QUESTÃO C - PROCEDURE DE ANÁLISE DE LUCRO
   =====================
Objetivo: Comparar preço de venda com preço de fábrica e gerar alertas.
*/
CREATE OR REPLACE VIEW questao3_1 (produto, precovenda, precofabrica) AS
SELECT 
  productcode,                                        -- Código do produto
  priceEach,                                          -- Preço de venda
  MSRP                                                -- Preço sugerido (fábrica)
FROM products
INNER JOIN orderdetails USING (productcode)
INNER JOIN orders USING (ordernumber)
WHERE YEAR(orderdate) = 2004;                         -- Filtra pedidos do ano 2004

CREATE TABLE ANALISE_DE_VENDA (
  CodigoProduto VARCHAR(10),                          -- Código do produto
  OBSERVACAO VARCHAR(300)                             -- Texto da análise
) ENGINE = InnoDB;

DELIMITER $
CREATE PROCEDURE percentual_lucro_produto()           -- PROCEDURE: rotina armazenada para gerar análise de lucro
BEGIN
  DECLARE total_registros INT DEFAULT 0;             -- Declara variável para total de registros
  DECLARE contador INT DEFAULT 0;                    -- Variável para iterar
  DECLARE var_produto VARCHAR(10);                   -- Armazena produto atual
  DECLARE var_analise VARCHAR(300);                  -- Armazena observação

  SELECT IFNULL(COUNT(*),0) INTO total_registros FROM questao3_1; -- Conta total de produtos para o loop

  REPEAT                                              -- Início do loop
    SELECT produto,
      CASE                                            -- CASE: condições para definir mensagem
        WHEN FORMAT((1-(PRECOVENDA/PRECOFABRICA))*100,2) < 5 THEN 'Produto com margem próxima do sugerido'
        WHEN FORMAT((1-(PRECOVENDA/PRECOFABRICA))*100,2) BETWEEN 5 AND 10 THEN 'Produto está saindo da margem sugerida!'
        ELSE 'Revendedores fiquem atentos aos valores negociados!'
      END
    INTO var_produto, var_analise
    FROM questao3_1
    LIMIT 1 OFFSET contador;                          -- OFFSET: pega linha específica baseada no contador

    INSERT INTO ANALISE_DE_VENDA VALUES (var_produto, var_analise); -- Insere resultado
    SET contador = contador + 1;                      -- Incrementa contador
  UNTIL contador >= total_registros                   -- Condição de parada
  END REPEAT;
END$
DELIMITER ;

CALL percentual_lucro_produto();                      -- Executa procedure

/* =====================
   QUESTÃO D - SAKILA
   =====================
Objetivo: Listar quantidade de filmes por categoria em uma loja.
*/
DELIMITER $
CREATE PROCEDURE film_categoria_loja (IN param_store_id INT) -- IN: parâmetro de entrada
BEGIN
  SELECT 
    category.name AS categoria,                      -- Nome da categoria
    COUNT(inventory_id) AS qtde_filme               -- Quantidade de filmes
  FROM category
  INNER JOIN film_category USING (category_id)
  INNER JOIN film USING (film_id)
  INNER JOIN inventory USING (film_id)
  WHERE store_id = param_store_id                    -- Filtra pela loja informada
  GROUP BY category.name;                            -- Agrupa por categoria
END$
DELIMITER ;

/* =====================
   QUESTÃO E - WORLD
   =====================
Objetivo: Criar tabela com países da América do Norte que falam português.
*/
CREATE TABLE faltantes_portugues_northAmerica AS
SELECT 
  name AS pais,                                       -- Nome do país
  FORMAT(SUM(percentage * population)/100,2) AS falantes, -- Calcula falantes de português (população * %) / 100
  region AS regiao                                    -- Região
FROM country
INNER JOIN countryLanguage ON code = countrycode
WHERE language = 'portuguese'
  AND Region = 'North America'                        -- Filtro para América do Norte
GROUP BY pais;                                        -- Agrupa por país

/* =====================
   EXEMPLO DE CTE
   =====================
Objetivo: Usar CTE para unir produtos e itens de pedidos.
*/
WITH cte_produto AS (
  SELECT productcode, productname FROM products        -- CTE 1: lista de produtos
), cte_itemProduto AS (
  SELECT productcode, quantityordered, priceEach FROM orderdetails -- CTE 2: itens de pedido
)
SELECT productname, quantityOrdered, priceEach
FROM cte_produto
INNER JOIN cte_itemProduto USING (productcode);       -- Junta as duas CTEs pelo código do produto

-- =========================================
-- QUESTÃO 1A
-- =========================================

-- Prova 1 (Final 5 - A)
CREATE VIEW vw_faturamento_empregados AS
SELECT o.officeCode,
       SUM(p.amount) AS total_recebido,
       COUNT(DISTINCT e.employeeNumber) AS qtd_empregados
FROM employees e
JOIN offices o ON e.officeCode = o.officeCode
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN payments p ON c.customerNumber = p.customerNumber
JOIN orders ord ON c.customerNumber = ord.customerNumber
WHERE o.country = 'USA'
  AND ord.orderDate BETWEEN '2004-04-01' AND '2004-06-30'
GROUP BY o.officeCode;

-- Prova 2 (Final 6 - B)
CREATE VIEW vw_faturamento_empregados_b AS
SELECT e.employeeNumber,
       SUM(p.amount) AS total_recebido,
       COUNT(DISTINCT c.customerNumber) AS qtd_clientes
FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN payments p ON c.customerNumber = p.customerNumber
WHERE e.reportsTo = 1143
  AND c.creditLimit > 100000
GROUP BY e.employeeNumber;

------------------------------------------------------

-- =========================================
-- QUESTÃO 1B
-- =========================================

-- Prova 1 (Final 5 - A)
WITH vw_clientes AS (
    SELECT o.officeCode,
           c.customerNumber,
           SUM(p.amount) AS total_recebido
    FROM employees e
    JOIN offices o ON e.officeCode = o.officeCode
    JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
    JOIN payments p ON c.customerNumber = p.customerNumber
    JOIN orders ord ON c.customerNumber = ord.customerNumber
    WHERE o.country = 'USA'
      AND YEAR(orderDate) = 2004
      AND QUARTER(orderDate) = 2
    GROUP BY o.officeCode, c.customerNumber
)
SELECT v.officeCode,
       SUM(v.total_recebido) AS total_faturado,
       COUNT(DISTINCT ord.orderNumber) AS total_pedidos
FROM vw_clientes v
JOIN orders ord ON v.customerNumber = ord.customerNumber
GROUP BY v.officeCode;

-- Prova 2 (Final 6 - B)
WITH vw_clientes_b AS (
    SELECT e.employeeNumber,
           c.customerNumber,
           SUM(p.amount) AS total_recebido
    FROM employees e
    JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
    JOIN payments p ON c.customerNumber = p.customerNumber
    WHERE e.reportsTo = 1143
      AND c.creditLimit > 100000
    GROUP BY e.employeeNumber, c.customerNumber
)
SELECT v.employeeNumber,
       SUM(p.amount) AS total_recebido,
       COUNT(DISTINCT o.orderNumber) AS total_pedidos,
       SUM(od.quantityOrdered) AS total_produtos
FROM vw_clientes_b v
JOIN orders o ON v.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN payments p ON v.customerNumber = p.customerNumber
WHERE YEAR(o.orderDate) = 2003
  AND QUARTER(o.orderDate) = 1
GROUP BY v.employeeNumber;

------------------------------------------------------

-- =========================================
-- QUESTÃO 1C
-- =========================================

-- Prova 1 (Final 5 - A)
CREATE VIEW vw_motorcycles AS
SELECT o.city AS escritorio,
       p.productCode,
       AVG(od.priceEach) AS preco_medio,
       p.MSRP
FROM offices o
JOIN employees e ON o.officeCode = e.officeCode
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders ord ON c.customerNumber = ord.customerNumber
JOIN orderdetails od ON ord.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
WHERE p.productLine = 'Motorcycles'
GROUP BY o.city, p.productCode, p.MSRP;

CREATE TABLE ANALISE_PERDA (
    ESCRITORIO VARCHAR(30),
    PRODUTO VARCHAR(10),
    OBSERVACAO VARCHAR(200)
);

DELIMITER //
CREATE PROCEDURE sp_analisar_perdas()
BEGIN
    INSERT INTO ANALISE_PERDA (escritorio, produto, observacao)
    SELECT escritorio, productCode,
           CASE
               WHEN FORMAT((1-AVG(preco_medio)/MSRP)*100,2) < 5
                    THEN 'Aceitável.'
               WHEN FORMAT((1-AVG(preco_medio)/MSRP)*100,2) BETWEEN 5 AND 10
                    THEN 'Atenção produtos com risco'
               ELSE 'Solicitar reunião com os vendedores!'
           END
    FROM vw_motorcycles
    GROUP BY escritorio, productCode, MSRP;
END//
DELIMITER ;

-- Prova 2 (Final 6 - B)
CREATE VIEW vw_giro_margem AS
SELECT p.productCode,
       FORMAT(((p.MSRP/p.buyPrice)-1)*100,2) AS margem,
       FORMAT((SUM(od.quantityOrdered) / (SUM(od.quantityOrdered)+p.quantityInStock))*100,2) AS percentual_vendido
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.MSRP, p.buyPrice, p.quantityInStock;

CREATE TABLE ANALISE_GIRO_MARGEM (
    PRODUTO VARCHAR(10),
    OBSERVACAO VARCHAR(200)
);

DELIMITER //
CREATE PROCEDURE sp_analisar_giro_margem()
BEGIN
    INSERT INTO ANALISE_GIRO_MARGEM (produto, observacao)
    SELECT productCode,
           CASE
               WHEN margem >= 100 AND percentual_vendido > 20
                    THEN 'Produto alto GIRO e excelente Margem. Manter preço'
               WHEN margem >= 100 AND percentual_vendido < 10
                    THEN 'Produto baixo GIRO e excelente Margem. Reduzir preço de venda'
               WHEN margem < 100 AND percentual_vendido > 20
                    THEN 'Produto alto GIRO e baixa Margem. Aumentar preço de venda'
               ELSE 'Manter os valores praticados'
           END
    FROM vw_giro_margem;
END//
DELIMITER ;

------------------------------------------------------

-- =========================================
-- QUESTÃO 1D
-- =========================================

-- Prova 1 (Final 5 - A)
DELIMITER //
CREATE PROCEDURE sp_faturamento_loja(IN loja_id INT)
BEGIN
    SELECT c.country, SUM(p.amount) AS total_faturado
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    WHERE i.store_id = loja_id
    GROUP BY c.country;
END//
DELIMITER ;

-- Prova 2 (Final 6 - B)
DELIMITER //
CREATE PROCEDURE sp_faturamento_categoria(IN categoria_id INT)
BEGIN
    SELECT c.name AS categoria,
           COUNT(f.film_id) AS qtd_filmes,
           SUM(p.amount) AS total_faturado
    FROM film_category fc
    JOIN film f ON fc.film_id = f.film_id
    JOIN category c ON fc.category_id = c.category_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    JOIN payment p ON r.rental_id = p.rental_id
    WHERE fc.category_id = categoria_id
    GROUP BY c.name;
END//
DELIMITER ;


-- =========================================
-- QUESTÃO 2
-- =========================================

-- Prova 1 (Final 5 - A)
CREATE TABLE polynesia_idiomas AS
SELECT cl.language,
       SUM((cl.percentage * c.population)/100) AS total_falantes
FROM countrylanguage cl
JOIN country c ON cl.countrycode = c.code
WHERE c.region = 'Polynesia'
GROUP BY cl.language;

-- Prova 2 (Final 6 - B)
CREATE TABLE china_idiomas AS
SELECT cl.language,
       SUM((cl.percentage * c.population)/100) AS total_falantes
FROM countrylanguage cl
JOIN country c ON cl.countrycode = c.code
WHERE cl.countrycode = 'CHN'
GROUP BY cl.language;

/* =============================================
   ARQUIVO ÚNICO - ATIVIDADE AVALIATIVA COMPLETA
   UNIFICAÇÃO DAS PARTES 1, 2 E 3 + CORREÇÕES
   ============================================= */

USE classicmodels;

/* =====================
   PARTE 1 - VIEWS, CTE E ANALISE DE ESTOQUE
   ===================== */

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

/* =====================
   PARTE 2 e 3 - ANÁLISES DE CRÉDITO, LUCRO E PERDA
   ===================== */

-- View para análise de crédito
CREATE OR REPLACE VIEW vw_questao01a AS
SELECT c.customername AS cliente,
       SUM(p.amount) AS total,
       c.creditlimit AS limite_credito,
       e.jobtitle AS funcao_empregado,
       o.city AS escritorio
FROM customers c
INNER JOIN payments p USING (customernumber)
INNER JOIN employees e ON c.salesrepemployeenumber = e.employeenumber
INNER JOIN offices o USING (officecode)
WHERE YEAR(p.paymentdate) IN (2003, 2005)
  AND c.creditlimit > 100000
GROUP BY c.customername, c.creditlimit, e.jobtitle, o.city;

-- Tabela de crédito de clientes
DROP TABLE IF EXISTS credito_cliente;
CREATE TABLE credito_cliente (
    cliente VARCHAR(200),
    total DECIMAL(10,2),
    limite_credito DECIMAL(10,2),
    analise VARCHAR(100)
) ENGINE = InnoDB;

-- Procedure para análise de crédito
DELIMITER $$
CREATE PROCEDURE proc_analise_credito(IN p_funcao VARCHAR(50), IN p_escritorio VARCHAR(50))
BEGIN
    INSERT INTO credito_cliente
    SELECT cliente, total, limite_credito,
           CASE
               WHEN limite_credito - total < 0 THEN 'Entrar em contato com o cliente'
               ELSE 'Sugerir aumento de crédito'
           END
    FROM vw_questao01a
    WHERE funcao_empregado = p_funcao AND escritorio = p_escritorio;
END $$
DELIMITER ;

-- Análise de lucro por produto, escritório e país
DROP TABLE IF EXISTS analise_lucro;
CREATE TABLE analise_lucro (
    produto VARCHAR(50),
    media DECIMAL(10,2),
    analise VARCHAR(200)
) ENGINE = InnoDB;

DELIMITER $$
CREATE PROCEDURE proc_analise_lucro(IN p_escritorio VARCHAR(50), IN p_pais VARCHAR(50))
BEGIN
    DELETE FROM analise_lucro;

    INSERT INTO analise_lucro (produto, media, analise)
    SELECT p.productname,
           ROUND(AVG(((od.priceeach / p.buyprice) - 1) * 100), 2) AS media,
           CASE
               WHEN ROUND(AVG(((od.priceeach / p.buyprice) - 1) * 100), 2) < 30 THEN 'Chamar o representante imediatamente'
               WHEN ROUND(AVG(((od.priceeach / p.buyprice) - 1) * 100), 2) < 50 THEN 'Aumentar margem de lucro'
               WHEN ROUND(AVG(((od.priceeach / p.buyprice) - 1) * 100), 2) < 100 THEN 'Manter o valor'
               ELSE 'Conceder mais 10% de desconto'
           END
    FROM orderdetails od
    INNER JOIN products p USING (productcode)
    INNER JOIN orders o USING (ordernumber)
    INNER JOIN customers c USING (customernumber)
    INNER JOIN employees e ON c.salesrepemployeenumber = e.employeenumber
    INNER JOIN offices f USING (officecode)
    WHERE f.city = p_escritorio AND c.country = p_pais
    GROUP BY p.productname;
END $$
DELIMITER ;

-- Views para faturamento e análise de perda
CREATE OR REPLACE VIEW vw_motorcycles AS
SELECT f.city AS escritorio,
       p.productcode,
       ROUND(AVG(od.priceeach), 2) AS media_preco,
       p.msrp
FROM orderdetails od
INNER JOIN products p USING (productcode)
INNER JOIN orders o USING (ordernumber)
INNER JOIN customers c USING (customernumber)
INNER JOIN employees e ON c.salesrepemployeenumber = e.employeenumber
INNER JOIN offices f USING (officecode)
WHERE p.productline = 'Motorcycles'
GROUP BY f.city, p.productcode, p.msrp;

DROP TABLE IF EXISTS analise_perda;
CREATE TABLE analise_perda (
    escritorio VARCHAR(30),
    produto VARCHAR(10),
    observacao VARCHAR(200)
) ENGINE = InnoDB;

DELIMITER $$
CREATE PROCEDURE proc_analise_perda()
BEGIN
    DELETE FROM analise_perda;

    INSERT INTO analise_perda (escritorio, produto, observacao)
    SELECT escritorio, productcode,
           CASE
               WHEN FORMAT((1 - (media_preco / msrp)) * 100, 2) < 5 THEN 'Aceitável.'
               WHEN FORMAT((1 - (media_preco / msrp)) * 100, 2) BETWEEN 5 AND 10 THEN 'Atenção: produtos com risco'
               ELSE 'Solicitar reunião com os vendedores!'
           END
    FROM vw_motorcycles;
END $$
DELIMITER ;