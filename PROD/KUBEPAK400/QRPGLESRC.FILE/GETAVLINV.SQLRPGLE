**free
  Ctl-Opt  debug option(*NODEBUGIO : *SRCSTMT )
    dftactgrp(*no) actgrp(*caller) DatFmt(*USA)
    thread(*serialize);

  dcl-pr GETAVLINV              extpgm('GETAVLINV');
    item                        char(12) const;
    size                        char(3) const;
    mondayDate                  date const;
    requested                   zoned(11:2) const;
    available                   zoned(11:2);
    IMLOTC                      char(1);
    ReqPartial                  ind;                 // Allocation Request is for a Partial Tray
  end-pr;
  dcl-pi GETAVLINV;
    item                        char(12) const;
    size                        char(3) const;
    mondayDate                  date const;
    requested                   zoned(11:2) const;
    available                   zoned(11:2);
    IMLOTC                      char(1);
    ReqPartial                  ind;                 // Allocation Request is for a Partial Tray
  end-pi;

  dcl-s Ready_Bay_Week          date;

  SqlState = '00000';
  Exec SQL SET OPTION COMMIT = *NONE,
                   CloSqlCsr = *EndMod;
  available = 0;

//exec sql
//  Create or replace table tgmsdata.getavlinv_audit
//          (in_out char(3),
//           item char(12),
//           itemsize char(3),
//           mondayDate date,
//           requested dec(11,2),
//           reqpartial char(1),
//           available dec(11,2),
//           IMLOTC char(1),
//           Time_Stamp timestamp);
  Exec SQL
  INSERT INTO
    getavlinv_audit
    VALUES('IN',
      :item,
      :size,
      :mondayDate,
      :requested,
      :reqpartial,
      :available,
      :IMLOTC,
       current timestamp);

  available = 0;

  Exec SQL Set :Ready_Bay_Week = Ready_Bay_Week;
  if ReqPartial and (mondayDate <> Ready_Bay_Week);
    IMLOTC = 'N';       // Lot Control Flag
    return;
  ENDIF;

  checkCustom_SP();     // Test if available to Sow Custom
  If available > 0;
    IMLOTC = 'N';       // Lot Control Flag
   else;
    If ReqPartial;
      checkPartLot();
     else;
      checkLot_SP();      // Test if available in LOT
    EndIf;
    IMLOTC = 'Y';       // Lot Control Flag
  EndIf;

  Exec SQL
  INSERT INTO
    getavlinv_audit
    VALUES('OUT',
      :item,
      :size,
      :mondayDate,
      :requested,
      :reqpartial,
      :available,
      :IMLOTC,
       current timestamp);

  Return ;

  //---------------------------------------------------------------------
  // Check Lot
  //---------------------------------------------------------------------
  dcl-proc  checkLot_SP;

    available = 0;

    Exec SQL
      Select  COALESCE( sum( QUANTITY_AVAILABLE ) , 0)
        into :available
        from  Inv_Plugs_Ready_union_Spec_w_holdback
       where  READY_DATE  = :mondayDate
         and  ITEM_NUMBER = :item
         and  ITEM_SIZE   = :size ;

    If available > requested;
      available = requested;
    ENDIF;

  end-proc;

  //---------------------------------------------------------------------
  // Check Partial Lot
  //---------------------------------------------------------------------
  dcl-proc  checkPartLot;
    dcl-s ReadyBayDate date(*USA);

    Exec SQL Set :ReadyBayDate = READY_BAY_WEEK;

    available = 0;
    If  mondayDate > ReadyBayDate;  // Cannot use Partials for future weeks (Return 0 available)
      Return;
    EndIf;

    Exec SQL
      Select  1
      into   :available
      from    FDLOTRD
         ,    FCALEN_ALL
      where   LRCRDY   =    CYMD7
        and   LRCUST   =    999997
        and   LRGLOC   =    'R'
        and   LRQTAV   >    0
        and   LRITEM   =   :item
        and   LRSIZE   =   :size
        and   DATEFLD  <=  :mondayDate
      Fetch First Row Only;

    //If available > requested;
    //  available = requested;
    //ENDIF;

  end-proc;

  //---------------------------------------------------------------------
  // Check Custom
  //---------------------------------------------------------------------
  dcl-proc  checkCustom_SP;
    dcl-s  NoSupplierData ind;
    dcl-s  CanSowInTime ind;

    available = 0;

    Exec SQL
      select QUANTITY_AVAILABLE
      into :available
      from KUBE_PAK_STANDARD_PLUG_INVENTORY
      join fminvt       on   ITEM_NUMBER = IMITEM
                        and  ITEM_SIZE   = IMSIZE
      where View_Control_Type = 'WEB'
        and imitem = :item
        and imsize = :size
        and READY_DATE = :mondayDate
        and SOWDATE >=
            ( case when IMFRSZ = 'CUT' then NEXT_SOW_DATE_CUT
                                       else NEXT_SOW_DATE_SEED end )
      Fetch First Row Only;

    If available = 0; // If zero in inventory check if NoSuplierData item
      NoSupplierData = *Off;
      Exec SQL // Check to see if this is a cut we do not get inventory for
        select '1'
        into    :NoSupplierData
        from KUBE_PAK_PLUGS_FROM_CUTTINGS
        where IMITEM not in
        (select KUBE_PAK_ITEM from supplier_inventory)
          and IMITEM = :item
        Fetch First Row Only;
      Exec SQL  // Check to see if we can sow this
        Select case when sowDate(:item,:size,:mondayDate)
               >= next_sow_date_cut then '1'
                                    else '0' end
        into :CanSowInTime
        from SYSIBM.SYSDUMMY1 ;
      If NoSupplierData and CanSowInTime;
        available = requested;
      ENDIF;

    ENDIF;

    If requested < available;
      available = requested;
    ENDIF;

  end-proc;
