USE funkoshop;
DELIMITER $$

DROP FUNCTION IF EXISTS createBill$$
CREATE FUNCTION createBill(
    _idBill VARCHAR(6) ,
    _description VARCHAR(100),
    _dateBill DATE,
    _hourBill TIME,
    _discount INT,
    _tax INT,
    _netAmount FLOAT(8, 2),
    _grossAmount FLOAT(8, 2),
    _userID INT
) RETURNS INT(1)

BEGIN 
    DECLARE _qRegister int;
    SELECT count(idBill) INTO _qRegister FROM bills WHERE idBill = _idBill;
    if _qRegister = 0 THEN

        INSERT INTO bills (
            idBill, 
            description,
            dateBill,
            hourBill,
            discount,
            tax,
            netAmount,
            grossAmount,
            userID
        ) VALUES (
            _idBill,
            _description, 
            _dateBill,
            _hourBill,
            _discount,
            _tax,
            _netAmount, 
            _grossAmount,
            _userID
        );
    ELSE
        SET _qRegister = 1;
    END IF;
    RETURN _qRegister;
END$$
