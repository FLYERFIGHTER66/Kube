CREATE OR REPLACE FUNCTION FedExBoxingCharges(OrderIn Int, BoxSize Char(2))
--  The FedExBoxSizeFreight fucntion returns the Freight for boxes of a particular size
--  for a specific given order number.  Valid box sizes are on the Table File
--  under table code 'BX'.  Box Size UD will will give the the count of UNDEFINED
--  boxes (ie not found on XATABL)

RETURNS CHAR(15)
LANGUAGE SQL
NOT DETERMINISTIC

BEGIN
   DECLARE Boxing CHAR(15);

      Select TBSHRT
      Into Boxing
      From XATABE1
      Left Outer Join WRITE_SHP ON TBC6 = (SIZE_L*SIZE_W*SIZE_H)
      And TBTB = 'BC'
      Where  OrderIn IN (ORDER_1,ORDER_2,ORDER_3,ORDER_4,ORDER_5)
        And    SERVICE <> '92'
        OR     BILL_TO <> '301886977'
        And    Coalesce(TBSHRT, 'UD') = BoxSize
      GROUP BY     TBSHRT, TBLONG;

      Return Boxing;

END;

