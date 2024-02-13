USE funkoshop;
DELIMITER $$

DROP PROCEDURE IF EXISTS createDetailBill$$
CREATE PROCEDURE createDetailBill(
    _idBill VARCHAR(6),
    _funkoID INT,
    _unitPrice DOUBLE(10, 3)
)
    BEGIN
        INSERT INTO detailBills(
            idBill, 
            funkoID, 
            unitPrice
        )
        VALUES (
            _idBill, 
            _funkoID, 
            _unitPrice
        );
    END$$

DROP FUNCTION IF EXISTS deleteDetailBill$$
CREATE FUNCTION deleteDetailBill(_id INT)
    RETURNS INT
        BEGIN
            DECLARE rowsAffected INT;

            DELETE FROM detailBills WHERE idDetail = _id;
            SET rowsAffected = ROW_COUNT();
        RETURN rowsAffected;
    END$$
