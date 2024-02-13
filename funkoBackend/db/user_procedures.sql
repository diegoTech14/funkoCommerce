USE funkoshop;
DELIMITER $$


DELIMITER $$
DROP FUNCTION searchUserByEmail$$
CREATE PROCEDURE searchUserByEmail(_emailAddress VARCHAR(100)) 
    begin
	SELECT * FROM users WHERE emailAddress COLLATE utf8mb4_unicode_ci LIKE CONCAT('%', _emailAddress, '%');
end$$
DELIMITER;


DELIMITER $$
DROP FUNCTION IF EXISTS createUser$$
CREATE FUNCTION createUser(_id_Person INT, _emailAddress VARCHAR(100), _password VARCHAR(255), _userName VARCHAR(25)) RETURNS int
BEGIN
    DECLARE _cant int;
    select count(id) into _cant from users where id_Person = _id_Person;
    
    if _cant > 0 THEN
    UPDATE users
    SET emailAddress = _emailAddress,
        password = _password,
        userName = _userName,
        idRol = 0
    WHERE id_person = _id_Person;
    end if;
 
    RETURN _cant;
END$$
DELIMITER ;

DELIMITER $$
DROP FUNCTION IF EXISTS deleteUser$$
CREATE FUNCTION deleteUser (_id INT) RETURNS int
BEGIN
    DECLARE rowsAffected INT;
    
    DELETE FROM users WHERE id_Person = _id;
    SET rowsAffected = ROW_COUNT();
    
    RETURN rowsAffected;
END$$
DELIMITER ;

DELIMITER $$
DROP FUNCTION IF EXISTS editUser$$
CREATE FUNCTION editUser (_id_Person INT, _emailAddress VARCHAR(100), _password VARCHAR(255), _userName VARCHAR(25)) RETURNS int
begin
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
DELIMITER;


DELIMITER $$
DROP PROCEDURE IF EXISTS filterUser$$
CREATE PROCEDURE filterUser (IN _parameters VARCHAR(250), IN _page SMALLINT UNSIGNED, IN _cantRegs SMALLINT UNSIGNED)
begin
    SELECT stringFilter(_parameters, 'id&emailAddress&id_person&password&userName&idRol&') INTO @filter;
    SELECT concat("SELECT * from users where ", @filter, " LIMIT ", 
        _page, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
end$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS searchUser$$
CREATE DEFINER=`root`@`localhost` PROCEDURE searchUser(_id INT, _idPerson INT)
begin
    select * from users where id_person = _idPerson OR id = _id;
end$$
DELIMITER ;

DELIMITER $$
DROP FUNCTION IF EXISTS userPassword$$
CREATE FUNCTION userPassword (
    _emailAddress VARCHAR(100), 
    _passw Varchar(255)
    ) RETURNS INT(1) 
BEGIN
    DECLARE _amount INT;
    SELECT COUNT(id) INTO _amount FROM users WHERE emailAddress COLLATE utf8mb4_unicode_ci LIKE CONCAT('%', _emailAddress, '%');
    IF _amount > 0 THEN
        UPDATE users SET password = _passw WHERE emailAddress COLLATE utf8mb4_unicode_ci LIKE CONCAT('%', _emailAddress, '%');
    END IF;
    RETURN _amount;
end$$
DELIMITER ;

DELIMITER $$ 
DROP FUNCTION IF EXISTS lastId$$
CREATE FUNCTION lastId() RETURNS INT
    BEGIN
        DECLARE _quant int;
        SELECT id INTO _quant FROM person ORDER BY id DESC LIMIT 1;
    return _quant+1;
    END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=root@localhost FUNCTION editUserRol(_id_Person INT, _rol INT) RETURNS int
BEGIN
    DECLARE _cant INT;
    SELECT COUNT(id) INTO _cant FROM users WHERE id_Person = _id_Person;
    IF _cant > 0 THEN
        UPDATE users SET
            idRol = _rol
        WHERE id_Person = _id_Person;
    END IF;
    RETURN _cant;
END$$
DELIMITER ;