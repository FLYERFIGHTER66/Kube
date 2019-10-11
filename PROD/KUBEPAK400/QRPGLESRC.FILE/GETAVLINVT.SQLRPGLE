**free
   Ctl-Opt DftActGrp(*No) Option(*SrcStmt : *NoDebugIO) Debug(*Yes)
    BndDir('*LIBL/KPFUNCTION') DatFmt(*USA);
  /COPY QFunctDefn,@CopyRight

   Dcl-Pr GETAVLINV Extpgm('GETAVLINV');           // Rpg Program
      Item      Char(12)    Const;                 // Item
      Size      Char(3)     Const;                 // Size
      ReqDate   Date        Const;                 // ReqShipDate
      ReqQty    Zoned(11:2) Const;                 // Requested Qty
      AvlQty    Zoned(11:2);                       // Available Qty
      IMLOTC    Char(1);                           // Lot Control Flag
      ReqPartial    ind     Const;                 // Allocation Request is for a Partial Tray
    End-Pr;

    Dcl-S ThisItem Char(12)   Inz('5756');
    Dcl-S ThisSize Char(3)   Inz('102');
    Dcl-S RqQty   Zoned(11:2) Inz(30);
    Dcl-S AvQty   Zoned(11:2) Inz(0);
    Dcl-S WkDate  date;
    Dcl-S LotFlag char(1);

    wkDate = %date('03/11/2019' : *USA);

    // TEST
    dsply '__T_E_S_T___________________';
    dsply ('Item: ' + %trim(ThisItem) + '-' + %trim(ThisSize) +
          ' Date: ' + %char(wkDate));
    GETAVLINV(ThisItem:ThisSize:wkDate:RqQty:AvQty:LotFlag:'0');
    dsply ('Request full:   ' + %char(RqQty));
    dsply ('Available full: ' + %char(AvQty));
    dsply ('Lot Control:    ' + LotFlag);
    dsply '_Req_Parts_ _ _ _ _ _ _ _ _';
    RqQty = 85;
    GETAVLINV(ThisItem:ThisSize:wkDate:RqQty:AvQty:LotFlag:'1');
    dsply ('Request Part:   ' + %char(RqQty));
    dsply ('Available Part: ' + %char(AvQty));
    dsply ('Lot Control:    ' + LotFlag);
    dsply '____________________________';

    *inlr = *on;
