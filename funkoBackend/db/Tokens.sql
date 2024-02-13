USE taller;
alter table users 
    add tkR varchar(255) null,
    add lastAccess datetime null;

DROP FUNCTION IF EXISTS modifyToken;
DROP PROCEDURE IF EXISTS verifyToken;

DELIMITER $$
DROP FUNCTION IF EXISTS modifyToken$$ 
CREATE FUNCTION modifyToken (_id_person VARCHAR(15), _tkR varchar(255)) RETURNS INT(1) 
begin
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

DELIMITER $$
DROP PROCEDURE IF EXISTS verifyToken$$
CREATE PROCEDURE verifyToken (_id_person VARCHAR(15), _tkR varchar(255)) 
begin
    select idRol from users where id_person = _id_person and tkR = _tkR;
end$$

DELIMITER ;