DELIMITER $$
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `stringFilter`(`_parameters` VARCHAR(250), `_camps` VARCHAR(50)) RETURNS varchar(250) CHARSET utf8mb4
begin
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
DELIMITER ;

