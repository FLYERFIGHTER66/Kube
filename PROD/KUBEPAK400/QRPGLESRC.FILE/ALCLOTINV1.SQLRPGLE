**free
  Ctl-Opt  debug option(*NODEBUGIO : *SRCSTMT );
  Ctl-Opt  dftactgrp(*no) actgrp(*caller) DatFmt(*USA);
  Ctl-Opt  thread(*serialize);

  dcl-f fhordr usage(*update) Keyed;
  dcl-f fdlot usage(*update) Keyed;
  dcl-f fdlotrd usage(*update) Keyed;

  // This program will allocate inventory for a given order line number
  dcl-pr ALCLOTINV           extpgm('ALCLOTINV');
    orderNumber              zoned(6:0) const;
    orderSequence            zoned(3:0) const;
    customerNumber           zoned(6:0) const;
    item                     char(12) const;
    size                     char(3) const;
    mondayDate               date const;          // Requested Date
    qtyToAllocate            zoned(11:2) const;   // Total quantity including any changes
    allocated                zoned(11:2);         // Quantity we are able to allocate
  end-pr;
  dcl-pi ALCLOTINV;
    orderNumber              zoned(6:0) const;
    orderSequence            zoned(3:0) const;
    customerNumber           zoned(6:0) const;
    item                     char(12) const;
    size                     char(3) const;
    mondayDate               date const;
    qtyToAllocate            zoned(11:2) const;
    allocated                zoned(11:2);
  end-pi;
  Dcl-Pr GETAVLINV Extpgm('GETAVLINV');
    item                     Char(12)    Const;
    size                     Char(3)     Const;
    mondayDate               Date        Const;
    qtyToAllocate            zoned(11:2) const;
    qtyAvailable             Zoned(11:2);
  End-Pr;

  dcl-s  qtyAvailable             Zoned(11:2);

  Exec SQL SET OPTION COMMIT = *NONE,
                   CloSqlCsr = *EndMod;

  DLCLOTINV(orderNumber:orderSequence);  // Deallocate Inventory for specified order line.
  GETAVLINV(item:size:mondayDate:qtyToAllocate:qtyAvailable);  // Get available qty
  allocated = ALLOCATE(qtyAvailable);    // Allocate

  Return ;
  //============================================================================
  //      SUBPROCEDURES
  //============================================================================

  //-------DLCLOTINV - Deallocate Lot Inventory---------------------------------
  dcl-proc DLCLOTINV;
    dcl-pi *n;
      orderNumber              zoned(6:0) const;
      orderSequence            zoned(3:0) const;
    END-PI;

    setll (orderNumber:orderSequence) FALITEM;
    reade (orderNumber:orderSequence) FALITEM;
    DoW not %EOF(FALITEM);
      qtyAllocated = AIQTOA;
      AIQTOA -= AIQTOA;
      update RALITEM;
      chain (AIITEM:AISIZE:AIWHSE:AISOWD:AIGLOC:AICRDY) FDLOT;
      If %Found(FDLOT);
        LDQTAL -= qtyAllocated;
        LDQTAV += qtyAllocated;
        update RDLOT;
      ENDIF;
      chain (AIITEM:AISIZE:AIWHSE:AISOWD:AICRDY:AICUST:AIGLOC) FDLOTRD;
      If %Found(FDLOTRD);
        LRQTAL -= qtyAllocated;
        LRQTAV += qtyAllocated;
        update RDLOTRD;
      ENDIF;
      reade (orderNumber:orderSequence) FALITEM;
    ENDDO;
  END-PROC;

  //-------ALLOCATE - Allocate the Inventory------------------------------------
  dcl-proc allocate;
    //Read through FDLOTRD and allocate


  END-PROC;
