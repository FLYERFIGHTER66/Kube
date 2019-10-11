CREATE OR REPLACE FUNCTION isFedExOrder(OrderIn Int)
-- The isFedExOrder() function return true ('1') if the order number
-- is found in the WRITE_SHP file.  Otherwise it returns '0'.

RETURNS Char(1)
LANGUAGE SQL
NOT DETERMINISTIC

BEGIN
    DECLARE isFedEx Char(1);

    Set isFedEx = '0';

    Select '1' Into isFedEx From WRITE_SHP
        Where OrderIn in (ORDER_1,ORDER_2,ORDER_3,ORDER_4,ORDER_5)
        Fetch First Row Only;

    RETURN isFedEx;

END;

