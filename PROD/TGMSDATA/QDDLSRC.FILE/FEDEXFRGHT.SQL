CREATE OR REPLACE FUNCTION FedExBoxSizeFreight(OrderIn Int, BoxSize Char(2))
--  The FedExBoxSizeFreight fucntion returns the Freight for boxes of a particular size
--  for a specific given order number.  Valid box sizes are on the Table File
--  under table code 'BX'.  Box Size UD will will give the the count of UNDEFINED
--  boxes (ie not found on XATABL)

RETURNS DECIMAL(10,2)
LANGUAGE SQL
NOT DETERMINISTIC

BEGIN
   DECLARE Freight DECIMAL(10,2);

   Select Sum(NETCHARGE)
   Into   Freight
   From   WRITE_SHP
   Left   Outer Join XATABE1 ON (SIZE_L*SIZE_W*SIZE_H)= TBC6 AND TBTB = 'BX'
   Where  OrderIn IN (ORDER_1,ORDER_2,ORDER_3,ORDER_4,ORDER_5)
   And    COALESCE(TBSHRT, 'UD') = BoxSize
   Group By     TBSHRT, TBLONG;

   RETURN Freight;

END;

