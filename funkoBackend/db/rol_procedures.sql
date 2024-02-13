USE fukoshop;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `createRol`(`_rolName` VARCHAR(25)) RETURNS int
BEGIN
    DECLARE _cant INT;
    INSERT INTO roles (rolName) VALUES (_rolName);
    SET _cant = 1;
    RETURN _cant;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `deleteRol`(_idRol INT) RETURNS int
BEGIN
    DECLARE rowsAffected INT;
    
    DELETE FROM roles WHERE id = _idRol;
    SET rowsAffected = ROW_COUNT();
    
    RETURN rowsAffected;
END$$
DELIMITER ;

DELIMITER $$
DROP FUNCTION IF EXISTS userRol$$
CREATE FUNCTION userRol (
    _id int, 
    _rol int
    ) RETURNS INT(1) 
begin
    declare _amount int;
    select count(id) into _amount from users where users.id = _id;
    if _amount > 0 then
        update users set
            idRol = _rol
        where users.id = _id;
    end if;
    return _amount;
end$$