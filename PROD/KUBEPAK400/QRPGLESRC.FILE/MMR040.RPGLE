     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:            Truck Chart Selection and Print                 :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  April 2004           ? Kube-Pak Corporation ?    :
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
      *? :  ClrError -?Clear Error MEssage Subfile                   ?:
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
      *? :  40      ?Lookup Indicator                                ?:
      *? :  50      ?Error Indicator (All Errors)                    ?:
      *? :  70      ?Push Buttone Default 70 = Yes, N70 = No         ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
     FMMR040FM  CF   E             WORKSTN
     F                                     DEVID(WSID)

     FFHORDRPU  UF   E           K DISK                                         ?Order Hearer

      *? Function Prototypes
    ?D/COPY QFunctDefn,$isPrinter
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$isDate#
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,QCmdExc
    ?D/COPY QFunctDefn,$NeedDir

      *? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

     D LDA_DS          DS                  DTAARA(*LDA)
     D  UDSEXT              1000   1000
     D  UDSDAT              1001   1004P 0
     D  UDSTRK              1005   1008

      *? Field Definitions
     D   SDate         S              6S 0 Inz(0)                               ?Ship Date MDY
     D   SDateYMD7     S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   Copies1@      S              2A                                        ?Copies
     D   Copies2@      S              2A                                        ?Copies

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

     C                   SELECT                                                 ?
     C     Screen        WhenEq    1                                            ?
     C                   ExSr      Edit01                                       ?
     C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     MMR04001                                     ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

      *? Load Screen Defaults
     C                   If        ChgOnly = *Blanks
     C                   Eval      ChgOnly = 'N'
     C                   EndIf

     C                   If        COPIES1@ <> *Blanks
     C                   Move      COPIES1@      COPIES1
     C                   Else
     C                   Eval      Copies1 = 2
     C                   EndIf

     C                   If        COPIES2@ <> *Blanks
     C                   Move      COPIES2@      COPIES2
     C                   Else
     C                   Eval      Copies2 = 1
     C                   EndIf

     C                   If        SDateYMD7@ <> *Blanks
     C                   Move      SDateYMD7@    SDateYMD7
     C                   Eval      SDate=$MDYDate($Date(SDateYMD7))
     C                   Else
     C                   Eval      SDATE  = $MDYDate($Monday($Date(0):'TUE'))   ?
     C                   EndIf

     C                   Eval      PMASTER = *Zero

     C                   If        STRUCK = *Blanks
     C                   Eval      STRUCK = 'Y'                                 ?
     C                   EndIf

     C                   If        SOTHER = *Blanks
     C                   Eval      SOTHER = 'Y'                                 ?
     C                   EndIf

     C                   If        LP1ID = *Blanks
     C                   Eval      LP1ID = 'XERPRT01'
     C                   EndIf

     C                   If        SAVE1 = *Blanks
     C                   Move      'Y'           SAVE1
     C                   EndIf

     C                   If        SAVE2 = *Blanks
     C                   Move      'Y'           SAVE2
     C                   EndIf

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

    ?C                   SELECT                                                 ?
      *? Exit Requested
    ?C                   When      *In03 = *ON                                          ?
     C                   MOVE      *ON           *INLR                          ?
     C                   Eval      Cancel = 'X'
      *? When Previous Week is Requested
    ?C                   When      *In08 = *ON                                  ?
     C                   Eval      SDate=$MDYDate($AddDate($DateMDY(SDate):-7))
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Next Week is Requested
    ?C                   When      *In09 = *ON                                  ?
     C                   Eval      SDate=$MDYDate($AddDate($DateMDY(SDate):7))
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Rules Are Requested
    ?C                   When      *In11 = *ON                                  ?
     C                   CALL      'MMR010'
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Refresh is Requested
    ?C                   When      *In05 = *ON                                  ?
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Date is invalid
    ?C                   When      not $isDate#(SDATE:'*MDY')                           ?
     C                   Eval      $#MSGD = %EditC(SDATE:'Z')
     C                   Eval      $#MSID = 'DATE901'
     C                   EXSR      SndError
     C                   ExSr      Scrn01                                       ?
      *? When Printer 1 is Blank
    ?C                   When      LP1ID = *Blanks
     C                   Eval      $#MSGD = LP1ID
     C                   Eval      $#MSID = 'PRT0003'
     C                   EXSR      SndError
     C                   ExSr      Scrn01                                       ?
      *? When Printer 1 is Invalid
    ?C                   When      not $isPrinter(LP1ID)
     C                   Eval      $#MSGD = LP1ID
     C                   Eval      $#MSID = 'PRT0102'
     C                   EXSR      SndError
     C                   ExSr      Scrn01                                       ?
      *? When Printer 2 is Invalid
    ?C                   When      LP2ID <> *Blanks and not $isPrinter(LP2ID)
     C                   Eval      $#MSGD = LP2ID
     C                   Eval      $#MSID = 'PRT0102'
     C                   EXSR      SndError
     C                   ExSr      Scrn01                                       ?
      *? When Zero copies specified with a printer
    ?C                   When         LP1ID <> *Blanks and COPIES1 = 0
    ?C                             or LP2ID <> *Blanks and COPIES2 = 0
     C                   Eval      $#MSID = 'MMR0401'
     C                   EXSR      SndError
     C                   ExSr      Scrn01                                       ?
    ?C                   OTHER                                                  ?
      *? If no other edit, the process by returning.
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))
     C                   Move      Copies1       Copies1@
     C                   Move      Copies2       Copies2@
     C                   Move      SDateYMD7     SDateYMD7@
     C                   Move      PMASTER       PMASTER@
     C                   MOVE      *ON           *INLR                          ?
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ClrError - Clear Error Message Subfile             :
      *?  :.........................................................:
    ?C     ClrError      BegSr                                                  ?

     C                   MOVE      'C'           $#MSFN            1            ?
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      *In50 = *Off                                 ?Error Indicator

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      SndError - Send an Error Message to the PGMMSGQ    :
      *?  :.........................................................:
    ?C     SndError      BegSr                                                  ?

     C                   MOVE      'S'           $#MSFN            1            ?
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      *In50 = *On                                  ?Error Indicator

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      * ? :      SRMSGF - Clear or send messages to Pgm msg queue   :
      *?  :.........................................................:
    ?C     SRMSGF        BegSr                                                  ?

      *? Define Parameter List - define variables         ?

     C     PLMSGF        PLIST                                                  ?
     C                   Parm                    $#PGMQ           10            ?Pgm Msg Queue
     C                   Parm                    $#MSGF           10            ?Message File
     C                   Parm                    $#MSGL           10            ?Library
     C                   Parm                    $#MSID            7            ?Message Id
     C                   Parm                    $#MSGD          100            ?Message Data
     C                   Parm                    $#MSKY            4            ?Message Key
     C                   Parm                    $#MSFN            1            ?Send or Clear

      *? Call Msg processing CL                           ?

     C                   CALL      'XAMSFC'      PLMSGF                         ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *Entry        PList
    ?C                   Parm                    Cancel            1
    ?C                   Parm                    SDateYMD7@        7
    ?C                   Parm                    PMASTER@          2
    ?C                   Parm                    STRUCK
    ?C                   Parm                    SOTHER
    ?C                   Parm                    LP1ID            10
    ?C                   Parm                    LP2ID            10
    ?C                   Parm                    COPIES1@
    ?C                   Parm                    COPIES2@
    ?C                   Parm                    SAVE1             1
    ?C                   Parm                    SAVE2             1
    ?C                   Parm                    ChgOnly           1
    ?C                   Parm                    FedExOnly         1

     C                   MOVE      ##PGM         $#PGMQ                         ?PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                         ?MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                         ?LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                         ?MESSAGE ID

     C                   Eval      SDate =                                      ?Ship Date MDY
     C                             $MDYDate($Monday($Date(0):'TUE'))            ?Ship Date MDY
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))          ?Ship Date YMD7

     C                   ExSr      Load01                                       ?
     C                   Eval      $#MSID = 'CPY0000'
     C                   ExSr      SndError                                     ?
     C                   ExSr      Scrn01                                       ?

    ?C                   EndSr                                                  ?
