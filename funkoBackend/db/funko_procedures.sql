USE funkoshop;
DELIMITER $$

DROP PROCEDURE IF EXISTS searchFunko$$
CREATE PROCEDURE searchFunko (IN _id INT)
    BEGIN
        SELECT  FROM funkos WHERE funkos.id = _id;
    END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS searchFunkoDetail$$
    CREATE PROCEDURE searchFunkoDetail(IN _id INT)
        BEGIN
            SELECT 
            funkos.id, 
            funkos.name, 
            funkos.exclusivity, 
            funkos.urlFirstImage, 
            funkos.urlSecondImage, 
            funkos.price, 
            funkos.description,
            producttypes.typeName,
            categories.categoryName FROM funkos 
            INNER JOIN producttypes ON funkos.productTypeID = producttypes.id 
            INNER JOIN categories ON funkos.categoryID = categories.id
            WHERE funkos.id = _id;
        END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS filterFunko$$
CREATE DEFINER=`root`@`localhost` PROCEDURE filterFunko(
    _parameters varchar(100), 
    _page SMALLINT UNSIGNED, 
    _cantRegs SMALLINT UNSIGNED)
begin
    SELECT stringFilter(_parameters, 'id&name&productTypeID&categoryID&exclusivity&') INTO @filter;
    SELECT concat("SELECT * from funkos where ", @filter, " LIMIT ", 
        _page, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;  
end$$

----------------------------------------------------------------------------------------$$$$$$##""#$"#$"
DELIMITER $$
DROP PROCEDURE IF EXISTS filterFunko$$
CREATE DEFINER=`root`@`localhost` PROCEDURE filterFunko(
    _parameters varchar(100), 
    _page SMALLINT UNSIGNED, 
    _cantRegs SMALLINT UNSIGNED)
begin
    SELECT stringFilter(_parameters, 'id&name&productTypeID&categoryID&exclusivity&') INTO @filter;
    SELECT concat("SELECT funkos.id, 
                  funkos.name, 
                  funkos.exclusivity, 
                  funkos.urlFirstImage, 
                  funkos.urlSecondImage,
                  funkos.stock,
                  funkos.price, 
                  funkos.description, 
                  categories.categoryName,
                  producttypes.typeName
                  FROM funkos 
                  INNER JOIN categories ON funkos.categoryID = categories.id 
                  INNER JOIN producttypes ON funkos.productTypeID = producttypes.id where funkos.", @filter, " LIMIT ", 
        _page, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;  
end$$
----------------------------------------------------------------------------------------$$$$$$##""#$"#$"




DROP FUNCTION IF EXISTS createFunko$$
CREATE FUNCTION  createFunko (
    _name VARCHAR(50),
    _productTypeID INT,
    _categoryID INT,
    _exclusivity INT, 
    _urlFirstImage VARCHAR(150),
    _urlSecondImage VARCHAR(150),
    _stock INT,
    _price DOUBLE(6, 2),
    _description TEXT
    
)RETURNS INT(1)
    BEGIN
        DECLARE _amount int;
        SELECT count(name) INTO _amount FROM funkos WHERE name = _name;
        if _amount = 0 THEN
            INSERT INTO funkos (
                name, 
                productTypeID, 
                categoryID, 
                exclusivity, 
                urlFirstImage, 
                urlSecondImage,
                stock, 
                price, 
                description) VALUES (
                    _name, 
                    _productTypeID, 
                    _categoryID, 
                    _exclusivity, 
                    _urlFirstImage, 
                    _urlSecondImage,
                    _stock, 
                    _price, 
                    _description
                );
        ELSE
            SET _amount = 1;
        END IF;
        RETURN _amount;
    END$$


DROP FUNCTION IF EXISTS editFunko$$
CREATE FUNCTION editFunko(
    _id INT,
    _name VARCHAR(50),
    _productTypeID INT,
    _categoryID INT,
    _exclusivity INT, 
    _urlFirstImage VARCHAR(150),
    _urlSecondImage VARCHAR(150),
    _stock INT,
    _price DOUBLE(6, 2),
    _description TEXT
)RETURNS INT(1)

BEGIN   
    DECLARE amount int;
    SELECT COUNT(funkos.id) INTO amount FROM funkos WHERE id = _id;

    IF amount > 0 THEN
        UPDATE funkos SET 
            name = _name,
            productTypeID = _productTypeID,
            categoryID = _categoryID,
            exclusivity = _exclusivity, 
            urlFirstImage = _urlFirstImage,
            urlSecondImage = _urlSecondImage,
            stock = _stock,
            price = _price,
            description = _description
        WHERE funkos.id = _id;
    END IF;
    RETURN amount;
END$$

DROP FUNCTION IF EXISTS addStock$$
CREATE FUNCTION addStock(IN _amount INT, IN _id INT)
    RETURNS INT
    BEGIN
        DECLARE quant INT;
        SELECT COUNT(funkos.id) INTO quant FROM funkos WHERE funkos.id = _id;
        IF quant > 0 THEN   
            UPDATE funkos SET 
                stock + _stock
            WHERE funkos.id = _id;
        END IF;
        RETURN quant;
    END$$

DROP FUNCTION IF EXISTS deleteFunko$$
CREATE FUNCTION deleteFunko (_id INT)
RETURNS INT
    BEGIN
        DECLARE rowsAffected INT;
    
        DELETE FROM funkos WHERE id = _id;
        SET rowsAffected = ROW_COUNT();
    
    RETURN rowsAffected;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS categoryFilterAdmin$$
CREATE PROCEDURE categoryFilterAdmin(IN _categoryID INT)

    BEGIN
        SELECT funkos.id, funkos.productTypeID, funkos.categoryID, funkos.exclusivity,
                funkos.urlFirstImage, funkos.urlSecondImage, funkos.stock, funkos.price
        FROM funkos WHERE funkos.categoryID = _categoryID;
    END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS categoryFilter$$
CREATE PROCEDURE categoryFilter(IN _categoryID INT)

    BEGIN
        SELECT funkos.id, funkos.name, funkos.productTypeID, funkos.categoryID, funkos.exclusivity,
                funkos.urlFirstImage, funkos.urlSecondImage, funkos.price, funkos.description
        FROM funkos WHERE funkos.categoryID = _categoryID AND funkos.stock >= 1;
    END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS productTypeFilterAdmin$$
CREATE PROCEDURE productTypeFilterAdmin(IN _productTypeID INT)

    BEGIN
        SELECT funkos.id, funkos.productTypeID, funkos.categoryID, funkos.exclusivity,
                funkos.urlFirstImage, funkos.urlSecondImage, funkos.stock, funkos.price
        FROM funkos WHERE funkos.productTypeID = _productTypeID;
    END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS productTypeFilter$$
CREATE PROCEDURE productTypeFilter(IN _productTypeID INT)

    BEGIN
        SELECT funkos.id, funkos.productTypeID, funkos.categoryID, funkos.exclusivity,
                funkos.urlFirstImage, funkos.urlSecondImage, funkos.price, funkos.description
        FROM funkos WHERE funkos.productTypeID = _productTypeID AND funkos.stock >= 1;
    END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS priceFilter$$
CREATE PROCEDURE priceFilter(IN _price DOUBLE(6, 2))

    BEGIN
        SELECT funkos.id, funkos.productTypeID, funkos.categoryID, funkos.exclusivity,
                funkos.urlFirstImage, funkos.urlSecondImage, funkos.price, funkos.description
        FROM funkos WHERE funkos.price = _price AND funkos.stock >= 1;
    END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS priceFilterASC$$
CREATE PROCEDURE priceFilterASC()

    BEGIN
        SELECT funkos.id, funkos.productTypeID, funkos.categoryID, funkos.exclusivity,
                funkos.urlFirstImage, funkos.urlSecondImage, funkos.price, funkos.description
        FROM funkos ORDER BY funkos.price ASC;
    END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS priceFilterDESC$$
CREATE PROCEDURE priceFilterDESC()

    BEGIN
        SELECT funkos.id, funkos.productTypeID, funkos.categoryID, funkos.exclusivity,
                funkos.urlFirstImage, funkos.urlSecondImage, funkos.price, funkos.description
        FROM funkos ORDER BY funkos.price DESC;
    END$$
DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS funkoFeed$$
CREATE PROCEDURE funkoFeed()
    BEGIN
        SELECT funkos.id, funkos.name, funkos.urlFirstImage, funkos.urlSecondImage, funkos.price, 
                producttypes.typeName, categories.categoryName FROM funkos 
                INNER JOIN producttypes ON producttypes.id = funkos.productTypeID 
                INNER JOIN categories ON categories.id = funkos.categoryID;
    END$$

DELIMITER ;
