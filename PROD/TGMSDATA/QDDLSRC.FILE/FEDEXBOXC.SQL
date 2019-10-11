CREATE OR REPLACE FUNCTION FedExBoxCount(OrderIn Int, BoxSize Char(2))
--  The FedExBoxCount function returns the count of boxes of a particular size
--  for a specific given order number.  Valid box sizes are on the Table File
--  under table code 'BX'.  Box Size UD will will give the the count of UNDEFINED
--  boxes (ie not found on XATABL)

RETURNS Dec(4,0)
LANGUAGE SQL
NOT DETERMINISTIC

BEGIN
   DECLARE BoxCount Dec(4,0);

   SELECT       COUNT(*)
   Into         BoxCount
   FROM         WRITE_SHP
   LEFT OUTER JOIN XATABE1 ON (SIZE_L*SIZE_W*SIZE_H)= TBC6 AND TBTB = 'BX'
   WHERE        OrderIn IN (ORDER_1,ORDER_2,ORDER_3,ORDER_4,ORDER_5)
      AND       SERVICE <> 112
      And       coalesce(TBSHRT, 'UD') = BoxSize

   GROUP BY     TBSHRT, TBLONG;

   RETURN BoxCount;

END;

