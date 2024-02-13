USE funkoshop;


DELIMITER $$
DROP PROCEDURE IF EXISTS numRegsCategories$$
CREATE PROCEDURE numRegsCategories(IN _parametros VARCHAR(250))
begin
    SELECT stringFilter(_parametros, 'id&categoryName') INTO @filter;
    SELECT concat("SELECT count(id) from categories where ", @filter) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$
DELIMITER ;




DELIMITER $$
DROP PROCEDURE IF EXISTS filterCategories$$
CREATE PROCEDURE filterCategories (IN _parameters VARCHAR(250), IN _page SMALLINT UNSIGNED, IN _cantRegs SMALLINT UNSIGNED)
begin
    SELECT stringFilter(_parameters, 'id&categoryName&') INTO @filter;
    SELECT concat("SELECT * from categories where ", @filter, " LIMIT ", 
        _page, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$
DELIMITER ;




DELIMITER $$
DROP FUNCTION IF EXISTS createCategories$$
CREATE FUNCTION createCategories (_name VARCHAR(50))
RETURNS INT(1)
    BEGIN   
        DECLARE _amount int;
        SELECT count(name) INTO _amount FROM funkos WHERE name = _name;
        IF _amount = 0 THEN

            INSERT INTO categories (categoryName) VALUES (_name);
        ELSE
            SET _amount = 1;
        END IF;
        RETURN _amount;
    END $$

    DELIMITER ;

DELIMITER $$
DROP FUNCTION IF EXISTS deleteCategories$$
CREATE FUNCTION deleteCategories (_id INT)
	RETURNS INT
    BEGIN   
        DECLARE rowsAffected INT;
        DELETE FROM categories WHERE id = _id;
        SET rowsAffected = ROW_COUNT();
       RETURN rowsAffected;
    END $$
DELIMITER ;

DELIMITER $$
DROP FUNCTION IF EXISTS editCategories$$
CREATE FUNCTION editCategories(_id INT, _name VARCHAR(50))
RETURNS INT(1)
    BEGIN
        DECLARE _amount INT;
        SELECT COUNT(categories.id) INTO _amount FROM categories WHERE categories.id = _id;
        IF _amount > 0 THEN
            UPDATE categories SET
                categories.name = _name
            WHERE categories.id = _id;
        END IF;
        RETURN _amount;
    END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS searchCategory$$
CREATE DEFINER=`root`@`localhost` PROCEDURE searchCategory(_idCategory INT)
begin
    select * from categories where id = _idCategory;
end$$
DELIMITER ;