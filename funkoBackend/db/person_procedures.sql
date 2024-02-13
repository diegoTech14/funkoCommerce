DELIMITER $$
CREATE FUNCTION createPerson(_name VARCHAR(25), _surnameOne VARCHAR(25), _surnameTwo VARCHAR(25)) RETURNS int
BEGIN
    DECLARE _cant int;
    INSERT INTO person (name, surnameOne, surnameTwo)
    VALUES (_name, _surnameOne, _surnameTwo);
    set _cant=1;
    RETURN _cant;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `editPerson`(
    _id int, 
    _name Varchar(25),
    _surnameOne Varchar (25),
    _surnameTwo Varchar (25)) RETURNS int
begin
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
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `filterPerson`(
    _parameters varchar(100), 
    _page SMALLINT UNSIGNED, 
    _cantRegs SMALLINT UNSIGNED)
begin
    SELECT stringFilter(_parameters, 'id&name&surnameOne&surnameTwo&') INTO @filter;
    SELECT concat("SELECT * from person where ", @filter, " LIMIT ", 
        _page, ", ", _cantRegs) INTO @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;  
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `searchPerson`(IN `_idPerson` INT)
begin
    select * from person where id = _idPerson;
end$$
DELIMITER ;