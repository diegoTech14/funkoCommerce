USE funkoShop;

DELIMITER $$

CREATE PROCEDURE prodTypes()
    BEGIN
        SELECT * FROM producttypes;
    END

DROP PROCEDURE IF EXISTS createProducType$$
CREATE PROCEDURE createProducType(IN _name VARCHAR(50))
    BEGIN 
        INSERT INTO categories (typeName) VALUES (_name);
    END$$


DROP PROCEDURE IF EXISTS deleteProductType$$
CREATE PROCEDURE deleteProductType (IN _id INT)
    BEGIN   
        DELETE FROM productTypes WHERE productTypes.id = _id;
    END $$


DROP PROCEDURE IF EXISTS editProductTypes$$
CREATE PROCEDURE editProductTypes(IN _id INT, IN _name VARCHAR(50))
    BEGIN
        DECLARE _amount INT;
        SELECT COUNT(productTypes.id) INTO _amount FROM categories WHERE productTypes.id = _id;
        IF _amount > 0 THEN
            UPDATE categories SET
                productTypes.name = _name
            WHERE productTypes.id = _id;
        END IF;
    END $$

DELIMITER ;