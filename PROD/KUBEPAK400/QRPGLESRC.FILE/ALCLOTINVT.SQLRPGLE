**free
  Ctl-Opt DftActGrp(*No) Option(*SrcStmt : *NoDebugIO) Debug(*Yes)

  BndDir('*LIBL/KPFUNCTION') DatFmt(*USA);
/COPY QFunctDefn,@CopyRight

  dcl-pr ALCLOTINV           extpgm('ALCLOTINV');
    orderNumber              zoned(6:0) const;
    orderSequence            zoned(3:0) const;
    customerNumber           zoned(6:0) const;
    item                     char(12) const;
    size                     char(3) const;
    mondayDate               date const;          // Requested Date
    qtyToAllocate            zoned(11:2) const;   // Total quantity including any changes
    allocated                zoned(11:2);         // Quantity we are able to allocate
    wklotc                   char(1);
    ReqPartial               ind Const;           // Allocation Request is for a Partial Tray
  end-pr;

  Dcl-Pr GETAVLINV Extpgm('GETAVLINV');           // Rpg Program
     Item      Char(12)    Const;                 // Item
     Size      Char(3)     Const;                 // Size
     ReqDate   Date        Const;                 // ReqShipDate
     ReqQty    Zoned(11:2) Const;                 // Requested Qty
     AvlQty    Zoned(11:2);                       // Available Qty
     IMLOTC    Char(1);                           // Lot Control Flag
     ReqPartial              ind  Const;          // Allocation Request is for a Partial Tray
   End-Pr;

   Dcl-S myOrder  zoned(6:0) Inz(271097);

   Dcl-S myItem1  char(12) Inz('8363');
   Dcl-S mySize  char(3) Inz('102');
   Dcl-S RqQty   Zoned(11:2) Inz;
   Dcl-S WkQty   Zoned(11:2) Inz;
   Dcl-S WkDate  date;
   Dcl-S LotFlag char(1);

   wkDate = %date('04/22/2019' : *USA);
   dsply '==TEST============================================';
   dsply ('Test Order: ' + %char(myOrder) + ' date: ' + %char(wkDate:*iso));


   rqQty = 200;
   LotFlag = ' ';
   dsply ('Item 1: ' + %trim(myItem1));
   dsply ('Requseted: ' + %char(RqQty) + ' Lot: ' + LotFlag);
   GETAVLINV(myItem1 : mySize : wkdate : RqQty :wkqty : LotFlag :'0');
   dsply ('Available: ' + %char(wkQty) + ' Lot: ' + LotFlag);
   ALCLOTINV(myOrder:010:8069:myItem1:mySize:wkdate:RqQty:wkqty:LotFlag:'0');
   dsply ('Allocated: ' + %char(wkQty) + ' Lot: ' + LotFlag);

   dsply '=End=of=Test==================================';

   *inlr = *on;
