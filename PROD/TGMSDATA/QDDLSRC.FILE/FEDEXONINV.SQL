CREATE OR REPLACE FUNCTION FedExBillOnInvoice(OrderIn Int)
-- The FedExBillOnInvoice function returns the KP invoice number
-- that the FedEx Freight Charges are billed on.
--      If the freight has not been charged the function returns 0
--      If the freight is partially charged or charged on multiple
--        invoices, it will return 999999.

RETURNS Dec(6,0)
LANGUAGE SQL
NOT DETERMINISTIC

BEGIN
    DECLARE InvCount   Dec(6,0);
    DECLARE InvNo      Dec(6,0);

    SELECT Count(distinct(invoice#)) Into InvCount FROM WRITE_SHP
    WHERE OrderIn In (ORDER_1,ORDER_2,ORDER_3,ORDER_4,ORDER_5);

    If InvCount = 1 then
        SELECT DISTINCT(INVOICE#) INTO InvNo FROM WRITE_SHP
        WHERE OrderIn In (ORDER_1,ORDER_2,ORDER_3,ORDER_4,ORDER_5)
        Fetch first row only;
        RETURN InvNo;
    Elseif InvCount < 1 then
        RETURN 0;
    Else
        RETURN 999999;
    END IF;

END;
