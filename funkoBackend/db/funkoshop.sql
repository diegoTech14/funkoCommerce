-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 07-07-2023 a las 19:06:57
-- Versión del servidor: 8.0.31
-- Versión de PHP: 8.1.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `funkoshop`
--

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `categoryFilter`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `categoryFilter` (IN `_categoryID` INT)   BEGIN
        SELECT funkos.id, funkos.name, funkos.productTypeID, funkos.categoryID, funkos.exclusivity,
                funkos.urlFirstImage, funkos.urlSecondImage, funkos.price, funkos.description
        FROM funkos WHERE funkos.categoryID = _categoryID AND funkos.stock >= 1;
    END$$

DROP PROCEDURE IF EXISTS `createProducType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createProducType` (IN `_name` VARCHAR(50))   BEGIN 
        INSERT INTO categories (typeName) VALUES (_name);
    END$$

DROP PROCEDURE IF EXISTS `deleteProductType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteProductType` (IN `_id` INT)   BEGIN   
        DELETE FROM productTypes WHERE productTypes.id = _id;
    END$$

DROP PROCEDURE IF EXISTS `editProductTypes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `editProductTypes` (IN `_id` INT, IN `_name` VARCHAR(50))   BEGIN
        DECLARE _amount INT;
        SELECT COUNT(productTypes.id) INTO _amount FROM categories WHERE productTypes.id = _id;
        IF _amount > 0 THEN
            UPDATE categories SET
                productTypes.name = _name
            WHERE productTypes.id = _id;
        END IF;
    END$$

DROP PROCEDURE IF EXISTS `filterCategories`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `filterCategories` (IN `_parameters` VARCHAR(250), IN `_page` SMALLINT UNSIGNED, IN `_cantRegs` SMALLINT UNSIGNED)   begin
    SELECT stringFilter(_parameters, 'id&categoryName&') INTO @filter;
    SELECT concat("SELECT * from categories where ", @filter, " LIMIT ", 
        _page, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

DROP PROCEDURE IF EXISTS `filterFunko`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `filterFunko` (IN `_parameters` VARCHAR(100), IN `_page` SMALLINT UNSIGNED, IN `_cantRegs` SMALLINT UNSIGNED)   begin
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

DROP PROCEDURE IF EXISTS `filterFunkoCrud`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `filterFunkoCrud` (`_parameters` VARCHAR(100), `_page` SMALLINT UNSIGNED, `_cantRegs` SMALLINT UNSIGNED)   begin
    SELECT stringFilter(_parameters, 'id&name&productTypeID&categoryID&exclusivity&') INTO @filter;
    SELECT concat("SELECT funkos.id, 
                  funkos.name, 
                  funkos.exclusivity, 
                  funkos.urlFirstImage, 
                  funkos.urlSecondImage,
                  funkos.stock,
                  funkos.price, 
                  funkos.description, 
                  categories.name,
                  productypes.name
                  from funkos 
                  INNER JOIN categories ON funkos.categoryID = categories.id 
                  INNER JOIN producttypes ON funkos.productTypeID = producttypes.id where ", @filter, " LIMIT ", 
        _page, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;  
end$$

DROP PROCEDURE IF EXISTS `filterPerson`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `filterPerson` (`_parameters` VARCHAR(100), `_page` SMALLINT UNSIGNED, `_cantRegs` SMALLINT UNSIGNED)   begin
    SELECT stringFilter(_parameters, 'id&name&surnameOne&surnameTwo&') INTO @filter;
    SELECT concat("SELECT * from person where ", @filter, " LIMIT ", 
        _page, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;  
end$$

DROP PROCEDURE IF EXISTS `filterUser`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `filterUser` (IN `_parameters` VARCHAR(250), IN `_page` SMALLINT UNSIGNED, IN `_cantRegs` SMALLINT UNSIGNED)   begin
    SELECT stringFilter(_parameters, 'id&emailAddress&id_person&password&userName&idRol&') INTO @filter;
    SELECT concat("SELECT * from users where ", @filter, " LIMIT ", 
        _page, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

DROP PROCEDURE IF EXISTS `funkoFeed`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `funkoFeed` ()   BEGIN
        SELECT funkos.id, funkos.name, funkos.urlFirstImage, funkos.urlSecondImage, funkos.price, 
                producttypes.typeName, categories.categoryName FROM funkos INNER JOIN producttypes 
                    ON producttypes.id = funkos.productTypeID INNER JOIN categories 
                    ON categories.id = funkos.categoryID;
    END$$

DROP PROCEDURE IF EXISTS `numRegsCategories`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `numRegsCategories` (IN `_parameters` VARCHAR(255))   begin
    SELECT stringFilter(_parameters, 'id&categoryName') INTO @filter;
    SELECT concat("SELECT count(id) from categories where ", @filter) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

DROP PROCEDURE IF EXISTS `numRegsFunko`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `numRegsFunko` (IN `_parametros` VARCHAR(250))   begin
    SELECT stringFilter(_parametros, 'id&name&productTypeID&categoryID&exclusivity&') INTO @filter;
    SELECT concat("SELECT count(id) from funkos where ", @filter) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

DROP PROCEDURE IF EXISTS `numRegsUser`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `numRegsUser` (IN `_parametros` VARCHAR(250))   begin
    SELECT stringFilter(_parametros, 'id&emailAddress&id_person&password&userName&idRol&') INTO @filter;
    SELECT concat("SELECT count(id) from users where ", @filter) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$

DROP PROCEDURE IF EXISTS `prodTypes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `prodTypes` ()   BEGIN
        SELECT * FROM producttypes;
    END$$

DROP PROCEDURE IF EXISTS `searchCategories`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `searchCategories` (IN `_idCategory` INT)   begin
    select * from categories where id = _idCategory;
end$$

DROP PROCEDURE IF EXISTS `searchFunko`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `searchFunko` (IN `_id` INT)   BEGIN
        SELECT * FROM funkos WHERE funkos.id = _id;
    END$$

DROP PROCEDURE IF EXISTS `searchFunkoDetail`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `searchFunkoDetail` (IN `_id` INT)   BEGIN
            SELECT 
            funkos.id, 
            funkos.name, 
            funkos.exclusivity, 
            funkos.urlFirstImage, 
            funkos.urlSecondImage, 
            funkos.price, 
            funkos.stock,
            funkos.description,
            producttypes.typeName,
            categories.categoryName,
            categories.id as categoryID,
            producttypes.id as producttypesId
            FROM funkos 
            INNER JOIN producttypes ON funkos.productTypeID = producttypes.id 
            INNER JOIN categories ON funkos.categoryID = categories.id
            WHERE funkos.id = _id;
        END$$

DROP PROCEDURE IF EXISTS `searchPerson`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `searchPerson` (IN `_idPerson` INT)   begin
    select * from person where id = _idPerson;
end$$

DROP PROCEDURE IF EXISTS `searchUser`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `searchUser` (`_id` INT, `_idPerson` INT)   begin
    select * from users where id_person = _idPerson OR id = _id;
end$$

DROP PROCEDURE IF EXISTS `searchUserByEmail`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `searchUserByEmail` (IN `_emailAddress` VARCHAR(100))   begin
	SELECT * FROM users WHERE emailAddress COLLATE utf8mb4_unicode_ci LIKE CONCAT('%', _emailAddress, '%');
end$$

DROP PROCEDURE IF EXISTS `verifyToken`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `verifyToken` (`_id_person` VARCHAR(15), `_tkR` VARCHAR(255))   begin
    select idRol from users where id_person = _id_person and tkR = _tkR;
end$$

--
-- Funciones
--
DROP FUNCTION IF EXISTS `addStock`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `addStock` (`_amount` INT, `_id` INT) RETURNS INT  BEGIN
        DECLARE quant INT;
        SELECT COUNT(funkos.id) INTO quant FROM funkos WHERE funkos.id = _id;
        IF quant > 0 THEN   
            UPDATE funkos SET 
                stock = (stock + _amount)
            WHERE funkos.id = _id;
        END IF;
        RETURN quant;
    END$$

DROP FUNCTION IF EXISTS `createCategories`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `createCategories` (`_name` VARCHAR(50)) RETURNS INT  BEGIN   
        DECLARE _amount int;
        SELECT count(name) INTO _amount FROM funkos WHERE name = _name;
        IF _amount = 0 THEN

            INSERT INTO categories (categoryName) VALUES (_name);
        ELSE
            SET _amount = 1;
        END IF;
        RETURN _amount;
    END$$

DROP FUNCTION IF EXISTS `createFunko`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `createFunko` (`_name` VARCHAR(50), `_productTypeID` INT, `_categoryID` INT, `_exclusivity` INT, `_urlFirstImage` VARCHAR(150), `_urlSecondImage` VARCHAR(150), `_stock` INT, `_price` DOUBLE(6,2), `_description` TEXT) RETURNS INT  BEGIN
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

DROP FUNCTION IF EXISTS `createPerson`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `createPerson` (`_name` VARCHAR(25), `_surnameOne` VARCHAR(25), `_surnameTwo` VARCHAR(25), `_password` VARCHAR(255), `_emailAddress` VARCHAR(150), `_userName` VARCHAR(100)) RETURNS INT  BEGIN
    DECLARE _cant int;
    INSERT INTO person (name, surnameOne, surnameTwo)
    VALUES (_name, _surnameOne, _surnameTwo);
    set _cant=1;
    RETURN _cant;
END$$

DROP FUNCTION IF EXISTS `createRol`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `createRol` (`_rolName` VARCHAR(25)) RETURNS INT  BEGIN
    DECLARE _cant INT;
    INSERT INTO roles (rolName) VALUES (_rolName);
    SET _cant = 1;
    RETURN _cant;
END$$

DROP FUNCTION IF EXISTS `createUser`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `createUser` (`_id_person` INT, `_emailAddress` VARCHAR(100), `_password` VARCHAR(255), `_userName` VARCHAR(25)) RETURNS INT  BEGIN
    DECLARE _cant int;
    select count(id) into _cant from users where id_person = _id_person;
    
    if _cant>0 THEN
    UPDATE users
    SET emailAddress = _emailAddress,
        password = _password,
        userName = _userName,
        idRol = 3
    WHERE id_person = _id_person;
    end if;
 
    RETURN _cant;
END$$

DROP FUNCTION IF EXISTS `deleteCategories`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `deleteCategories` (`_id` INT) RETURNS INT  BEGIN   
        DECLARE rowsAffected INT;
        DELETE FROM categories WHERE id = _id;
        SET rowsAffected = ROW_COUNT();
       RETURN rowsAffected;
    END$$

DROP FUNCTION IF EXISTS `deleteFunko`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `deleteFunko` (`_id` INT) RETURNS INT  BEGIN
        DECLARE rowsAffected INT;
    
        DELETE FROM funkos WHERE id = _id;
        SET rowsAffected = ROW_COUNT();
    
    RETURN rowsAffected;
END$$

DROP FUNCTION IF EXISTS `deleteRol`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `deleteRol` (`_idRol` INT) RETURNS INT  BEGIN
    DECLARE rowsAffected INT;
    
    DELETE FROM roles WHERE id = _idRol;
    SET rowsAffected = ROW_COUNT();
    
    RETURN rowsAffected;
END$$

DROP FUNCTION IF EXISTS `deleteUser`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `deleteUser` (`_id` INT) RETURNS INT  BEGIN
    DECLARE rowsAffected INT;
    
    DELETE FROM users WHERE id_Person = _id;
    SET rowsAffected = ROW_COUNT();
    
    RETURN rowsAffected;
END$$

DROP FUNCTION IF EXISTS `editCategories`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `editCategories` (`_id` INT, `_name` VARCHAR(50)) RETURNS INT  BEGIN
        DECLARE _amount INT;
        SELECT COUNT(categories.id) INTO _amount FROM categories WHERE categories.id = _id;
        IF _amount > 0 THEN
            UPDATE categories SET
                categories.categoryName = _name
            WHERE categories.id = _id;
        END IF;
        RETURN _amount;
    END$$

DROP FUNCTION IF EXISTS `editFunko`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `editFunko` (`_id` INT, `_name` VARCHAR(50), `_productTypeID` INT, `_categoryID` INT, `_exclusivity` INT, `_urlFirstImage` VARCHAR(150), `_urlSecondImage` VARCHAR(150), `_stock` INT, `_price` DOUBLE(6,2), `_description` TEXT) RETURNS INT  BEGIN   
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

DROP FUNCTION IF EXISTS `editPerson`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `editPerson` (`_id` INT, `_name` VARCHAR(25), `_surnameOne` VARCHAR(25), `_surnameTwo` VARCHAR(25)) RETURNS INT  begin
    declare _cant int;
    select count(id) into _cant from person where id = _id;
    if _cant > 0 then
        update person set
            name = _name,
            surnameOne = _surnameOne,
            surnameTwo = _surnameTwo
        where id = _id;
    end if;
    return _cant;
end$$

DROP FUNCTION IF EXISTS `editUser`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `editUser` (`_id_Person` INT, `_emailAddress` VARCHAR(100), `_password` VARCHAR(255), `_userName` VARCHAR(25)) RETURNS INT  begin
    declare _cant int;
    select count(id) into _cant from users where id_Person = _id_Person;
    if _cant > 0 then
        update users set
            emailAddress = _emailAddress,
            password = _password,
            userName = _userName
        where id_Person = _id_Person;
    end if;
    return _cant;
end$$

DROP FUNCTION IF EXISTS `editUserRol`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `editUserRol` (`_id_Person` INT, `_rol` INT) RETURNS INT  BEGIN
    DECLARE _cant INT;
    SELECT COUNT(id) INTO _cant FROM users WHERE id_Person = _id_Person;
    IF _cant > 0 THEN
        UPDATE users SET
            idRol = _rol
        WHERE id_Person = _id_Person;
    END IF;
    RETURN _cant;
END$$

DROP FUNCTION IF EXISTS `lastId`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `lastId` () RETURNS INT  BEGIN
        DECLARE _quant int;
        SELECT id INTO _quant FROM person ORDER BY id DESC LIMIT 1;
    return _quant;
    END$$

DROP FUNCTION IF EXISTS `modifyToken`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `modifyToken` (`_id_person` VARCHAR(15), `_tkR` VARCHAR(255)) RETURNS INT  begin
    declare _cant int;
    select count(id_person) into _cant from users where id_person = _id_person;
    if _cant > 0 then
        update users set
                tkR = _tkR
                where id_person = _id_person;
        if _tkR <> "" then
            update users set
                lastAccess = now()
                where id_person = _id_person;
        end if;
    end if;
    return _cant;
end$$

DROP FUNCTION IF EXISTS `stringFilter`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `stringFilter` (`_parameters` VARCHAR(250), `_camps` VARCHAR(50)) RETURNS VARCHAR(250) CHARSET utf8mb4  begin
    declare _output varchar (250);
    set @param = _parameters;
    set @camps2 = _camps;
    set @filter = "";
    WHILE (LOCATE('&', @param) > 0) DO
        set @value = SUBSTRING_INDEX(@param, '&', 1);
        set @param = substr(@param, LOCATE('&', @param)+1);
        set @camp = SUBSTRING_INDEX(@camps2, '&', 1);
        set @camps2 = substr(@camps2, LOCATE('&', @camps2)+1);
        set @filter = concat(@filter, " `", @camp, "` LIKE '", @value, "' and");       
    END WHILE;
    set @filter = TRIM(TRAILING 'and' FROM @filter);  
    return @filter;
end$$

DROP FUNCTION IF EXISTS `userPassword`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `userPassword` (`_emailAddress` VARCHAR(100), `_passw` VARCHAR(255)) RETURNS INT  BEGIN
    DECLARE _amount INT;
    SELECT COUNT(id) INTO _amount FROM users WHERE emailAddress COLLATE utf8mb4_unicode_ci LIKE CONCAT('%', _emailAddress, '%');
    IF _amount > 0 THEN
        UPDATE users SET password = _passw WHERE emailAddress COLLATE utf8mb4_unicode_ci LIKE CONCAT('%', _emailAddress, '%');
    END IF;
    RETURN _amount;
END$$

DROP FUNCTION IF EXISTS `userRol`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `userRol` (`_id` INT, `_rol` INT) RETURNS INT  begin
    declare _amount int;
    select count(id) into _amount from users where users.id_person = _id;
    if _amount > 0 then
        update users set
            idRol = _rol
        where users.id_person = _id;
    end if;
    return _amount;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bills`
--

DROP TABLE IF EXISTS `bills`;
CREATE TABLE IF NOT EXISTS `bills` (
  `idBill` varchar(6) NOT NULL,
  `description` varchar(100) NOT NULL,
  `datebill` date NOT NULL,
  `hourBill` time NOT NULL,
  `netAmount` float(8,2) NOT NULL,
  `grossAmount` float(8,2) NOT NULL,
  `funkoID` int NOT NULL,
  `userID` int NOT NULL,
  PRIMARY KEY (`idBill`),
  KEY `funkoID` (`funkoID`),
  KEY `userID` (`userID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categories`
--

DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `categoryName` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `categories`
--

INSERT INTO `categories` (`id`, `categoryName`) VALUES
(1, 'Anime & Manga'),
(2, 'Marvel'),
(3, 'Videogames'),
(4, 'Horror'),
(5, 'DC & Comics'),
(6, 'Harry Potter'),
(7, 'Music'),
(18, 'Sports');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detailbills`
--

DROP TABLE IF EXISTS `detailbills`;
CREATE TABLE IF NOT EXISTS `detailbills` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idBill` int NOT NULL,
  `discount` int DEFAULT '0',
  `totalPrice` double(10,3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idBill` (`idBill`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `funkos`
--

DROP TABLE IF EXISTS `funkos`;
CREATE TABLE IF NOT EXISTS `funkos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `productTypeID` int NOT NULL,
  `categoryID` int NOT NULL,
  `exclusivity` int NOT NULL,
  `urlFirstImage` varchar(150) NOT NULL,
  `urlSecondImage` varchar(150) NOT NULL,
  `stock` int NOT NULL,
  `price` double(6,2) DEFAULT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `productTypeID` (`productTypeID`),
  KEY `categoryID` (`categoryID`)
) ENGINE=MyISAM AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `funkos`
--

INSERT INTO `funkos` (`id`, `name`, `productTypeID`, `categoryID`, `exclusivity`, `urlFirstImage`, `urlSecondImage`, `stock`, `price`, `description`) VALUES
(1, 'POP! BULMA IN BUNNY OUTFIT', 1, 1, 0, '/../../assets/Images///bulma1.png', '/../../assets/Images////////////////bulma2.png', 10, 15.00, 'Genius scientist, Bulma, has donned a bunny costume, resulting in hilarity and shenanigans. Complete your Dragon Ball Z collection with this exclusive Pop! Bulma in bunny outfit.'),
(2, 'POP! SUPER SAIYAN ROSE GOKU BLACK', 1, 1, 0, '/../../assets/Images/gokuBlack1.png', '/../../assets/Images///gokuBlack2.png', 12, 10.00, 'As an infant, Goku was sent to destroy Earth but ended up becoming one of the planet\'s greatest heroes after a head injury rid the young Saiyan of his senselessly destructive nature.'),
(3, 'POP! MIGHT GUY (EIGHT INNER GATES)', 1, 1, 0, '/../../assets/Images/guy1.png', '/../../assets/Images//////guy2.png', 1, 12.00, 'Open the gates! Pop! Might Guy (Eight Inner Gates) is ready to unlock his full potential in your collection. Draw on the power of Pop! Might Guy (Eight Inner Gates) and add him to your Anime team. Vinyl figure is approximately 4-inches tall.'),
(4, 'POP! NARUTO AS NINE TAILS', 1, 1, 1, '/../../assets/Images/naruto1.png', '/../../assets/Images/naruto2.png', 5, 15.00, 'Naruto is charging straight into your Naruto Shippuden set. Own your own Pop! Vinyl of Naruto in his iconic running stance. Collectible stands 3.75-inches tall.'),
(5, 'POP! MYSTERIO', 4, 2, 1, '/../../assets/Images/mysterio1.png', '/../../assets/Images/mysterio2.png', 5, 30.00, 'Bring some mystery into your Spider-Man: Beyond Amazing collection with Pop! Mysterio. This exclusive collectible features a metallic dome and glow-in-the-dark smoke. Help Spider-Man track down this villain by adding him to your Marvel set. Vinyl bobblehead is approximately 4.3-inches tall.'),
(6, 'POP! DELUXE SINISTER SIX SPIDER-MAN', 4, 2, 1, '../../assets/Images/spiderman1.png', '../../assets/Images/spiderman2.png', 3, 35.00, 'The Marvel Sinister Six series sets a whole new scene in your collection and it is exclusively available here. The Funko Pop! Deluxe Sinister Six series is comprised of 7 brand new, unique figures, which have bases that nest together to form a larger set display.'),
(7, 'POP! BATTLE READY BATMAN', 4, 5, 0, '../../assets/Images/batman1.png', '../../assets/Images/batman2.png', 8, 15.00, 'Batman™ stands ready to face The Riddler™ as he fights crime in Gotham City™. Celebrate one of DC’s most recognizable super heroes by adding the battle-ready Pop! Batman to your DC The Batman movie collection.'),
(8, 'POP! DIE-CAST BATMAN 1989', 4, 5, 1, '../../assets/Images/batmanD1.png', '../../assets/Images/batmanD2.png', 3, 50.00, 'Introducing the new Pop! Die-cast figure, designed to be the front and center, top-shelf collectible. These figures come in acrylic cases featuring etched details and fasten to the base of the case.'),
(9, 'POP! THOR WITH PIN', 3, 2, 0, '/../../assets/Images/ThorPin1.png', '/../../assets/Images/ThorPin2.png', 10, 20.00, 'Strike up an alliance with Pop! Thor to take on evil forces that might threaten your Marvel collection. When the world’s most evil villains attack, call on Earth’s Mightiest Heroes™ to save the day.'),
(10, 'POP! LEATHERFACE', 4, 4, 0, '../../assets/Images/leatherface1.png', '../../assets/Images/leatherface2.png', 10, 15.00, 'Leatherface\'s appetite has grown and he\'s decided to infiltrate your collection of horrors and The Texas Chainsaw Massacre as a Funko Pop! figure. Vinyl figure is approximately 4.5-inches tall.'),
(11, 'POP! ELVIRA (BLACK LIGHT)', 4, 4, 1, '../../assets/Images/elvira1.png', '../../assets/Images/elvira2.png', 0, 15.00, 'Spend a bewitching evening with Exclusive Pop! Elvira, in the dark! Under a black light, Pop! Elvira glows in haunting colors, and she offers you her heart. Grow your Pop! Icons collection! Vinyl figure is approximately 4-inches tall.'),
(12, 'POP! CHUCKY', 4, 4, 0, '../../assets/Images/chucky1.png', '../../assets/Images/chucky2.png', 8, 15.00, 'Schedule a playdate with Bride of Chucky Pop! Chucky. Capture him to haunt your Pop! Movies collection. Vinyl figure is approximately 4-inches tall.'),
(13, 'POP! MOMENT HAKUNA MATATA', 5, 3, 1, '../../assets/Images/MomentHakunaMatata1.png', '../../assets/Images/MomentHakunaMatata2.png', 0, 30.00, 'Let your worries melt away with Pop! Simba, Pop! Pumba, and Pop! Timon. Celebrate Disney’s 100th Anniversary by completing your The Lion King collection with this exclusive Pop! Hakuna Matata Moment.'),
(14, 'POP! DOBBY WITH DIARY', 3, 6, 0, '../../assets/Images/dobby1.png', '../../assets/Images/dobby2.png', 8, 15.00, 'He\'s finally free! Welcome home one of the most well-known and lovable house-elves of the Wizarding World with this Pop! Dobby holding the diary with its hidden sock! Wave a wand and celebrate the 20th anniversary of the Harry Potter and The Chamber of Secrets movie. Cast a spell and create magical adventures by expanding your Wizarding World set. Collect them all. Vinyl figure is approximately 3.53-inches tall.'),
(15, 'POP! PAPA EMIRITUS IV', 3, 7, 0, '../../assets/Images/emiritus1.png', '../../assets/Images/emiritus2.png', 7, 15.00, 'Legendary rock band, Ghost, is ready to take the stage in your music collection! Pray for musical salvation with Pop! Papa Emeritus IV. Who will this spectral performer collaborate with in your collection? Vinyl figure is approximately 3.95-inches tall.'),
(16, 'POP! DELUXE HARRY POTTER PUSHING TROLLEY', 3, 6, 1, '../../assets/Images/harry1.png', '../../assets/Images/harry2.png', 7, 30.00, 'Harry Potter has his luggage on the trolley but he\'s not quite sure where to go from here. Help him find his way again by adding the Pop! Deluxe Harry Potter Pushing Trolley into your collection. Vinyl figure is approximately 4-inches tall. '),
(17, 'POP! HERMIONE GRANGER', 3, 6, 0, '../../assets/Images/hermione1.png', '../../assets/Images/hermione2.png', 8, 15.00, 'Collect one of the brightest of her age, Pop! Hermione Granger, for your Harry Potter collection. As Ron once said, he and Harry, “wouldn’t last two days without her.” Collectible stands approximately 3.75-inches tall.'),
(18, 'Tobirama Senju', 1, 2, 1, '/../../assets/Images/Tobirama1.png', '/../../assets/Images/Tobirama2.png', 5, 30.00, 'Tobirama Senju Very Deluxe Edition'),
(19, 'POP! SEVERUS SNAPE', 3, 6, 0, '../../assets/Images/snape1.png', '../../assets/Images/snape2.png', 8, 15.00, 'Professor Snape has been teaching Potions at Hogwarts School of Witchcraft and Wizardry for years. Everyone knows that he really wants to teach Defense Against the Dark Arts though. Complete your Harry Potter Wizarding World collection with Pop! Severus Snape. Vinyl figure is approximately 4.5-inches tall.'),
(20, 'POP! SONIC WITH RING', 3, 3, 0, '../../assets/Images/sonic1.png', '../../assets/Images/sonic2.png', 8, 15.00, 'Pop! Sonic is one step, or rather one ring, closer to defeating Doctor Eggman in your Sonic the Hedgehog collection. Collectible stands approximately 3.75-inches tall.'),
(21, 'POP! OZZY OSBOURNE IN BLACK SUIT', 3, 7, 1, '../../assets/Images/ozzy1.png', '../../assets/Images/ozzy2.png', 5, 15.00, 'Set the stage for the Prince of Darkness in your music lineup with English singer and songwriter, Pop! Ozzy Osbourne! Who will this Funko exclusive Pop! performer collaborate with next in your Pop! Rocks collection? Or will you crush the air guitar solo while performing together? Vinyl figure is approximately 4.4-inches tall.'),
(22, 'POP! MASTER ROSHI WITH STAFF', 3, 1, 0, '../../assets/Images/rochi1.png', '../../assets/Images/rochi2.png', 9, 15.00, 'Every Dragon Ball Z collection needs to have Goku’s old instructor, Master Roshi. Collect this Pop! of Master Roshi with his staff to help your Dragon Ball Z collection keep up with their training. Collectible stands 3.75-inches tall.'),
(23, 'POP! SNOOP DOGG', 3, 7, 0, '../../assets/Images/snoop1.png', '../../assets/Images/snoop2.png', 8, 15.00, 'This legendary rapper is throwing it back to the early days of his career. Pop! Snoop Dogg wears a blue plaid shirt and khaki pants while rocking a natural hairstyle to keep things real in the world of rising rap music. Who will this artist collaborate with in your music collection? Vinyl figure is approximately 4.2-inches tall.'),
(24, 'POP! SPIDER-PUNK', 3, 2, 1, '../../assets/Images/spiderpunk1.png', '../../assets/Images/spiderpunk2.png', 4, 15.00, 'Swing into action with Pop! Spider-Punk! The threads of the multiverse web are becoming more and more complicated, and now this Funko exclusive Pop! Spider-Punk\'s adventures have led him to your Spider-Man: Across the Spider-Verse collection. Vinyl bobblehead is approximately 5-inches tall.'),
(25, 'POP! HARRY POTTER', 3, 6, 0, '../../assets/Images/harryB1.png', '../../assets/Images/harryB2.png', 4, 15.00, 'Pop! Harry Potter is dressed in his school robes, ready to discover more about his past and himself, in his first big endeavor away form the Dursley family. Collect Pop! Harry for your Harry Potter collection. Collectible stands approximately 3.75-inches tall.'),
(26, 'POP! LIGHTS AND SOUNDS THE FLASH', 4, 5, 1, '../../assets/Images/flash1.png', '../../assets/Images/flash2.png', 3, 50.00, 'Make a run for it and dash to the finish with Funko.com Exclusive Pop! The Flash. This exclusive edition of Pop! The Flash also lights up and emits sounds when activated. Complete your DC Comics collection in record time with Pop! The Flash. Vinyl figure is approximately 4.37-inches tall.'),
(27, 'POP! FREDDIE MERCURY AS KING (DIAMOND)', 3, 7, 1, '../../assets/Images/freddie1.png', '../../assets/Images/freddie2.png', 7, 15.00, 'Bring down the house with an unforgettable music moment. The Funko exclusive, diamond collection Pop! Freddie Mercury wears a bejeweled crown and cape that glimmers in the light, as seen in Queen’s sold out show at Wembley Stadium in 1986. Who will this legendary artist collaborate with in your collection? Vinyl figure is approximately 6-inches tall.'),
(28, 'POP! AETHER', 3, 3, 0, '../../assets/Images/aether1.png', '../../assets/Images/aether2.png', 8, 15.00, 'Master the elements while journeying Teyvat to find your lost sibling in Genshin Impact. The game goes beyond consoles as you can now collect your favorite characters as Funko Pop! figures! Choose your team mates wisely and build a powerful Genshin Impact collection, starting with Pop! Aether. Vinyl figure is approximately 4.75-inches tall. '),
(29, 'POP! DELUXE DEVIL\'S THRONE', 3, 3, 0, '../../assets/Images/devils1.png', '../../assets/Images/devils2.png', 8, 15.00, 'Roll the dice and take your chances! The Ruler of the underground of Inkwell Hell welcomes you with a wide grin as this Pop! Deluxe Devil’s Throne. Pop! Devil, from Cuphead, is ready for one heck of a battle, and he won’t be unseated. Are you up for the challenge? Complete your Cuphead set with Pop! Deluxe Devil’s Throne and claim victory as the sole winner. Vinyl collectible is approximately 6.15-inches tall.'),
(30, 'POP! AEROPLANE MS. CHALICE', 3, 3, 0, '../../assets/Images/chalice1.png', '../../assets/Images/chalice2.png', 8, 15.00, 'You’re up! A swell battle is in the cards with Pop! Aeroplane Ms. Chalice flying overhead. Pop! Aeroplane Ms. Chalice, from Cuphead is a real knockout in her pilot gear, the propeller of her plane spinning. Clear the runway and claim victory for your Pop! Games set. Vinyl figure is approximately 4.99-inches tall.'),
(31, 'POP! PENNYWISE CLASSIC (BLACK LIGHT)', 4, 4, 1, '../../assets/Images/it1.png', '../../assets/Images/it2.png', 10, 15.00, 'If dark places float your boat, bring a black light and accept a balloon from this exclusive Pop! Pennywise! Under a black light, Pop! Pennywise from IT comes to life, glowing in fun, creepy colors. Capture him as a killer addition to your Pop! Movies collection. Vinyl figure is approximately 4-inches tall.'),
(32, 'POP! JUMBO GIZMO WITH 3D GLASSES', 4, 4, 1, '../../assets/Images/grem1.png', '../../assets/Images/grem2.png', 10, 15.00, 'Bring this mischievous Mogwai into your Gremlins collection with this exclusive, Jumbo Pop! Gizmo holding 3D glasses. Vinyl figure is 10-inches tall.'),
(34, 'POP! COMIC COVERS WOLVERINE', 1, 2, 1, '/../../assets/Images///wolverinne1.png', '/../../assets/Images//wolverine2.png', 3, 45.00, 'Few know him by his real name, James Howlett, since he took on the name Logan and later Wolverine. He was reluctant to join the X-Men although you may be able to convince Pop! Wolverine to join your X-Men collection with this exclusive Pop! Comic Cover. Pop! Wolverine stands posed with his claws at the ready, against a backdrop of himself in the same position on the cover of an X-Men comic book.'),
(35, 'POP! JUMBO SENTINEL WITH WOLVERINE', 1, 2, 1, '/../../assets/Images//sentinel1.png', '/../../assets/Images//sentinel2.png', 5, 40.00, 'Looming large, a Sentinel is on the loose in Jumbo Pop! form. But can Pop! Mini Wolverine slash through danger with his admantium claws? Add this exclusive Marvel Studios’ X-Men Jumbo Pop! Sentinel with Wolverine to your set to help the X-Men fight back against mutant-hunting robots. There’s a 1 in 6 chance you might find the blacklight chase. Carve up some fun and expand your Marvel collection. Vinyl bobbleheads are approximately 10-inches and 2-3-inches tall.'),
(36, 'POP! JUMBO VEGETA', 1, 1, 1, '/../../assets/Images/vegeta1.png', '/../../assets/Images/vegeta2.png', 12, 15.00, '“Are you ready now to witness a power not seen for thousands of years?” Jumbo Pop! Vegeta is ready to fight for his spot in your Dragon Ball Z collection. Vinyl figure is approximately 10-inches tall.\"');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `person`
--

DROP TABLE IF EXISTS `person`;
CREATE TABLE IF NOT EXISTS `person` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL,
  `surnameOne` varchar(25) NOT NULL,
  `surnameTwo` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `person`
--

INSERT INTO `person` (`id`, `name`, `surnameOne`, `surnameTwo`) VALUES
(1, 'Diego', 'Duarte', 'Fernandez'),
(2, 'DylanSILuegoNo', 'Castillo Gaitan', 'AlfaroNoLuegoSi'),
(3, 'Diego', 'Duarte', 'Fernandez'),
(4, 'Diego', 'Duarte', 'Fernandez'),
(5, 'Diego', 'Duarte', 'Fernandez'),
(6, 'Diego', 'Duarte', 'Fernandez'),
(7, 'Diego', 'Duarte', 'Fernandez'),
(8, 'Diego', 'Duarte', 'Fernandez'),
(9, 'Diego', 'Duarte', 'Fernandez'),
(10, 'Diego', 'Duarte', 'Fernandez'),
(11, 'Diego', 'Duarte', 'Fernandez'),
(12, 'Diego', 'Duarte', 'Fernandez'),
(13, 'Diego', 'Duarte', 'Fernandez'),
(15, 'Alberto', 'Duarte', 'Fernandez'),
(18, 'DylanSILuegoNo', 'Castillo Gaitan', 'AlfaroNoLuegoSi'),
(65, 'Diego', 'Duarte', 'Diego Duarte'),
(66, 'Diego', 'Duarte', 'Diego Duarte'),
(67, 'Diego', 'Duarte', 'Diego Duarte'),
(68, 'Diego', 'Duarte', 'Diego Duarte'),
(69, 'Diego', 'Duarte', 'Diego Duarte'),
(70, 'Dylan', 'Castillo', 'Alfaro'),
(63, 'Diego', 'Duarte', 'Diego Duarte'),
(60, 'Prueba', 'Castillo Gaitan', 'AlfaroNoLuegoSi'),
(61, 'Prueba', 'Castillo Gaitan', 'AlfaroNoLuegoSi'),
(62, 'Prueba', 'Castillo Gaitan', 'AlfaroNoLuegoSi');

--
-- Disparadores `person`
--
DROP TRIGGER IF EXISTS `autoUser`;
DELIMITER $$
CREATE TRIGGER `autoUser` AFTER INSERT ON `person` FOR EACH ROW BEGIN
    INSERT INTO users (id_person, idRol) VALUES (NEW.id, 3);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producttypes`
--

DROP TABLE IF EXISTS `producttypes`;
CREATE TABLE IF NOT EXISTS `producttypes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `typeName` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `producttypes`
--

INSERT INTO `producttypes` (`id`, `typeName`) VALUES
(1, 'Pop Animation'),
(2, 'Pop Games'),
(3, 'Pop!'),
(4, 'Pop Movies'),
(5, 'Pop Disney');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rolName` varchar(25) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `rolName`) VALUES
(1, 'Administrator'),
(3, 'Person'),
(4, 'Client');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `emailAddress` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_person` int NOT NULL,
  `password` varchar(255) NOT NULL,
  `userName` varchar(25) NOT NULL,
  `idRol` int NOT NULL,
  `tkR` varchar(255) DEFAULT NULL,
  `lastAccess` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_person` (`id_person`),
  KEY `idRol` (`idRol`)
) ENGINE=MyISAM AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `emailAddress`, `id_person`, `password`, `userName`, `idRol`, `tkR`, `lastAccess`) VALUES
(3, 'dylan@gmail.com', 18, '$2y$10$hyFYAWHyF4xdvREmZX7/fufYgJyJDh/Oqs4xhpg6XWuIqRmBnYt/K', 'Rot', 1, NULL, NULL),
(50, 'diegoduarte8343676@gmail.com', 65, '$2y$10$a9rLCLtFTzWortZYB4A8uu.pnIcmIsfehq6ejo6rc.kGtkdV82ThC', 'diegoCodes143', 0, NULL, NULL),
(56, 'diegoduarte500@gmail.com', 69, '$2y$10$HZPTEodl3W0AXiCQAad84OQQRljENJS/cg2QtRCVN3pQ2Ok15n/Ie', 'diegoCodes143', 0, NULL, NULL),
(57, 'dylanCR@gmail.com', 70, '$2y$10$PMU48Pxb.XQVLrqKr85AVeVw85TwXwsP.w6rGJeVybyvw2cBK/GeW', 'rikimaru', 3, NULL, NULL),
(54, 'diego1@gmail.com', 68, '$2y$10$GtmIy9DAWxDBSBJDgzaYDeuIX0Ma0fxBclrtkz3in0Io2NAWqHXcq', 'diegoCodes143', 0, NULL, NULL),
(52, 'diegoduarte100@gmail.com', 67, '$2y$10$Tj6kwdNsg675wYCUNurPp.kLAfIxSEi3muHlZD576XcmesGjjWjAG', 'diegoCodes143', 0, NULL, NULL),
(45, 'diego@gmail.com', 60, '1234', 'Barbel', 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJmdW5rb2JhY2tlbmQiLCJpYXQiOjE2ODU1NTAxNzEsInJvbCI6MX0.O4EGq14E3LuknYSvkgMLiLPzhvddfxO-C0SL3p2M8h8', '2023-05-31 10:22:51'),
(46, 'diego@gmail.com', 61, '1234', 'Barbel', 3, ' ', '2023-06-19 21:01:00'),
(47, 'diego100@gmail.com', 62, '$2y$10$sqeS3uA.W7DQF7Q5LnY6U.07nrTPGDNylPkHZImvgQKOMux37nyxG', 'Barbel', 1, ' ', '2023-06-19 21:02:12'),
(48, 'diegoduarte8343@gmail.com', 63, '$2y$10$pah3qoizlSgAYHg8kqwba.1drmQMpsb.58VqQduDrPhwgBURDzKE2', 'diegoCodes143', 3, NULL, NULL),
(51, 'diegoduarte8@gmail.com', 66, '$2y$10$xRdRlAgRaqSEa1U/w1zfyeRL6pizgP/aUimK6oDIW6H0F9ANbQSrW', 'diegoCodes143', 0, NULL, NULL);

--
-- Disparadores `users`
--
DROP TRIGGER IF EXISTS `deleteUser`;
DELIMITER $$
CREATE TRIGGER `deleteUser` AFTER DELETE ON `users` FOR EACH ROW BEGIN
    DELETE FROM person WHERE person.id = OLD.id_Person;
END
$$
DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
