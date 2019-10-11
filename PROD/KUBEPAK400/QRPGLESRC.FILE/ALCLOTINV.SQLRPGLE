**free
  Ctl-Opt  debug option(*NODEBUGIO : *SRCSTMT );
  Ctl-Opt  dftactgrp(*no) actgrp(*caller) DatFmt(*USA);
  Ctl-Opt  thread(*serialize);

  dcl-f faliteml    usage(*output:*delete) Keyed;
  dcl-f fdlot       usage(*update)         Keyed;
  dcl-f FDLOTRDIDC  usage(*update)         Keyed;
  dcl-f FDLOTIRDRB  usage(*update)         Keyed  Rename(RDLOTRD:RDLOTRD_RB);
  dcl-f FDLOTIRDRP  usage(*update)         Keyed  Rename(RDLOTRD:RDLOTRD_Rp);


  // This program will allocate inventory for a given order line number
  dcl-pr ALCLOTINV           extpgm('ALCLOTINV');
    orderNumber              zoned(6:0)  const;
    orderSequence            zoned(3:0)  const;
    customerNumber           zoned(6:0)  const;
    item                     char(12)    const;
    size                     char(3)     const;
    mondayDate               date        const;   // Requested Date
    #qtyToAllocate           zoned(11:2) const;   // Total quantity including any changes
    allocated                zoned(11:2);         // Quantity we are able to allocate
    IMLOTC                   char(1);             // Allocated Inventory came from Lot
    ReqPartial               ind;                 // Allocation Request is for a Partial Tray
  end-pr;
  dcl-pi ALCLOTINV;
    orderNumber              zoned(6:0)  const;
    orderSequence            zoned(3:0)  const;
    customerNumber           zoned(6:0)  const;
    item                     char(12)    const;
    size                     char(3)     const;
    mondayDate               date        const;
    #qtyToAllocate           zoned(11:2) const;   //Trays qty if trays/Plug Qty for partials
    allocated                zoned(11:2);
    IMLOTC                   char(1);
    ReqPartial               ind;       // Request Partial Tray (Send '1' to Request Partial)
  end-pi;
 //______________________________________________________________________________________________
//
  Dcl-Pr GETAVLINV Extpgm('GETAVLINV');
    item                     Char(12)    Const;
    size                     Char(3)     Const;
    mondayDate               Date        Const;
    qtyToAllocate            zoned(11:2) const;
    qtyAvailable             Zoned(11:2);
    IMLOTC                   char(1);
    ReqPartial               ind;       // Request Partial Tray (Send '1' to Request Partial)//SUD01
  End-Pr;

  dcl-ds PGMSDS PSDS;
    ThisDate    char(8) pos(191);
    ThisUser    char(10) pos(254);
    ThisProgram char(10) pos(334);
  end-ds;

  dcl-s  qtyToAllocate       like(#QtyToAllocate);
  dcl-s  PartialCount        like(qtyToAllocate);
  dcl-s  qtyAvailable        Zoned(11:2);
  dcl-s  allocated2R         ind Inz(*Off);
  dcl-s  remainingToAllocate like(allocated);
  dcl-s  thisAllocation      like(allocated);
  dcl-s  qtyAllocated        like(allocated);
  dcl-s  mondayDate7         zoned(7:0);
  dcl-s  ReadyBayDate        date;
  dcl-s  AuditThis           ind inz(*On);

  //////////////////////////////////////////////////////////////////////////////
  //==========================================================================//
  //|     M A I N     P R O C E D U R E                                      |//
  //==========================================================================//
  //////////////////////////////////////////////////////////////////////////////

  Exec SQL SET OPTION COMMIT = *NONE,
                   CloSqlCsr = *EndMod;

  AuditMe(1);

  qtyToAllocate = #qtyToAllocate;

  If ReqPartial;
    PartialCount = qtyToAllocate;
    qtyToAllocate = 1;
  ENDIF;

  AuditMe(2);

  DLCLOTINV(orderNumber:orderSequence);  // Deallocate Inventory for specified order line.

  AuditMe(3);

  mondayDate7 = %int(%char(mondayDate:*CYMD0));
  GETAVLINV(item:size:mondayDate:qtyToAllocate:qtyAvailable:IMLOTC:
                ReqPartial);            // Get available qty SUD01

  AuditMe(4);

  If IMLOTC = 'N';
    //allocated =  qtyToAllocate;
    allocated =  qtyAvailable;
    Return;
   Else;

    Exec SQL Set :ReadyBayDate = READY_BAY_WEEK;

    If mondayDate <= ReadyBayDate;
      If ReqPartial;
        ALLOCATERB_Part(PartialCount);    // Allocate Ready Bay Inventory - Partials
        AuditMe(5);
       Else;
        ALLOCATERB(qtyAvailable);    // Allocate Ready Bay Inventory
        AuditMe(6);
      EndIf;
     else;
      ALLOCATE(qtyAvailable);    // Allocate future Inventory
    AuditMe(7);
    EndIf;

    allocated = qtyAvailable;

    AuditMe(8);

    Return ;

  ENDIF;

  //////////////////////////////////////////////////////////////////////////////
  //==========================================================================//
  //|     SUBPROCEDURES                                                      |//
  //==========================================================================//
  //////////////////////////////////////////////////////////////////////////////

    //-------------------------------------------------------------------------/
   //       DLCLOTINV - Deallocate Lot Inventory                              /
  //-------------------------------------------------------------------------/

  dcl-proc DLCLOTINV;
    dcl-pi *n;
      orderNumber              zoned(6:0) const;
      orderSequence            zoned(3:0) const;
    END-PI;

    setll (orderNumber:orderSequence) FALITEML;
    reade (orderNumber:orderSequence) FALITEML;
    DoW not %EOF(FALITEML);
      qtyAllocated = AIQTOA;
      AIQTOA -= AIQTOA;
      update RALITEM;
      chain (AIITEM:AISIZE:AIWHSE:AISOWD:AIGLOC:AICRDY) FDLOT;
      If %Found(FDLOT);
        LDQTAL -= qtyAllocated;
        LDQTAV += qtyAllocated;
        update RDLOT;
      ENDIF;
      chain (AIITEM:AISIZE:AICRDY:AICUST:AISOWD:AIGLOC) FDLOTRDIDC;
      If %Found(FDLOTRDIDC);
        LRQTAL -= qtyAllocated;
        LRQTAV += qtyAllocated;
        update RDLOTRD;
      ENDIF;
      reade (orderNumber:orderSequence) FALITEML;
    ENDDO;
  END-PROC;


    //-------------------------------------------------------------------------/
   //       ALLOCATERB - Allocate the Ready Bay Inventory                     /
  //-------------------------------------------------------------------------/

  dcl-proc allocateRB;
  dcl-pi *n;
    qtyToAllocate  zoned(11:2) const;
  END-PI;

    dcl-s ReadyBay IND Inz(*On);

    remainingToAllocate = qtyToAllocate;

    //Read through FDLOTIRDRB and allocate for specified customer first
    SetLL (ITEM:SIZE:customerNumber) FDLOTIRDRB;
    DoU %EOF(FDLOTIRDRB);
      ReadE (ITEM:SIZE:customerNumber) FDLOTIRDRB;
      If not %EOF(FDLOTIRDRB);
        upd_allocate(ReadyBay);
        // update RDLOTRD;
      ENDIF;
    ENDDO;

    If remainingToAllocate > 0;
    //Read through FDLOTIRDRB and allocate to any customer
    SetLL (ITEM:SIZE) FDLOTIRDRB;
    DoU %EOF(FDLOTIRDRB);
      ReadE (ITEM:SIZE) FDLOTIRDRB;
      If not %EOF(FDLOTIRDRB);
        upd_allocate(ReadyBay);
        // update RDLOTRD;
      ENDIF;
    ENDDO;

    ENDIF;

  END-PROC;

    //-------------------------------------------------------------------------/
   //       ALLOCATERB_Part - Allocate the Ready Bay Partial Inventory        /
  //-------------------------------------------------------------------------/

  dcl-proc allocateRB_Part;
  dcl-pi *n;
    qtyToAllocate  zoned(11:2) const;
  END-PI;

       dcl-ds PartialDS;
         Item_Number         like(LRITEM);
         Item_Size           like(LRSIZE);
         Customer            like(LRCUST);
         Lot_Ready_Date      like(LRCRDY);
         ReadyBayLocation    like(LRGLOC);
         Partial_Percentage  zoned(4:1);
         Partial_Found       ind;
       END-DS;

     dcl-s ReadyBay IND Inz(*On);

     Partial_Found = *off;

     Exec SQL  // Get Ready Bay Partial tray closest to what was ordered
     SELECT
               LRITEM                 as Item_Number
              ,LRSIZE                 as Item_Size
              ,LRCUST                 as Customer
              ,LRCRDY                 as Lot_Ready_Date
              ,LRGLOC                 as ReadyBayLocation
              ,LDPRTT * 100           as Partial_Percentage
              ,'1'                    as Partial_Found
     INTO    :PartialDS
     FROM     FDLOTIRDRP
         ,    FMSIZE
         ,    FLOSSLOT
     WHERE    LDITEM=LRITEM
       and    LDSIZE=LRSIZE
       and    LDREDY=LRCRDY
       and    LDSIZE=SZCODE
       and    LRITEM = :ITEM
       and    LRSIZE = :SIZE

     ORDER BY ABS(int(SZSALE * LDPRTT)- :qtyToAllocate), LRCRDY
     Fetch first row only;

    If Partial_Found;

      remainingToAllocate = 1;   // Only allocate 1 partial

      //Get Lot Record for best tray
      Chain (Item_Number:Item_Size:Customer:Lot_Ready_Date:ReadyBayLocation) FDLOTIRDRP;
      If %found(FDLOTIRDRP);
        upd_allocate(ReadyBay);
        Exec SQL  // Write FIORDRPART
          Insert into FIORDRPART
            VALUES(:orderNumber, :orderSequence, :item, :size, :Partial_Percentage);
      ENDIF;

    ENDIF;

  END-PROC;

    //-------------------------------------------------------------------------/
   //       ALLOCATE - Allocate future Inventory                              /
  //-------------------------------------------------------------------------/

  dcl-proc allocate;
  dcl-pi *n;
    qtyToAllocate  zoned(11:2) const;
  END-PI;

    dcl-s NOTReadyBay IND Inz(*Off);

    remainingToAllocate = qtyToAllocate;

    //Read through FDLOTRDIDC and allocate for specified customer first
    SetLL (ITEM:SIZE:mondayDate7:customerNumber) FDLOTRDIDC;
    DoU %EOF(FDLOTRDIDC);
      ReadE (ITEM:SIZE:mondayDate7:customerNumber) FDLOTRDIDC;
      If not %EOF(FDLOTRDIDC);
        upd_allocate(NOTReadyBay);
        // update RDLOTRD;
      ENDIF;
    ENDDO;

    If remainingToAllocate > 0;
    //Read through FDLOTRDIDC and allocate starting at customer 0
    SetLL (ITEM:SIZE:mondayDate7:0) FDLOTRDIDC;
    DoU %EOF(FDLOTRDIDC);
      ReadE (ITEM:SIZE:mondayDate7) FDLOTRDIDC;
      If not %EOF(FDLOTRDIDC);
        upd_allocate(NOTReadyBay);
        // update RDLOTRD;
      ENDIF;
    ENDDO;

    ENDIF;

  END-PROC;


    //-------------------------------------------------------------------------/
   //       Update Allocation Files                                           /
  //-------------------------------------------------------------------------/

  dcl-proc upd_allocate;
  dcl-pi *n;
    ReadyBay IND const;
  END-PI;


      If LRGLOC <> ' ' and LRGLOC <> 'R';     // Only Regular and RB inventory.  No X or S.
        return;
      ENDIF;
      If LRQTAV <= *Zero;                     // Only Available Inventory
        return;
      ENDIF;
      If LRCUST > 900000                      // No Partials or allocated Fixers
        and not (LRCUST = 999997 and ReqPartial);
        return;
      ENDIF;

      If LRQTAV >= remainingToAllocate;
        thisAllocation = remainingToAllocate;
        remainingToAllocate = *Zero;
      else;
        thisAllocation = LRQTAV;
        remainingToAllocate -= LRQTAV;
      ENDIF;

      LRQTAV -= thisAllocation;
      LRQTAL += thisAllocation;

      If ReadyBay;
        If ReqPartial;
          update RDLOTRD_Rp;
         Else;
          update RDLOTRD_RB;
        EndIf;
       else;
        update RDLOTRD;
      ENDIF;

      If LRGLOC = 'R';
        allocated2R = *On;
      ENDIF;

      Chain (LRITEM:LRSIZE:LRWHSE:LRSOWD:LRGLOC:LRCRDY) FDLOT;
      If %Found(FDLOT);
        LDQTAV -= thisAllocation;
        LDQTAL += thisAllocation;
        Update RDLOT;
      ENDIF;

      Chain (orderNumber:orderSequence:LRITEM:LRSIZE:LRSOWD:LRGLOC:LRCUST:LRCRDY) FALITEML;
      If %Found(FALITEML);
        AIQTOA = thisAllocation;
        AIDTLA = %int(%char(%date():*MDY0));       //('LAST ACTIVITY DATE')
        AITIME = %int(%char(%time():*HMS0));       //('TIME')
        AIUSER = ThisUser;                         //('USER')
        update RALITEM;
       Else;
        AIORD# = orderNumber;                      //('ORDER NUMBER')
        AIOSEQ = orderSequence;                    //('ORDER SEQ #')
        AISHPD = LRCRDY;                           //('SHIP DATE CYMD')
        AISTAT = 'A';                              //('STATUS A/D/C')
        AIITEM = LRITEM;                           //('ITEM #')
        AISIZE = LRSIZE;                           //('SIZE CODE')
        AIWHSE = LRWHSE;                           //('LOCATION')
        AISOWD = LRSOWD;                           //('SOW DATE CYMD')
        AIGLOC = LRCLOC;                           //('GROW LOC. ORIG')
        AIPHYT = LRCPHY;                           //('PHYTO CODE')
        AICRDY = LRCRDY;                           //('CURR READY DATE CYMD')
        AICUST = LRCUST;                           //('RESERV. CUST #')
        AICOMP = LRCOMP;                           //('COMPANY NO')
        AIQTOA = thisAllocation;                   //('QTY ALLOC')
        AIDTLA = %int(%char(%date():*MDY0));       //('LAST ACTIVITY DATE')
        AITIME = %int(%char(%time():*HMS0));       //('TIME')
        AIUSER = ThisUser;                         //('USER')
        AIPRCL = LRPRCL;                           //('PRODUCT CLASS')
        write RALITEM;
      ENDIF;

      return;

  END-PROC;



    //-------------------------------------------------------------------------/
   //       Write Info to the ALCLOTINV_AUDIT_TABLE                           /
  //-------------------------------------------------------------------------/

  dcl-proc AuditMe;
  dcl-pi *n;
    seq# zoned(1:0) const;
  END-PI;

  If AuditThis;
    Exec SQL
      INSERT INTO ALCLOTINV_AUDIT_TABLE   //AUDIT0001
      (ORDERNUMBER,
      ORDERSEQUENCE,
      CUSTOMERNUMBER,
      ITEM,
      ITEMSIZE,
      MONDAYDATE,
      QTYTOALLOCATE,
      QTYALLOCATED,
      ALLOCATED2RB,
      AUCRTPROG )
      VALUES(:orderNumber,
             :orderSequence,
             :customerNumber,
             :item,
             :size,
             :mondayDate,
             :#qtyToAllocate,
             :allocated,
             :allocated2R,
             substr(:ThisProgram,1,9)||char(:Seq#));
  EndIf;

  return;

  END-PROC;

