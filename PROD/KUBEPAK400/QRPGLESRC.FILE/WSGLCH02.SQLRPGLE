**free

// GL Cash Deposit History

Ctl-Opt
  debug option(*NODEBUGIO : *SRCSTMT )
  dftactgrp(*no) actgrp(*caller)
  DatFmt(*USA)
  BndDir('*LIBL/KPFUNCTION')
  AlwNull(*UsrCtl)
  thread(*serialize);

/include QFunctDefn,@CopyRight

dcl-pi WSGLCH02;
END-PI;


dcl-pr WSGLCH02B extpgm;
END-PR;

/include QFunctDefn,$_Dates

dcl-f WSGLCH02FM Workstn Sfile(GLCH0201:RRN01);

dcl-s ThisWeek date;
dcl-s RRN01 zoned(4:0);
dcl-s ErrorCount01 zoned(3:0);
dcl-s EndOfFile ind;
dcl-s Screen zoned(2:0);
dcl-s RecordCount zoned(4:0);

dcl-s LastDate like(SelDate);
dcl-s LastYear like(SelYear);

//-------Main-------------------------------------------------------------------
DOU *INLR = *ON;
  SELECT;
    WHEN Screen = 1;
      Edit01();
    OTHER;  // First time
      WSGLCH02B();  //Re-Build current year data
      Exec SQL Set :SELYEAR = year(current date); //Get current year to start with
      Load01();
      Scrn01();
  ENDSL;
ENDDO;

*InLR = *On;
Return;

//-------Scrn01 - Display Screen 01---------------------------------------------
dcl-proc Scrn01;
  Screen = 01;
  *In25 = *On;
  Write ASSUME;
  Write GLCH0201F;
  If ErrorCount01 <> *Zero;
    Write MSGCTL;
  EndIf;
  If SFLCSRRRN <> 0;
    STARTRRN01 = SFLCSRRRN;
  ENDIF;
  If STARTRRN01 = 0;
    STARTRRN01 = 1;
  ENDIF;
  ExFmt GLCH0201C;
  //ClrError();
  ErrorCount01 = *Zero;
  *In25 = *Off;
End-proc;

//-------Load01 - Load Screen 01------------------------------------------------
dcl-proc Load01;

  dcl-s DateSelected date;

  STARTRRN01 = 0;
  LYWKTOT$   = 0;
  TYWKTOT$   = 0;
  TYUPDN$    = 0;
  LYGTOT$    = 0;
  TYGTOT$    = 0;
  UPDNGTOT$  = 0;
  UPDN$RUN   = 0;

  DateSelected = $DateMDY(SelDate);

  If SelYear = 0;
    If SelDate <> 0;
      Exec SQL Set :SelYear = year(:DateSelected);
     Else;
      Exec SQL Set :SelYear = year(current date); //Get current year to start with if non selected
    ENDIF;

  ENDIF;

  //  Clear the Subfile
  *In25 = *Off;
  *In26 = *Off;
  *In27 = *Off;
  *In29 = *Off;  // Display Weekly SubTotals
  *In30 = *Off;  // Reverse Image Selected Date
  Write GLCH0201C;

  RRN01       = *zero;
  RecordCount  = *zero;

  OpenData01();
  ReadData01();
  DoW not EndOfFile and RRN01 < 9999;
    //  Load screen fields
    LYWKTOT$   += LYAMT$;
    TYWKTOT$   += TYAMT$;
    TYUPDN$    += ( TYAMT$ - LYAMT$ );
    UPDN$RUN   += ( TYAMT$ - LYAMT$ );
    LYGTOT$    += LYAMT$;
    TYGTOT$    += TYAMT$;
    UPDNGTOT$  += ( TYAMT$ - LYAMT$ );
    //  Write Subfile Record
    RRN01 += 1;
    *In26 = *On;
    If    SelDate <> 0
     and TYDATE >= DateSelected
     and StartRRN01 = 0;
      *In30 = *On;  // Reverse Image Selected Date
      StartRRN01 = RRN01;
    ENDIF;
    If WEEKDAY = 'SUNDAY';
      *In29 = *On;
      Write GLCH0201;
      *In29 = *Off;
      LYWKTOT$   = 0;
      TYWKTOT$   = 0;
      TYUPDN$    = 0;
     Else;
      Write GLCH0201;
    EndIf;
    *In30 = *Off;
    ReadData01();
  EndDo;

  IF *In26 = *On;
    Chain RRN01 GLCH0201;
    *In27 = *On;
    Update GLCH0201;
  EndIF;

  CloseData01();

  If StartRRN01 = 0;
    If RecordCount > 18;
      STARTRRN01 = RecordCount;
     Else;
      STARTRRN01 = 1;
    ENDIF;
  ENDIF;
  SFLCSRRRN = 0;

  LastDate = SelDate;
  LastYear = SelYear;

end-proc;


//-------Edit01 - EDIT Screen 01------------------------------------------------
dcl-proc Edit01;

  //  Process pre-edit Functions F3, F6, F7 & F9
  SELECT;
  //  Cancel Requested
  When *In03;
    *InLR = *On;
  When *In05;
    Load01();
    Scrn01();
  When (SelDate <> LastDate)
    or (SelYear <> LastYear);
    Load01();
    Scrn01();
  //  If no Functions, Check for Options.
  OTHER;
    //Opts01();
    Scrn01();
  ENDSL;

end-proc;

//-------Opts01-----------------------------------------------------------------
dcl-proc Opts01;

  ReadC GLCH0201;
  DoW not %EOF(WSGLCH02FM);
    *In50 = *Off;

    *In28 = *On;
    Update GLCH0201;
    ReadC GLCH0201;
  EndDo;

end-proc;

//-------OpenData01 - Run SQL to select Data for Screen 01----------------------
dcl-proc OpenData01;

  //  Get FDLOTRD Data matching request
  exec sql

    DECLARE   C1 cursor for

      Select
          ly.datefld                  as Last_Year_Date,
          ty.datefld                  as This_Year_Date,
          ty.week_number              as Week_number,
          ty.dotw                     as Day_of_the_week,
          ty.dotw_name                as Day_name,
          coalesce(sum(lyd.TRANSACTION_AMOUNT),0) as Last_Year_Amount,
          coalesce(sum(tyd.TRANSACTION_AMOUNT),0) as This_Year_Amount
      from S105R9YM.TGMSDATA.fcalen_all ty
      join S105R9YM.TGMSDATA.fcalen_all ly
            on ty.year4 -1        = ly.year4
           and ty.week_number     = ly.week_number
           and ty.dotw            = ly.dotw
      left outer join S105R9YM.TGMSDATA.GL_Cash_Deposit_History_File tyd
            on ty.datefld = tyd.TRANSACTION_DATE
      left outer join S105R9YM.TGMSDATA.GL_Cash_Deposit_History_File lyd
            on ly.datefld = lyd.TRANSACTION_DATE
      where ty.cal_year_4 = :SelYear
        and ty.datefld <= current date
      group by
          ty.datefld,
          ly.datefld,
          ty.week_number,
          ty.dotw,
          ty.dotw_name
      order by
          ty.datefld

      For Read only;

    //  Open the SQL recordset
    exec sql Close C1;
    exec sql Open C1;

   end-proc;

//-------CloseData01 - Close the Screen 01 Data Set-----------------------------
dcl-proc CloseData01;
  exec sql Close C1; //  Close the SQL recordset
end-proc;

//-------ReadData01 - Read Data for Screen 01-----------------------------------
dcl-proc ReadData01;
  exec sql  //  Read Sow Schedule Records for Selected Week
  Fetch C1 into :LYDATE,:TYDATE,:WEEK#,:DOTW,:WEEKDAY,:LYAMT$,:TYAMT$;

  If SQLSTT = '02000';
    EndOfFile = *On;
  Else;
    EndOfFile = *Off;
    RecordCount = RecordCount + 1;
  EndIf;

end-proc;

