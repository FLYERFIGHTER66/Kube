**free
Ctl-Opt  debug option(*NODEBUGIO : *SRCSTMT )
         dftactgrp(*no) actgrp(*caller)
         DatFmt(*USA)
         BndDir('*LIBL/KPFUNCTION')
         ALWNULL(*InputOnly)
         thread(*serialize);

/include QFunctDefn,@CopyRight

dcl-pr RBR800 extpgm;
END-PR;

/include QFunctDefn,$DFTPRT
/include QFunctDefn,$CHGPRT
/include QFunctDefn,$PRINTPICK
/include QFunctDefn,$Date
/include QFunctDefn,$MDYDate

Dcl-Pr $OrderInq Extpgm('BIR255CLO');
 Order# Packed(6:0) Const;
End-Pr;

dcl-f RBR800FM Workstn Sfile(RBR80003:RRN03);

// Program Status Data Structure : PSDS
Dcl-Ds Pgmstatus PSDS;
  Job     Char(10) Pos(244);
  User    Char(10) Pos(254);
  Rundate Zoned(6) Pos(276);
  Runtime Zoned(6) Pos(282);
  Pgm     Char(10) Pos(334);
End-Ds;

dcl-s ThisWeek date;
dcl-s RRN03 zoned(4:0);
dcl-s ErrorCount01 zoned(3:0);
dcl-s ErrorCount02 zoned(3:0);
dcl-s ErrorCount03 zoned(3:0);
dcl-s EndOfFile ind;
dcl-s Screen zoned(2:0);
dcl-s RecordCount zoned(4:0);

dcl-s Time_In Char(19);
dcl-s Time_Out Char(19);
dcl-s SEL_CUSNAM$ Char(17);


DOU *INLR = *ON;
  SELECT;
    WHEN Screen = 1;
      Edit01();
    WHEN Screen = 2;
      Edit02();
    WHEN Screen = 3;
      Edit03();
    OTHER;
      Load03();
      Scrn03();
  ENDSL;
ENDDO;

*InLR = *On;
Return;

//  ============================================================================
//  =                                                                          =
//  =   S C R E E N  -1-    R E C E I V E D   O R D E R S                      =
//  =                                                                          =
//  ============================================================================

//  ...........................................................
//  :      Scrn01 - Display Screen 01                         :
//  :.........................................................:
dcl-proc Scrn01;

  Screen = 01;
  Write ASSUME;
  If ErrorCount01 <> *Zero;
    Write MSGCTL;
  EndIf;
  ExFmt RBR80001;
  //ClrError();
  ErrorCount01 = *Zero;

End-proc;

//  ...........................................................
//  :      Load01 - Load Screen 01                            :
//  :.........................................................:
dcl-proc Load01;

  RECIEVED = *zero;

end-proc;


//  ...........................................................
//  :      Edit01 - EDIT Screen 01                            :
//  :.........................................................:
dcl-proc Edit01;

  //  Process pre-edit Functions F3, F6, F7 & F9
  SELECT;
  //  Display Log Requested
  When *In01;
    Load03();
    Scrn03();
  //  Cancel Requested
  When *In03;
    *InLR = *On;
  //  Receive Picks Requested
  When *In07;
    Load01();
    Scrn01();
  //  Complete Picks Requested
  When *In08;
    Load02();
    Scrn02();
  //  If no Functions, Edit screen values
  OTHER;
    If isOrder(RECIEVED);
      Exec SQL
        Insert into Ready_Bay_Pick_Log
        (RB_ORDER_NUMBER, RB_IN_OR_OUT)
        VALUES(:RECIEVED, 'I');
    ENDIF;
    Load01();
    scrn01();
  ENDSL;

end-proc;



//  ============================================================================
//  =                                                                          =
//  =   S C R E E N  -2-                                                       =
//  =                                                                          =
//  ============================================================================


//  ...........................................................
//  :      Scrn02 - Display Screen 02                         :
//  :.........................................................:
dcl-proc Scrn02;

  Screen = 02;
  Write ASSUME;
  If ErrorCount02 <> *Zero;
    Write MSGCTL;
  EndIf;
  ExFmt RBR80002;
  //ClrError();
  ErrorCount02 = *Zero;

End-proc;

//  ...........................................................
//  :      Load02 - Load Screen 02                            :
//  :.........................................................:
dcl-proc Load02;

  COMPLETED = *zero;

end-proc;


//  ...........................................................
//  :      Edit02 - EDIT Screen 02                            :
//  :.........................................................:
dcl-proc Edit02;

  //  Process pre-edit Functions F3, F6, F7 & F9
  SELECT;
  //  Display Log Requested
  When *In01;
    Load03();
    Scrn03();
  //  Cancel Requested
  When *In03;
    *InLR = *On;
  //  Receive Picks Requested
  When *In07;
    Load01();
    Scrn01();
  //  Complete Picks Requested
  When *In08;
    Load02();
    Scrn02();
  //  If no Functions, Edit screen values
  OTHER;
    If isOrder(COMPLETED);
      Exec SQL
        Insert into Ready_Bay_Pick_Log
        (RB_ORDER_NUMBER, RB_IN_OR_OUT)
        VALUES(:COMPLETED, 'O');
    ENDIF;
    Load02();
    scrn02();
  ENDSL;

end-proc;


//  ============================================================================
//  =                                                                          =
//  =   S C R E E N  -3-                                                       =
//  =                                                                          =
//  ============================================================================



//  ...........................................................
//  :      Scrn03 - Display Screen 03                         :
//  :.........................................................:
dcl-proc Scrn03;
  Screen = 03;
  *In25 = *On;
  Write ASSUME;
  Write RBR80003F;
  If ErrorCount03 <> *Zero;
    Write MSGCTL;
  EndIf;
  STARTRRN03 = SFLCSRRRN;
  If STARTRRN03 = 0;
    STARTRRN03 = 1;
  ENDIF;
  Records03 = RecordCount;
  ExFmt RBR80003C;
  //ClrError();
  ErrorCount03 = *Zero;
  *In25 = *Off;
End-proc;

//  ...........................................................
//  :      Load03 - Load Screen 03                            :
//  :.........................................................:
dcl-proc Load03;
  // Populate printer if not already Selected
  If Printer = *blanks;
    Printer = $DFTPRT(User:Pgm:'*PGM');
  ENDIF;
  //  Clear the Subfile
  OPTION03 = *Blanks;
  *In25 = *Off;
  *In26 = *Off;
  *In27 = *Off;
  Write RBR80003C;

  RRN03       = *zero;
  RecordCount  = *zero;

  If SEL_CUSNAM <> *blank;
    SEL_CUSNAM$ = '%' + %trim(SEL_CUSNAM) + '%';
   else;
    SEL_CUSNAM$ = *Blanks;
  ENDIF;

  OpenData03();
  ReadData03();
  DoW not EndOfFile and RRN03 < 9999;
    //  Load screen fields

    //  Write Subfile Record
    RRN03 += 1;
    *In29 = isEven(RRN03);
    *In26 = *On;
    Write RBR80003;
    ReadData03();
  EndDo;

  IF *In26 = *On;
   Chain RRN03 RBR80003;
    *In27 = *On;
    Update RBR80003;
  EndIF;

  CloseData03();

  STARTRRN03 = 1;
  SFLCSRRRN = 0;

end-proc;


//  ...........................................................
//  :      Edit03 - EDIT Screen 03                            :
//  :.........................................................:
dcl-proc Edit03;

  //  Process pre-edit Functions F3, F6, F7 & F9
  SELECT;
  //  Cancel Requested
  When *In03;
    *InLR = *On;
  //  Toggle Destination
  //  Refresh/Reselect Requested
  When *In05;
    Load03();
    Scrn03();
  //  Toggle Open/All items (Scanned Out)
  When *In06;
    If SEL_LOG_OU = 'Y' or SEL_LOG_OU = ' ';
      SEL_LOG_OU = 'N';
     Else;
      SEL_LOG_OU = ' ';
    ENDIF;
    Load03();
    Scrn03();
  //  Receive Picks Requested
  When *In07;
    Load01();
    Scrn01();
  //  Complete Picks Requested
  When *In08;
    Load02();
    Scrn02();
  //  Change Printer Requested
  When *In10;
    Printer = $CHGPRT(User:Pgm:'*PGM');
    Scrn03();
  //  If no Functions, Check for Options.
  OTHER;
      Opts03();
    //  If Update Requested then Update file else redisplay
      //UpdateFiles02();
      Load03();
      Scrn03();
  ENDSL;

end-proc;

//   ...........................................................
//   :      Opts03 - Process Screen 02 Options                 :
//   :.........................................................:
dcl-proc Opts03;

  ReadC RBR80003;
  DoW not %EOF(RBR800FM);
    *In50 = *Off;
    *In28 = *Off;

    Select;
    When OPTION03 = 'V' or OPTION03 = '5';
      $OrderInq(OHORD#);
    When OPTION03 = 'P' or OPTION03 = '6';
      $PrintPick(OHORD#:Printer:'001':'N');
    When OPTION03 = '7';
      Exec SQL
        Insert into Ready_Bay_Pick_Log
        (RB_ORDER_NUMBER, RB_IN_OR_OUT)
        VALUES(:OHORD#, 'I');
    When OPTION03 = '8';
      Exec SQL
        Insert into Ready_Bay_Pick_Log
        (RB_ORDER_NUMBER, RB_IN_OR_OUT)
        VALUES(:OHORD#, 'O');
    EndSl;
    *In28 = *On;
    Update RBR80003;
    ReadC RBR80003;
  EndDo;

end-proc;

//   ...........................................................
//   :      OpenData02 - Run SQL to select Data for Screen 02  :
//   :.........................................................:

dcl-proc OpenData03;

  //  Get FDLOTRD Data matching request
  exec sql

    DECLARE   C3 cursor for

    Select
      OHORD#,
      OHCUST,
      OHNAME,
      OHSHPC,
      svia.svdesc,
      coalesce(substr(cast(min(RBIN.CREATED_TS) as char(30)),1,19),' - no in scan -'),
      coalesce(substr(cast(max(RBOUT.CREATED_TS) as char(30)),1,19),' - no out scan -')
    from FHORDR  as HDR
    join XATABE1 as RB
        on OHSHPC = TBC6
       and TBTB = 'RB'
    join FMSVIA as svia on hdr.ohshpc = svia.svcode
    left outer join Ready_Bay_Pick_Log as RBIN
        on hdr.OHORD# = RBIN.RB_ORDER_NUMBER and RBIN.RB_IN_OR_OUT = 'I'
    left outer join Ready_Bay_Pick_Log as RBOUT
        on hdr.OHORD# = RBOUT.RB_ORDER_NUMBER and RBOUT.RB_IN_OR_OUT = 'O'

    WHERE OHSTAT = 'A'
      and (OHORD# = :Sel_Order or :Sel_Order = 0)
      and (OHCUST = :Sel_Cust or :Sel_Cust = 0)
      and (OHNAME like :SEL_CUSNAM$ or :SEL_CUSNAM$ = ' ')
      and (  ( :SEL_LOG_IN = 'N' and RBIN.CREATED_TS is null )
          or ( :SEL_LOG_IN = 'Y' and RBIN.CREATED_TS is not null )
          or   :SEL_LOG_IN = ' ' )
      and (  ( :SEL_LOG_OU = 'N' and RBOUT.CREATED_TS is null )
          or ( :SEL_LOG_OU = 'Y' and RBOUT.CREATED_TS is not null )
          or   :SEL_LOG_OU = ' ' )

    GROUP BY
      OHORD#,
      OHCUST,
      OHNAME,
      OHSHPC,
      svia.svdesc

    ORDER BY OHORD#

    For Read only;


    //  Open the SQL recordset
    exec sql Close C3;
    exec sql Open C3;

   end-proc;

   //   ...........................................................
   //   :      CloseData03 - Close the Screen 03 Data Set         :
   //   :.........................................................:

dcl-proc CloseData03;
//  Close the SQL recordset
    exec sql Close C3;
end-proc;

//   ...........................................................
//   :      ReadData03 - Read Data for Screen 02               :
//   :.........................................................:

dcl-proc ReadData03;
  //  Read Sow Schedule Records for Selected Week
  exec sql
  Fetch C3 into :ohord#,:ohcust,:ohname,:ohshpc,:svdesc,:time_in,:time_out;

  If SQLSTT = '02000';
    EndOfFile = *On;
  Else;
    EndOfFile = *Off;
    RecordCount = RecordCount + 1;
  EndIf;



end-proc;

//  ============================================================================
//  =                                                                          =
//  =   S U B P R O C E D U R E S                                              =
//  =                                                                          =
//  ============================================================================

//   ...........................................................
//   :      isOrder(Order Number to Check)
//   :.........................................................:

dcl-proc isOrder;
  dcl-pi *n ind;
    Order_Number zoned(6:0) const;
  END-PI;

  dcl-s isOrder_ind ind inz(*off);

  exec sql
    Select '1' into :isOrder_ind from FHORDR
      WHERE OHSTAT = 'A' and OHORD# = :Order_Number
      Fetch first row only;

  return isOrder_ind;

end-proc;



//   ...........................................................
//   :      isCustomer(Customer Number to Check)
//   :.........................................................:

dcl-proc isCustomer;
  dcl-pi *n ind;
    Customer_Number zoned(6:0) const;
  END-PI;

  dcl-s isCustomer_ind ind inz(*off);

  exec sql
    Select '1' into :isCustomer_ind from FMCUST
      WHERE CMSTAT = 'A' and CMCUST = :Customer_Number
      Fetch first row only;

  return isCustomer_ind;

end-proc;


//   ...........................................................
//   :      isEVEN(Number to test)
//   :.........................................................:

dcl-proc isEVEN;
  dcl-pi *n ind;
    TEST_Number zoned(11:0) const;
  END-PI;

  If %int(TEST_Number/2) = (TEST_Number/2);
    return *On;
   Else;
    return *Off;
  ENDIF;


end-proc;


