    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Fund & Expense Petty Cash                          :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  March 2008           ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? :  Scrn01   -?Display Screen 01                             ?:
      *? :  Load01   -?Load Screen 01                                ?:
      *? :  Edit01   -?EDIT Screen 01                                ?:
      *? :  *INZSR   -?Initialization Subroutine                     ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  01 - 24 ?Return Screen Functions                         ?:
      *? :  03      ?Exit                                            ?:
      *? :  06      ?Restart                                         ?:
      *? :          ?                                                ?:
      *? :  25      ?SFLDSP, SFLDSPCTL, SFLCLR(N)                    ?:
      *? :  26      ?SFLDSP (Subfile has Data)                       ?:
      *? :  27      ?SFLEND                                          ?:
      *? :  28      ?SFLNXTCHG                                       ?:
      *? :  40      ?RollDn Indicator                                ?:
      *? :  50      ?Error Indicator (All Errors)                    ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
     FARR352FM  CF   E             WORKSTN
     FFGLWRK    UF A E           K DISK
     FFMTRAN    UF A E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Month
    ?D/COPY QFunctDefn,$isDate#
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D*Copy QFunctDefn,$ERRMSG
      *? Fields
 |P  D $ERR_PROG       S             10A   Inz(*Blanks)                         ?Pgm Msg Queue
 |P  D $ERR_MSGF       S             10A   Inz(*Blanks)                         ?Message File
 |P  D $ERR_LIBR       S             10A   Inz(*Blanks)                         ?Library
 |P  D $ERR_MsgID      S              7A   Inz(*Blanks)                         ?Message Id
 |P  D $ERR_MsgData    S            100A   Inz(*Blanks)                         ?Message Data
 |P  D $ERR_MKEY       S              4A   Inz(*Blanks)                         ?Message Key
 |P  D $ERR_SORC       S              1A   Inz(*Blanks)                         ?Send or Clear

      *? Program Status Data Structure
     D                SDS                                                       ?Sys Data Structure
     D   ##PGM           *PROC                                                  ?Program Name

      *? Field Definitions
     D   User          S             10A                                        ?Current User ID
     D   Today         S              6S 0                                      ?Todays Date MDY


     C     *INLR         DOUEQ     *ON                                          ?

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    1                                            ?
    ?C                   ExSr      Edit01                                       ?
    ?C*    Screen        WhenEq    2                                            ?
    ?C*                  ExSr      Edit02                                       ?
    ?C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   If        Screen <> 01
     C                   Z-Add     Screen        PrevScreen        3 0          ?Prev. Screen
     C                   EndIf

     C                   Z-Add     01            Screen            3 0          ?Screen  Number
     C                   Eval      *In50 = *On
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     ARR35201                                     ?
    ?C                   ExSr      $ClrError                                     ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

     C                   Eval      PCDATE = $MDYDate($Date(0))
     C                   Eval      PCAMOUNT = *Zero

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      GetTrans - Get the Transactions                    :
      *?  :.........................................................:
    ?C     GetTrans      BegSr                                                  ?

    ?C     MTRANKey      KList                                                  ?
    ?C                   KFld                    MTCUST
    ?C                   KFld                    PCDate
    ?C                   KFld                    MTSUFF
    ?C                   KFld                    MTSEQ#
      *? See if a record has already been written.
    ?C     MTRANKey      Chain     FMTRAN
     C                   If        %Found(FMTRAN)
     C                   Eval      PCAmount = -1 * MT$AMT
     C                   Eval      $ERR_MsgID = 'ARR3520'                        Change P/C Entry
     C                   Else
     C                   Eval      $ERR_MsgID = 'ARR3521'                        New P/C Entry
     C                   Eval      PCAMount = *Zero
     C                   EndIf
     C                   Eval      $ERR_MsgData = *Blanks
    ?C                   ExSr      $SndError

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      WriteTrans - Write Transactions                    :
      *?  :.........................................................:
    ?C     WriteTrans    BegSr                                                  ?

      *? Write the FMTRAN record.
     C                   Eval      MTINV#     =  PCDate                         ?INV #')
     C                   Eval      MTTDAT     =  $Date7($DateMDY(PCDate))       ?TRANS DATE CYMD')
     C                   Eval      MTDUDT     =  $Date7($DateMDY(PCDate))       ?INV DUE DATE CYMD
     C                   Eval      MT$AMT     = -PCAmount                       ?A/R AMOUNT')
     C                   If        %Found(FMTRAN)
    ?C                   Update    RMTRAN
     C                   Else
    ?C                   Write     RMTRAN
     C                   EndIf
      *? Write the FGLWRK records.
    ?C     GLWRKKey      KList                                                  ?
    ?C                   KFld                    GWCOMP
    ?C                   KFld                    GWJEPR
    ?C                   KFld                    PCDate
    ?C                   KFld                    GWJESF
    ?C                   KFld                    GWSEQ#
     C                   Eval      GWSEQ#     =  1                              ?ITEM SEQUENCE')
    ?C     GLWRKKey      Chain     RGLWRK
     C                   Eval      GWJENM     =  PCDate                         ?JE #')
     C                   Eval      GWACDT     =  PCDate                         ?ACCTG PERIOD DATE')
     C                   Eval      GWJEDT     =  PCDate                         ?TRANS DATE')
     C* WJB 3/11/15      Eval      GWGLAC     =  47610000                       ?ACCOUNT NUMBER')
WJB  C                   Eval      GWGLAC     =  10600000                       ?ACCOUNT NUMBER')
     C                   Eval      GW$AMT     =  PCAmount                       ?J/E $')
     C                   Eval      GWPERD     =  $Month($DateMDY(PCDate))       ?ACCTG PER SORT')
     C                   If        %Found(FGLWRK)
    ?C                   Update    RGLWRK
     C                   Else
    ?C                   Write     RGLWRK
     C                   EndIf
     C                   Eval      GWSEQ#     =  2                              ?ITEM SEQUENCE')
    ?C     GLWRKKey      Chain     RGLWRK
     C                   Eval      GWJENM     =  PCDate                         ?JE #')
     C                   Eval      GWACDT     =  PCDate                         ?ACCTG PERIOD DATE')
     C                   Eval      GWJEDT     =  PCDate                         ?TRANS DATE')
     C                   Eval      GWGLAC     =  10500000                       ?ACCOUNT NUMBER')
     C                   Eval      GW$AMT     = -PCAmount                       ?J/E $')
     C                   Eval      GWPERD     =  $Month($DateMDY(PCDate))       ?ACCTG PER SORT')
     C                   If        %Found(FGLWRK)
    ?C                   Update    RGLWRK
     C                   Else
    ?C                   Write     RGLWRK
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

      *? Process pre-edit Functions F3, F6, F7 & F9
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In03
     C                   MOVE      *ON           *INLR                          ?
      *? Restart Requested
    ?C                   When      *In60 and *In02
     C                   Eval      *In60 = *Off
    ?C                   ExSr      Scrn01
      *? Validate Date Entered
    ?C                   When      not *In60 and PCDATE = *Zero
     C                   Eval      *In60 = *Off
     C                   Eval      $ERR_MsgID = 'DATE902'                        Date not entered
     C                   Eval      $ERR_MsgData = *Blanks
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn01

    ?C                   When      not *In60 and not $isDate#(PCDATE:'*MDY')
     C                   Eval      *In60 = *Off
     C                   Eval      $ERR_MsgID = 'DATE901'                        Invalid Date
     C                   Eval      $ERR_MsgData = %char(PCDate)
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn01

    ?C                   When      not *In60 and $isDate#(PCDATE:'*MDY')
     C                   Eval      *In60 = *On
    ?C                   ExSr      GetTrans
    ?C                   ExSr      Scrn01
      *? Validate Amount
    ?C                   When      *In60 and PCAMOUNT = *Zero
     C                   Eval      $ERR_MsgID = 'AMT0001'                        Amount = *Zero
     C                   Eval      $ERR_MsgData = 'Petty Cash'
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn01

    ?C                   When      *In60 and PCAMOUNT <> *Zero
    ?C                   ExSr      WriteTrans
     C                   Eval      *InLR = *On

    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

    ?C*Copy QFunctDefn,$ERRMSGSR
      *?  ...........................................................
      *?  :      $ClrError - Clear Error Message Subfile            :
      *?  :.........................................................:
    ?C     $ClrError     BegSr                                                  ?

     C                   MOVE      'C'           $ERR_SorC         1            ?
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      *In50 = *Off                                 ?Error Alarm Indicat

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      $SndError - Send an Error Message to the PGMMSGQ   :
      *?  :.........................................................:
    ?C     $SndError     BegSr                                                  ?

     C                   MOVE      'S'           $ERR_SorC         1            ?
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      *In50 = *On                                  ?Error Alarm Indicat

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      * ? :      SRMSGF - Clear or send messages to Pgm msg queue   :
      *?  :.........................................................:
    ?C     SRMSGF        BegSr                                                  ?

      *? Call Msg processing CL                           ?

     C                   CALL      'XAMSFC'
     C                   Parm                    $ERR_PROG                      ?Pgm Msg Queue
     C                   Parm                    $ERR_MSGF                      ?Message File
     C                   Parm                    $ERR_LIBR                      ?Library
     C                   Parm                    $ERR_MsgID                     ?Message Id
     C                   Parm                    $ERR_MsgData                   ?Message Data
     C                   Parm                    $ERR_MKEY                      ?Message Key
     C                   Parm                    $ERR_SORC                      ?Send or Clear

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   Eval      $ERR_PROG = ##PGM                            ?PGM MSG QUEUE
     C                   Eval      $ERR_MSGF = 'KPMSGF'                         ?MSG FILE
     C                   Eval      $ERR_LIBR = '*LIBL'                          ?LIBRARY
     C                   Eval      $ERR_MsgID = '*******'                       ?MESSAGE ID
    ?C                   ExSr      $ClrError                                     ?
    ?C                   ExSr      Load01                                       ?
    ?C                   ExSr      Scrn01                                       ?

      *?  Default Values for FMTRAN
     C                   Eval      MTSTAT     = 'A'                             ?STATUS')
     C                   Eval      MTCUST     =  999999                         ?AR CUST. NUMBER')
     C*                  Eval      MTINV#     =  PCDate                         ?INV #')
     C                   Eval      MTSUFF     = 'PC'                            ?SUFFIX')
     C                   Eval      MTSEQ#     =  *Zero                          ?SEQ #')
     C                   Eval      MTCOMP     =  1                              ?COMPANY NUMBER')
     C                   Eval      MTTTYP     =  4                              ?TRANS TYPE')
     C*                  Eval      MTTDAT     =  $Date7($Date(PCDate))          ?TRANS DATE CYMD')
     C*                  Eval      MTDUDT     =  $Date7($Date(PCDate))          ?INV DUE DATE CYMD
     C*                  Eval      MT$AMT     = -PCAmount                       ?A/R AMOUNT')
     C                   Eval      MTGLAC     =  10500000                       ?G/L  ACCT')
     C                   Eval      MTGLAR     = 'Y'                             ?A/R UPDATED')
     C                   Eval      MTGLUD     = 'Y'                             ?G/L UPDATED')
     C                   Eval      MTPONO     = 'Petty Cash'                    ?CUST P.O. #')
     C                   Eval      MTPOSC     = 'PETTYCSH'                      ?POS CHECK #')
     C                   Eval      MTCSAJ     = 'Y'                             ?CASH ADJ FLAG')
     C                   Eval      MTCHEK     = 'PETTYCSH'                      ?A/R CHECK #')
     C                   Eval      MTDESC     = 'Petty Cash'                    ?DESCRIPTION')
     C                   Eval      MTDTLA     =  $MDYDate($Date(0))             ?LAST ACT. DATE')
     C                   Eval      MTTIME     =  $Now()                         ?TIME')
     C                   Eval      MTUSER     =  $User()                        ?USER')
     C                   Eval      MTREAS     = 'CSH'                           ?REASON CODE')
     C                   Eval      MTTAXJ     = 'NJ'                            ?TAX JURISDICTION

      *?  Default Values for FGLWRK
     C                   Eval      GWSTAT     = 'A'                             ?STATUS')
     C                   Eval      GWCOMP     = 1                               ?COMPANY NUMBER')
     C                   Eval      GWJEPR     = 'PC'                            ?PREFIX')
     C                   Eval      GWJENM     =  *Zero                          ?JE #')
     C                   Eval      GWJESF     =  'ZZ'                           ?SUFFIX')
     C*                  Eval      GWSEQ#     =  1 or 2                         ?ITEM SEQUENCE')
     C                   Eval      GWJEDS     = 'Petty Cash'                    ?DESCRIPTION')
     C*                  Eval      GWACDT     =  PCDate                         ?ACCTG PERIOD DATE')
     C*                  Eval      GWJEDT     =  PCDate                         ?TRANS DATE')
     C*                  Eval      GWGLAC     =  4761 or 1050                   ?ACCOUNT NUMBER')
     C*                  Eval      GW$AMT     =  PCAmount or -PCAmount          ?J/E $')
     C                   Eval      GWDDES     = 'Petty cash transfer & expense' ?DETAIL
     C                   Eval      GWJETP     =  *Blanks                        ?TYPE')
     C                   Eval      GWPOST     =  *Blanks                        ?J/E UPDATE FLAG')
     C*                  Eval      GWPERD     =  $Month( PCDate )               ?ACCTG PER SORT')
     C                   Eval      GWSRCE     = 'J/E'                           ?SOURCE')
     C                   Eval      GWDTLA     =  $MDYDate($Date(0))             ?DATE LAST ACTIVITY
     C                   Eval      GWTIME     =  $Now()                         ?TIME')
     C                   Eval      GWUSER     =  $User()                        ?USER')
     C                   Eval      GWSHFR     =  *Blanks                        ?SHIP FROM

    ?C                   EndSr                                                  ?
