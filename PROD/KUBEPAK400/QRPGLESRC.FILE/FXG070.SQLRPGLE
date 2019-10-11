    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DftActGrp(*no)
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Display Unfixed Plugs                              :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  March 2011           ? Kube-Pak Corporation ?    :
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
      *? :  SCRN02   -?Display Screen 01                             ?:
      *? :  LOAD02   -?Load Screen 01                                ?:
      *? :  EDIT02   -?EDIT Screen 01                                ?:
      *? :  $ClrError -?Clear Error Message Subfile                  ?:
      *? :  SndError -?Send an Error Message to the PGMMSGQ          ?:
      *? :  SRMSGF   -?Clear or send messages to Pgm msg queue       ?:
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
     FFXG070FM  CF   E             WORKSTN
     F                                     SFILE(FXG07002:RRN02)
     F                                     SFILE(FXG07003:RRN03)
     F                                     DEVID(WSID)

     FFDLOTDSA  IF   E           K DISK                                         ?Lot File
     FFMINVT    IF   E           K DISK                                         ?Item Master
     FFTRAYD    IF   E           K DISK                                         ?Tray File
     FFTRAYFIXEDIF   E           K DISK                                         ?Fixed Flats

      *? Function Prototypes
    ?D/COPY QFunctDefn,$ERRMSG
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$IsDate#
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$WeekDay
    ?D/COPY QFunctDefn,$DftPrt
    ?D/COPY QFunctDefn,$MONDAY

      *? Field Definitions
     D   Now           S              6S 0                                      ?The Time at *Init
     D   User          S             10A                                        ?Current User ID
     D   Today         S              6S 0                                      ?Todays Date MDY
     D   RRN02         S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D   RRN03         S              4  0 Inz(0)                               ?SFLRRN Screen 03

     D   RdyDate       S                   Like(TRSCYM)                         ?Ready Date 7
     D   FixDate       S               D                                        ?Ready Date 7

     D   SAVRdyDate    S                   Like(SelRdyDate)                     ?Rdy Date
     D   SAVSHOWALL    S                   Like(SHOWALL)                        ?Show ALL
     D   SAVITEM       S                   Like(SELITEM)                        ?ITEM
     D   SAVSIZE       S                   Like(SELSIZE)                        ?SIZE
     D   SAVDES1       S                   Like(SELDES1)                        ?DES1
     D   SAVFIND       S                   Like(SELFIND)                        ?FIND
     D   SAVFIXD       S                   Like(SELFIXD)                        ?FIXD

    ?C                   ExSr      $ClrError                                     ?
    ?C                   ExSr      SCRN01                                       ?

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    1                                            ?
    ?C                   ExSr      EDIT01                                       ?
    ?C     Screen        WhenEq    2                                            ?
    ?C                   ExSr      EDIT02                                       ?
    ?C     Screen        WhenEq    3                                            ?
    ?C                   ExSr      EDIT03                                       ?
    ?C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      SCRN01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     SCRN01        BegSr                                                  ?
     C                   If        Screen <> 01
     C                   Z-Add     Screen        PrevScreen        3 0          ?Prev. Screen
     C                   EndIf
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C                   Write     ASSUME
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FXG07001                                     ?
    ?C                   ExSr      $ClrError                                     ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      SCRN02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     SCRN02        BegSr                                                  ?
     C                   If        Screen <> 02
     C                   Z-Add     Screen        PrevScreen        3 0          ?Prev. Screen
     C                   EndIf
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     FXG07002F                                   ?
    ?C                   Write     MSGCTL                                       ?
     C                   If        StartRRN02 = *Zero
     C                   Eval      StartRRN02 = 1
     C                   EndIf
    ?C                   ExFmt     FXG07002C                                    ?
    ?C                   ExSr      $ClrError                                     ?
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      SCRN03 - Display Screen 03                         :
      *?  :.........................................................:
    ?C     SCRN03        BegSr                                                  ?
     C                   If        Screen <> 03
     C                   Z-Add     Screen        PrevScreen        3 0          ?Prev. Screen
     C                   EndIf
     C                   Z-Add     03            Screen            3 0          ?Screen  Number
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     FXG07003F                                   ?
    ?C                   Write     MSGCTL                                       ?
     C                   If        StartRRN03 = *Zero
     C                   Eval      StartRRN03 = 1
     C                   EndIf
    ?C                   ExFmt     FXG07003C                                    ?
    ?C                   ExSr      $ClrError                                     ?
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      LOAD01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     LOAD01        BegSr                                                  ?

     C                   Eval      SelRdyDate= $MDYDate(
     C                                   $Monday($AddDate($Date(0):+7):'SAT'))

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      LOAD02 - Load Screen 02                            :
      *?  :.........................................................:
    ?C     LOAD02        BegSr                                                  ?

      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
     C                   Eval      *In81 = *Off
     C                   Eval      StartRRN02 = *Zero
    ?C                   Write     FXG07002C                                    ?

      *? Load the Subfile
     C                   Eval      RdyDate  =
     C                             $Date7($DateMDY(SELRdyDate))

     C                   Z-add     *Zero         RRN02                          ?

    ?C     RdyDate       SetLL     FDLOTDSA
    ?C     RdyDate       ReadE     FDLOTDSA
     C                   DoW       not %EOF(FDLOTDSA)
      *? Check If Included
    ?C     ItemKey       KList
    ?C                   KFld                    LDITEM
    ?C                   KFld                    LDSIZE
    ?C     ItemKey       Chain     FMINVT
     C                   If        %Found(FMINVT) and
     C                             (SELSIZE = *Blanks or SELSIZE = IMSIZE) and
     C                             (SELITEM = *Blanks or SELITEM = IMITEM) and
     C                             (SELFIXD = *Blanks or SELFIXD = LDFIXD) and
     C                             (SHOWALL = 'Y'     or LDFIXD <> 'Y'   ) and
     C                             (SHOWALL = 'Y'     or LDFIXD <> 'Y'   ) and
     C                             (SELDES1 = *Blanks
     C                                 or %Scan(%Trim(SELDES1):IMDES1) <> *Zero)
     C                             and
     C                             (SELFIND = *Blanks
     C                                 or %Scan(%Trim(SELFIND):IMITEM) <> *Zero
     C                                 or %Scan(%Trim(SELFIND):IMDES1) <> *Zero
     C                                 or %Scan(%Trim(SELFIND):IMDES2) <> *Zero
     C                                 or %Scan(%Trim(SELFIND):IMLOOK) <> *Zero)
     C                   Eval      *In26 = *On                                  ?SFLEND Indicator
     C                   Eval      RRN02 = RRN02 + 1
      *? Load Screen fields Now
     C                   Eval      SLDQTOH = LDQTOH
     C                   Eval      SLDQTAL = LDQTAL
     C                   Eval      SLDQTAV = LDQTAV
    ?C                   ExSr      CntTrays
    ?C                   Write     FXG07002                                     ?

     C                   EndIf                                                  ?
    ?C     RdyDate       ReadE     FDLOTDSA
     C                   EndDo                                                  ?

     C                   IF        *In26 = *On
    ?C     RRN02         Chain     FXG07002                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Update    FXG07002                                     ?
     C                   EndIF                                                  ?

     C                   Eval      SAVRdyDate = SELRdyDate
     C                   Eval      SAVSHOWALL = SHOWALL
     C                   Eval      SAVITEM = SELITEM
     C                   Eval      SAVSIZE = SELSIZE
     C                   Eval      SAVDES1 = SELDES1
     C                   Eval      SAVFIND = SELFIND
     C                   Eval      SAVFIXD = SELFIXD

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      LOAD03 - Load Screen 03                            :
      *?  :.........................................................:
    ?C     LOAD03        BegSr                                                  ?

      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
     C                   Eval      *In81 = *Off
     C                   Eval      StartRRN03 = *Zero
    ?C                   Write     FXG07003C                                    ?

      *? Load the Subfile
     C                   Eval      RdyDate  =
     C                             $Date7($DateMDY(SELRdyDate))

     C                   Z-add     *Zero         RRN03                          ?

    ?C     TrayKey       SetLL     FTRAYD
    ?C     TrayKey       ReadE     FTRAYD
     C                   DoW       not %EOF(FTRAYD)
    ?C     TRTAG#        Chain     FTRAYFIXED
     C                   If        %Found(FTRAYFIXED)
     C                   Move      TFTIME        FixDate
     C     *MDY          Move      FixDate       DateFixed
     C                   Else
     C                   Move      *Blanks       TFSTAT
     C                   Move      *Blanks       DateFixed
     C                   EndIf
     C                   Eval      RRN03 = RRN03 + 1
     C                   Eval      *In26 = *On
    ?C                   Write     FXG07003                                     ?
    ?C     TrayKey       ReadE     FTRAYD
     C                   EndDo                                                  ?

     C                   IF        *In26 = *On
    ?C     RRN03         Chain     FXG07003                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Update    FXG07003                                     ?
     C                   EndIF                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      EDIT01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     EDIT01        BegSr                                                  ?

      *? Process pre-edit Functions F3, F5
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In03
     C                   MOVE      *ON           *INLR                          ?
      *? Refresh Requested
    ?C                   When         *In05
    ?C                   ExSr      LOAD01
    ?C                   ExSr      SCRN01
      *? Verify Sow Date NOT *ZERO.
    ?C                   When      SELRdyDate = 0
     C                   Eval      $Err_MsgId   = 'DATE902'
     C                   Eval      $Err_MsgData = 'Ready'
    ?C                   ExSr      $SndError
    ?C                   ExSr      SCRN01
      *? Verify Sow Date is a Date
    ?C                   When      not $IsDate#(SELRdyDate:'*MDY')
     C                   Eval      $Err_MsgId   = 'DATE901'
     C                   Eval      $Err_MsgData = %Char(SELRdyDate)
    ?C                   ExSr      $SndError
    ?C                   ExSr      SCRN01
      *? Verify Sow Date is a Monday
    ?C                   When      $WeekDay($DateMDY(SELRdyDate):'MON') <> 1    ?Date not a Monday
     C                   Eval      $Err_MsgID = 'DATE904'
     C                   Eval      $Err_MsgData = %EditW(SELRdyDate:'  /  /  ')
     C                   Eval      SELRdyDate=
     C                             $MDYDate($Monday($DateMDY(SELRdyDate):'MON'))
     C                   Eval      $ERR_MsgData = %Trim($ERR_MsgData) +
     C                             %EditW(SELRdyDate:'  /  /  ')
    ?C                   ExSr      $SndError
    ?C                   ExSr      SCRN01
      *? Previous Week Requested
    ?C                   When         *In08
     C                   Eval      SELRdyDate=
     C                             $MDYDate($AddDate($DateMDY(SELRdyDate):-7))
    ?C                   ExSr      SCRN01
      *? Next Week Requested
    ?C                   When         *In09
     C                   Eval      SELRdyDate=
     C                             $MDYDate($AddDate($DateMDY(SELRdyDate):+7))
    ?C                   ExSr      SCRN01
      *? Passed all Edits ==> Screen 02
    ?C                   OTHER                                                  ?
    ?C                   ExSr      LOAD02
    ?C                   ExSr      SCRN02
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      EDIT02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     EDIT02        BegSr                                                  ?

      *? Process pre-edit Functions F3, F6, F7 & F9
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In03
     C                   MOVE      *ON           *INLR                          ?
      *? Refresh Requested
    ?C                   When         *In05
    ?C                   ExSr      LOAD02
    ?C                   ExSr      SCRN02
      *? Cancel Requested
    ?C                   When         *In12
    ?C                   ExSr      SCRN01
      *? Verify Sow Date NOT *ZERO.
    ?C                   When      SELRdyDate = 0
     C                   Eval      $Err_MsgId   = 'DATE902'
     C                   Eval      $Err_MsgData = 'Ready'
    ?C                   ExSr      $SndError
    ?C                   ExSr      SCRN02
      *? Verify Sow Date is a Date
    ?C                   When      not $IsDate#(SELRdyDate:'*MDY')
     C                   Eval      $Err_MsgId   = 'DATE901'
     C                   Eval      $Err_MsgData = %Char(SELRdyDate)
    ?C                   ExSr      $SndError
    ?C                   ExSr      SCRN02
      *? Verify Sow Date is a Monday
    ?C                   When      $WeekDay($DateMDY(SELRdyDate):'MON') <> 1    ?Date not a Monday
     C                   Eval      $Err_MsgID = 'DATE904'
     C                   Eval      $Err_MsgData = %EditW(SELRdyDate:'  /  /  ')
     C                   Eval      SELRdyDate=
     C                             $MDYDate($Monday($DateMDY(SELRdyDate):'MON'))
     C                   Eval      $ERR_MsgData = %Trim($ERR_MsgData) +
     C                             %EditW(SELRdyDate:'  /  /  ')
    ?C                   ExSr      $SndError
    ?C                   ExSr      SCRN02
      *? Previous Week Requested
    ?C                   When         *In08
     C                   Eval      SELRdyDate=
     C                             $MDYDate($AddDate($DateMDY(SELRdyDate):-7))
    ?C                   ExSr      LOAD02
    ?C                   ExSr      SCRN02
      *? Next Week Requested
    ?C                   When         *In09
     C                   Eval      SELRdyDate=
     C                             $MDYDate($AddDate($DateMDY(SELRdyDate):+7))
    ?C                   ExSr      LOAD02
    ?C                   ExSr      SCRN02
      *? View Tag Details Requested
    ?C                   When         *In01 and SFLCSRRRN <> *Zero
    ?C     SFLCSRRRN     Chain     FXG07002
    ?C                   ExSr      LOAD03
    ?C                   ExSr      SCRN03
      *? Selection Changed
    ?C                   When      SELRdyDate <> SAVRdyDate or
    ?C                             SHOWALL <> SAVSHOWALL or
    ?C                             SELITEM <> SAVITEM or
    ?C                             SELSIZE <> SAVSIZE or
    ?C                             SELDES1 <> SAVDES1 or
    ?C                             SELFIND <> SAVFIND or
    ?C                             SELFIXD <> SAVFIXD
     C                   Eval      SAVRdyDate = SELRdyDate
     C                   Eval      SAVSHOWALL = SHOWALL
     C                   Eval      SAVITEM = SELITEM
     C                   Eval      SAVSIZE = SELSIZE
     C                   Eval      SAVDES1 = SELDES1
     C                   Eval      SAVFIND = SELFIND
     C                   Eval      SAVFIXD = SELFIXD
    ?C                   ExSr      LOAD02
    ?C                   ExSr      SCRN02
      *? If no Functions, Redisplay
    ?C                   OTHER                                                  ?
      *? Redisplay
    ?C                   ExSr      SCRN02
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      EDIT03 - EDIT Screen 03                            :
      *?  :.........................................................:
    ?C     EDIT03        BegSr                                                  ?

      *? Process pre-edit Functions F3, F5, & F12
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In03
     C                   MOVE      *ON           *INLR                          ?
      *? Refresh Requested
    ?C                   When         *In05
    ?C                   ExSr      LOAD03
    ?C                   ExSr      SCRN03
      *? Cancel Requested
    ?C                   When         *In12
    ?C                   ExSr      LOAD02
    ?C                   ExSr      SCRN02
      *? If no Functions, Got Back to Screen 2
    ?C                   OTHER                                                  ?
      *? Redisplay
    ?C                   ExSr      SCRN02
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      CNTTRAYS - Count Trays                             :
      *?  :.........................................................:
    ?C     CntTrays      BegSr                                                  ?

      *? Count Tray Tags and put in proper buckets
     C                   Clear                   CNTFTRAY
     C                   Clear                   CNTFIXED
     C                   Clear                   TRAY_A
     C                   Clear                   TRAY_F
     C                   Clear                   TRAY_P
     C                   Clear                   TRAY_D
     C                   Clear                   TRAY_M
     C                   Clear                   TRAY_B
     C                   Clear                   TRAY_OTH
    ?C     TrayKey       KList
    ?C                   KFld                    RdyDate
    ?C                   KFld                    IMITEM
    ?C                   KFld                    IMSIZE
    ?C     TrayKey       SetLL     FTRAYD
    ?C     TrayKey       ReadE     FTRAYD
    ?C                   DoW       not %EOF(FTRAYD)
     C                   If        TRSTAT <> 'D'
     C                   Eval      CNTFTRAY = CNTFTRAY + 1
     C                   EndIf
    ?C     TRTAG#        SetLL     FTRAYFIXED
     C                   If        %Equal(FTRAYFIXED)
     C                   Eval      CNTFIXED = CNTFIXED + 1
     C                   EndIf
    ?C                   Select
    ?C                   When      TRSTAT = 'A'
     C                   Eval      Tray_A = Tray_A + 1
    ?C                   When      TRSTAT = 'F'
     C                   Eval      Tray_F = Tray_F + 1
    ?C                   When      TRSTAT = 'P'
     C                   Eval      Tray_P = Tray_P + 1
    ?C                   When      TRSTAT = 'D'
     C                   Eval      Tray_D = Tray_D + 1
    ?C                   When      TRSTAT = 'M'
     C                   Eval      Tray_M = Tray_M + 1
    ?C                   When      TRSTAT = 'B'
     C                   Eval      Tray_B = Tray_B + 1
    ?C                   Other
    ?C                   Eval      Tray_OTH = Tray_OTH + 1
    ?C                   EndSl
    ?C     TrayKey       ReadE     FTRAYD
    ?C                   EndDo                                                  ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      $ClrError - Clear Error Message Subfile            :
      *?  :      $SndError - Send an Error Message to the PGMMSGQ   :
      * ? :      SRMSGF - Clear or send messages to Pgm msg queue   :
      *?  :.........................................................:
    ?C/Copy QFunctDefn,$ERRMSGSR                                                ?


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   Time                    Now

     C                   Eval      SelRdyDate= $MDYDate(
     C                                   $Monday($AddDate($Date(0):+7):'SAT'))

     C                   Eval      $ERR_PROG  = 'FXG070'                        ?Pgm Msg Queue
     C                   Eval      $ERR_MSGF  = 'KPMSGF'                        ?Message File
     C                   Eval      $ERR_LIBR   = '*LIBL'                        ?Library
    ?C                   ExSr      $ClrError

    ?C                   EndSr                                                  ?
