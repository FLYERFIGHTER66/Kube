**free
  Ctl-Opt DftActGrp(*No) Option(*SrcStmt : *NoDebugIO) Debug(*Yes)

  BndDir('*LIBL/KPFUNCTION') DatFmt(*USA);
/COPY QFunctDefn,@CopyRight

  DCL-PI INVAVLSTST;
  END-PI;

  dcl-pr INVAVLSTS           extpgm('INVAVLSTS');
    ThisItem Char(12) const;   // Item
    ThisSize Char(3)  const;   // Size
    ThisDate Date     const;   // Ready Date
    ThisType Char(10) const;   // PLUG_CTL_TYPE
    ErrorNumber Zoned(1:0);    // ERROR NUMBER
    ErrorDescription Char(35); // ERROR DESCRIPTION
  end-pr;

   Dcl-S ThisItem Char(12)     Inz('10541');   // Item
   Dcl-S ThisSize Char(3)      Inz('102');    // Size
   Dcl-S thisType  char(10)    Inz('WEB');
   Dcl-S ThisDate Date;                       // Ready Date
   Dcl-S errorNumber Zoned(1:0);
   Dcl-S ErrorDescription Char(35);

   ThisDate = %date('2019-02-11');

   dsply ('==TEST============================================');
   dsply ('ITEM:' + %trim(ThisItem) + '-' + %trim(ThisSize));
   INVAVLSTS(ThisItem:ThisSize:ThisDate:thisType:ErrorNumber:ErrorDescription);
   dsply ('Error:' + %char(ErrorNumber) + ' Msg:' + %Trim(ErrorDescription));
   dsply '=End=of=Test==================================';

   *inlr = *on;
