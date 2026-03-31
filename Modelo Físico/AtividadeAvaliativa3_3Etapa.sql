use classicmodels;

DELIMITER $$

CREATE PROCEDURE CriarPedidoCliente(
    IN p_customerNumber INT,
    IN p_salesRepEmployeeNumber INT
)
BEGIN
    DECLARE v_orderNumber INT;
    DECLARE v_productCode VARCHAR(15);
    DECLARE v_quantity INT DEFAULT 330;
    DECLARE v_stock INT;
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR
        SELECT 
			productCode
        FROM
			orderdetails
        GROUP BY
			productCode
        ORDER BY
			SUM(quantityOrdered) DESC
		LIMIT 5;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    START TRANSACTION;

    UPDATE
		customers
    SET
		creditLimit = 100000
    WHERE
		customerNumber = p_customerNumber;

    INSERT INTO orders (
        orderDate, requiredDate, shippedDate, status, comments, customerNumber
    ) VALUES (
        CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), NULL, 'In Process', 'Pedido automático', p_customerNumber
    );

    SET v_orderNumber = LAST_INSERT_ID();

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_productCode;
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        SELECT 
			quantityInStock
		INTO
			v_stock
        FROM
			products
        WHERE
			productCode = v_productCode;

        IF v_stock < v_quantity THEN
            ROLLBACK;
            CLOSE cur;
            LEAVE read_loop;
        END IF;

        INSERT INTO orderdetails (
            orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber
        )
        SELECT
			v_orderNumber, productCode, v_quantity, buyPrice, 
               (SELECT 
					IFNULL(MAX(orderLineNumber),0)+1 
				FROM
					orderdetails
				WHERE
					orderNumber = v_orderNumber)
        FROM 
			products
        WHERE
			productCode = v_productCode;

        UPDATE products
        SET quantityInStock = quantityInStock - v_quantity
        WHERE productCode = v_productCode;
    END LOOP;

    CLOSE cur;

    UPDATE customers
    SET salesRepEmployeeNumber = p_salesRepEmployeeNumber
    WHERE customerNumber = p_customerNumber;

    INSERT INTO payments (customerNumber, checkNumber, paymentDate, amount)
    SELECT 
		p_customerNumber,
        CONCAT('CHK', v_orderNumber),
        CURDATE(),
		SUM(quantityOrdered * priceEach)
    FROM
		orderdetails
    WHERE
		orderNumber = v_orderNumber;

    COMMIT;
END$$

DELIMITER ;

DROP PROCEDURE CriarPedidoCliente;

CALL CriarPedidoCliente(141, 1504);

SELECT 
	CustomerNumber, CustomerName, creditLimit, SalesRepEmployeeNumber
FROM
	customers
WHERE
	CustomerNumber = 141;