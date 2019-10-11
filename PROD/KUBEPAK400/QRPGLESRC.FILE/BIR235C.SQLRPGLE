**free
Ctl-Opt  debug option(*NODEBUGIO : *SRCSTMT )
         dftactgrp(*no) actgrp(*caller)
         DatFmt(*USA)
         BndDir('*LIBL/KPFUNCTION')
         ALWNULL(*InputOnly)
         thread(*serialize);

/include QFunctDefn,@CopyRight

dcl-pr BIR235C extpgm;
END-PR;

/include QFunctDefn,$DFTPRT
/include QFunctDefn,$CHGPRT
/include QFunctDefn,$PRINTPICK
/include QFunctDefn,$Date
/include QFunctDefn,$MDYDate

Dcl-Pr $OrderInq Extpgm('BIR255CLO');
 Order# Packed(6:0) Const;
End-Pr;


dcl-f BIR235CCM Workstn Sfile(BIR235C02:RRN02);
dcl-f FHORDR usage(*input);

// Screen indeicator DS
//Dcl-Ds Dspf;
//  // Display File
//  VLDCMDKEY    Char(1) Pos(48);
//  // Screen 01
//  Exit01       Char(1) Pos(03);
//  Refresh01    Char(1) Pos(05);
//  WeekMinus01  Char(1) Pos(07);
//  WeekPlus01   Char(1) Pos(08);
//  // Screen 02
//  SFLNXTCHG02  Char(1) Pos(28);
//  Refresh02    Char(1) Pos(05);
//  Restart02    Char(1) Pos(06);
//  Printer02    Char(1) Pos(10);
//  DROPFOLD     Char(1) Pos(11);
//  SFLDSPCTL02  Char(1) Pos(25);
//  SFLDSP02     Char(1) Pos(26);
//  SFLEND02     Char(1) Pos(27);
//  HIGHLIGHTROW Char(1) Pos(29);
//End-Ds;

// Program Status Data Structure : PSDS
Dcl-Ds Pgmstatus PSDS;
  Job     Char(10) Pos(244);
  User    Char(10) Pos(254);
  Rundate Zoned(6) Pos(276);
  Runtime Zoned(6) Pos(282);
  Pgm     Char(10) Pos(334);
End-Ds;

Dcl-Ds FHORDR_DS extname('FHORDR');
End-Ds;

Dcl-Ds This_Address;
  thisOHSHP2 Like(OHSHP2) ;
  thisOHSHP3 Like(OHSHP3);
  thisOHSHCT Like(OHSHCT);
  thisOHSHST Like(OHSHST);
  thisOHSHZP Like(OHSHZP);
END-DS;

Dcl-Ds Last_Address;
  LastOHSHP2 Like(OHSHP2) ;
  LastOHSHP3 Like(OHSHP3);
  LastOHSHCT Like(OHSHCT);
  LastOHSHST Like(OHSHST);
  LastOHSHZP Like(OHSHZP);
END-DS;


dcl-s ThisWeek date;
dcl-s RRN02 zoned(4:0);
dcl-s ErrorCount01 zoned(3:0);
dcl-s ErrorCount02 zoned(3:0);
dcl-s EndOfFile ind;
dcl-s Screen zoned(2:0);
dcl-s RecordCount zoned(4:0);

DOU *INLR = *ON;
  SELECT;
    WHEN Screen = 1;
      Edit01();
    WHEN Screen = 2;
      Edit02();
    OTHER;
      Load01();
      Scrn01();
  ENDSL;
ENDDO;

*InLR = *On;
Return;

//  ============================================================================
//  =                                                                          =
//  =   S C R E E N  -1-                                                       =
//  =                                                                          =
//  ============================================================================

//  ...........................................................
//  :      Scrn01 - Display Screen 01                         :
//  :.........................................................:
dcl-proc Scrn01;

  Screen = 01;
  If ErrorCount01 <> *Zero;
    Write MSGCTL;
  EndIf;
  ExFmt BIR235C01;
  //ClrError();
  ErrorCount01 = *Zero;

End-proc;

//  ...........................................................
//  :      Load01 - Load Screen 01                            :
//  :.........................................................:
dcl-proc Load01;


  SCANCUSORD = *zero;
  Exec SQL Set :ThisWeek = MOST_RECENT_MONDAY;
  SHIPWEEK = $MDYDate(ThisWeek);

  If Printer = *Blanks;
    Printer = $DFTPRT(User:Pgm:'*PGM');
  ENDIF;

end-proc;


//  ...........................................................
//  :      Edit01 - EDIT Screen 01                            :
//  :.........................................................:
dcl-proc Edit01;

  //  Process pre-edit Functions F3, F6, F7 & F9
  SELECT;
  //  Cancel Requested
  When *In03;
    *InLR = *On;
  //  Refresh/Reselect Requested
  When *In05;
    Load01();
    Scrn01();
  When *In07; // Minus one week
    Exec SQL Set :ThisWeek = :ThisWeek - 7 days;
    SHIPWEEK = $MDYDate(ThisWeek);
    Scrn01();
  When *In08; // Plus One Week
    Exec SQL Set :ThisWeek = :ThisWeek + 7 days;
    SHIPWEEK = $MDYDate(ThisWeek);
    Scrn01();
  When *In10;
    Printer = $CHGPRT(User:Pgm:'*PGM');
    Scrn01();
  //  If no Functions, Edit screen values
  OTHER;
    *In30 = isOrder(SCANCUSORD);
    *In31 = isCustomer(SCANCUSORD);
    If *In30 or *In31;
      Load02();
      scrn02();
     Else;
      Scrn01();
     ENDIF;
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
  *In25 = *On;
  Write ASSUME;
  Write BIR235C02F;
  If ErrorCount02 <> *Zero;
    Write MSGCTL;
  EndIf;
  STARTRRN02 = SFLCSRRRN;
  If STARTRRN02 = 0;
    STARTRRN02 = 1;
  ENDIF;
  ExFmt BIR235C02C;
  //ClrError();
  ErrorCount01 = *Zero;
  *In25 = *Off;
End-proc;

//  ...........................................................
//  :      Load02 - Load Screen 02                            :
//  :.........................................................:
dcl-proc Load02;

  If *In30; // Entered Order Number
    Exec SQL Select OHCUST into :CMCUST from FHORDR where OHORD# = :SCANCUSORD;
   Else;
    CMCUST = SCANCUSORD;
  ENDIF;

  Exec SQL Select CMNAME into :CMNAME from FMCUST where CMCUST = :CMCUST;

  //  Clear the Subfile
  OPTION02 = *Blanks;
  *In25 = *Off;
  *In26 = *Off;
  *In27 = *Off;
  Write BIR235C02C;

  RRN02       = *zero;
  RecordCount  = *zero;

  OpenData02();
  ReadData02();
  DoW not EndOfFile and RRN02 < 9999;
    //  Load screen fields
    Exec SQL Select ord.* into :FHORDR_DS
              from FHORDR as ord where OHORD# = :OHORD#;
    Address = %trim(OHSHP2) + ' ' + %trim(OHSHP3) + ' ' + %trim(OHSHCT) +
              ', ' + %trim(OHSHST) + ' ' + %trim(OHSHZP);
    Exec SQL select substr(SVDESC,1,25) into :ShipVia25
             from FMSVIA where SVCODE = :OHSHPC;
    OIRVDT6 = $MDYDate($date(OIRVDT));
    OHTERM25  = OHTERM;
    Exec SQL Select sum(OIQORD-OIQSHP) into :PIECES
             From FIORDR where OIORD# = :OHORD#
                           and OIRVDT = :OIRVDT;
    //  Write Subfile Record
    RRN02 += 1;
    *In29 = isEven(RRN02);
    Write BIR235C02;
    *In26 = *On;
    Last_Address = This_Address;

    ReadData02();
    //  Write Blank Line for new Address
    If This_Address <> Last_Address
      and RRN02 > 0
      and not EndOfFile;
      Address = '   -----';
      *In60 = *On;  // Non-Display (puts blank line in SFL)
      RRN02 += 1;
      Write BIR235C02;
      *In60 = *Off;
    ENDIF;
  EndDo;

  IF *In26 = *On;
    Chain RRN02 BIR235C02;
    *In27 = *On;
    Update BIR235C02;
  EndIF;

  CloseData02();

  STARTRRN02 = 1;
  SFLCSRRRN = 0;

end-proc;


//  ...........................................................
//  :      Edit02 - EDIT Screen 02                            :
//  :.........................................................:
dcl-proc Edit02;

  //  Process pre-edit Functions F3, F6, F7 & F9
  SELECT;
  //  Cancel Requested
  When *In03;
    *InLR = *On;
  //  Toggle Destination
  //  Refresh/Reselect Requested
  When *In05;
    Load02();
    Scrn02();
  When *In06;
    Load01();
    Scrn01();
  When *In07; // Minus one week
    Exec SQL Set :ThisWeek = :ThisWeek - 7 days;
    SHIPWEEK = $MDYDate(ThisWeek);
    Load02();
    Scrn02();
  When *In08; // Plus One Week
    Exec SQL Set :ThisWeek = :ThisWeek + 7 days;
    SHIPWEEK = $MDYDate(ThisWeek);
    Load02();
    Scrn02();
  When *In10;
    Printer = $CHGPRT(User:Pgm:'*PGM');
    Scrn02();
  //  If no Functions, Check for Options.
  OTHER;
      Opts02();
    //  If Update Requested then Update file else redisplay
      //UpdateFiles02();
      Load02();
      Scrn02();
  ENDSL;

end-proc;

//   ...........................................................
//   :      Opts02 - Process Screen 02 Options                 :
//   :.........................................................:
dcl-proc Opts02;
  dcl-s reqDate date;
  ReadC BIR235C02;
  DoW not %EOF(BIR235CFM);
    *In50 = *Off;
    *In28 = *Off;

    Select;
    When OPTION02 = 'V' or OPTION02 = '5';
      $OrderInq(OHORD#);
    When OPTION02 = 'P' or OPTION02 = '6';
      reqDate = $date(oirvdt);
      $PrintPick(OHORD#:Printer:'001':'N':reqDate);
    EndSl;
    *In28 = *On;
    Update BIR235C02;
    ReadC BIR235C02;
  EndDo;

end-proc;

//   ...........................................................
//   :      OpenData02 - Run SQL to select Data for Screen 02  :
//   :.........................................................:

dcl-proc OpenData02;

  //  Get FDLOTRD Data matching request
  exec sql

    DECLARE   C2 cursor for

    Select distinct ohord#, ohcust, oirvdt,OHSHP2,OHSHP3,OHSHCT,OHSHST,OHSHZP

    from    fhordr  as ord
    join    fiordr  as dtl on oiord# = ohord#
                          and ohdtry >= OIRVDT
                          and OIITYP = ' '
                          and OISTAT <> 'D'
    join    XATABE1 as tab on OHSHPC = TBC6 and TBTB = 'FX'

    Where  OHSTAT <> 'D'
      and  OHDTRY in
     (select CYMD7 from S105R9YM.TGMSDATA.Mondays_all
       where monday_date <= :ThisWeek )
      and ord.OHCUST = :CMCUST

    order by OHSHST,OHSHCT,OHSHP2,OHSHP3,ohord#,oirvdt

    For Read only;


    //  Open the SQL recordset
    exec sql Close C2;
    exec sql Open C2;

   end-proc;

   //   ...........................................................
   //   :      CloseData02 - Close the Screen 02 Data Set         :
   //   :.........................................................:

dcl-proc CloseData02;
//  Close the SQL recordset
    exec sql Close C2;
end-proc;

//   ...........................................................
//   :      ReadData02 - Read Data for Screen 02               :
//   :.........................................................:

dcl-proc ReadData02;
  //  Read Sow Schedule Records for Selected Week
  exec sql
  Fetch C2 into :ohord#,:ohcust,:oirvdt,:OHSHP2,:OHSHP3,:OHSHCT,:OHSHST,:OHSHZP;

  If SQLSTT = '02000';
    EndOfFile = *On;
  Else;
    EndOfFile = *Off;
    RecordCount = RecordCount + 1;
  EndIf;

  thisOHSHP2 = OHSHP2;
  thisOHSHP3 = OHSHP3;
  thisOHSHCT = OHSHCT;
  thisOHSHST = OHSHST;
  thisOHSHZP = OHSHZP;

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


