CREATE OR REPLACE FUNCTION FedExBillAmount(OrderIn Int)
-- The FedExBillAmount function returns the total of all freight charges
-- for ant l

RETURNS DECIMAL(10,2)
LANGUAGE SQL

BEGIN
   DECLARE BillAmt DECIMAL(10,2) ;

   Select Sum(NETCHARGE) into BillAmt From WRITE_SHP
     Where OrderIn in (ORDER_1,ORDER_2,ORDER_3,ORDER_4,ORDER_5) ;

   RETURN BillAmt ;
END ;
