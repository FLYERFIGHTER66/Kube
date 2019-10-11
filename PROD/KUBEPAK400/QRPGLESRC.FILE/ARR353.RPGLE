    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Fin. Inventory Master Inquiry                      :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Oct. 2008            ? Kube-Pak Corporation ?    :
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
      *? :  40      ?RollDn Indicator                                ?:
      *? :  50      ?Error Indicator (All Errors)                    ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
      *
     ?* Type 1 = Invoice
     ?*      2 = Cash Receipt Payment
     ?*      3 = On Account Payment
     ?*      4 = Adjustment
     ?*      5 = Credit Memo
     ?*      6 = Non A/R Cash
     ?*      7 = Late Charge
     ?*      8 = Payment VOID
     ?*      9 = Discount
     ?*     10 = Payment on Credit Card
     ?*     11 = Downpayment
     ?*     12 = Returned Check
     ?*     14 = Returned Check Charge
      *
      *
      *
     FFMTRANCD  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFGLDF     IF   E           K DISK
     FARR353    O    F  165        PRINTER OFLIND(*INOF)
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$MDYDate

     D MSG             S             11    DIM(20) CTDATA PERRCD(1)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
     D                UDS
     D  LCO                    1      2  0
     D  LDATE                  3      9  0
     D  USER                  10     19
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
     D  ToDATE               172    178S 0
      *
     D  TCC            S               N   Inz(*off)
     D  TTCHCK         S                   Like(TOTAR$)
     D  TGLMPC         S                   Like(TOTAR$)
      *
     D  LRTGLMPC       S                   Like(TGLMPC)
     D  LRTPETTY       S                   Like(TPETTY)
     D  LRTOTDEP       S                   Like(TOTDEP)
     D  LRTOTRET       S                   Like(TOTRET)
     D  LRTOTWIR       S                   Like(TOTWIR)
     D  LRTTCHCK       S                   Like(TTCHCK)
     D  LRTOTNAR       S                   Like(TOTNAR)
     D  LRTOTCAJ       S                   Like(TOTCAJ)
     D  LRTOTAR$       S                   Like(TOTAR$)
     D  LRTOTTCC       S                   Like(TOTTCC)
     D  LRTTCCRF       S                   Like(TTCCRF)
     D  LRTTCCOA       S                   Like(TTCCOA)
     D  LRTOTCC        S                   Like(TOTCC )
     D  LRTOTDIS       S                   Like(TOTDIS)
     D  LRTOTRCC       S                   Like(TOTRCC)
     D  LRTOTADJ       S                   Like(TOTADJ)
     D  PrintDate      S              6S 0
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      * GET USER I.D.
     C     USER          IFGT      *BLANKS
    ?C     USER          CHAIN     FMUSER                             90
     C                   ELSE
     C                   MOVEL     MSG(9)        USNAME
     C                   END
      *
     C                   Z-ADD     1             FIRST             6 0
     C                   Z-ADD     1             CNT               6 0
      *
     C                   MOVEL     '01'          GDTYPE
    ?C     GLDKEY        KLIST
    ?C                   KFLD                    LCO
    ?C                   KFLD                    GDTYPE
    ?C     GLDKEY        CHAIN     FGLDF                              90
      *
     C                   Z-ADD     LDATE         ##CYMD            7 0
    ?C                   CALL      '@DTCNV'
    ?C                   PARM                    ##CYMD            7 0
    ?C                   PARM                    ##MDY             6 0
    ?C                   PARM                    ##ERR             1
     C                   Z-ADD     ##MDY         DAYDTE            6 0
      *
    ?C     LCO           CHAIN     FMCORG                             97
    ?C                   EXCEPT    HDG
      *
    ?C     LDATE         SETLL     FMTRANCD
    ?C     NXT           TAG
     C                   MOVEL     *BLANKS       DESC
    ?C                   READ      FMTRANCD                               90
     C   90              GOTO      END

     C                   If        MTTDAT > ToDATE
     C                   GOTO      END
     C                   EndIf

     C                   If        MTTDAT <> SavMTTDAT
    ?C                   ExSr      Print_Day
     C                   EndIf
      *
      * OVER RIDE TYPE 04 IF NO HIT BELOW
     C     MTTTYP        IFEQ      04
     C                   MOVEL     MSG(2)        TYPE              8
     C     MTSSUF        IFEQ      'OA'
     C                   MOVEL     MSG(10)       TYPE
     C                   END
     C     MTSSUF        IFEQ      'CM'
     C                   MOVEL     MSG(11)       TYPE
     C                   END
     C                   END
      *
     C     MTDESC        IFGT      *BLANKS
     C                   MOVEL     MTDESC        DESC             26
     C                   ENDIF
      *
    ?C                   Select
    ?C     MTCOMP        WhenNE    LCO
     C                   GOTO      NXT
      *
      * CHECK USER
    ?C     USER          WhenGT    *BLANKS
    ?C     MTUSER        ANDNE     USER
     C                   GOTO      NXT
      *
    ?C     MTTTYP        WhenEQ    1
     C                   GOTO      NXT
      *
    ?C     MTTTYP        WhenEQ    02
     C                   ADD       MT$AMT        TOTAR$           11 2           Cash & Checks
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   Z-SUB     MT$AMT        MT$AMT                          ** Reverse Sign
     C                   MOVEL     MSG(1)        TYPE              8
      *
    ?C     MTTTYP        WhenEQ    03
     C                   ADD       MT$AMT        TOTAR$           11 2           Cash & Checks
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   MOVEL     MSG(1)        TYPE              8
     C                   Z-SUB     MT$AMT        MT$AMT                          ** Reverse Sign
      *
    ?C     MTTTYP        WhenEQ    04
    ?C     MTCSAJ        ANDNE     'Y'
    ?C     MTGLAC        ANDEQ     GDARRC
     C                   MOVEL     MSG(2)        TYPE              8
    ?C                   Select
    ?C                   When      MTREAS = 'WIR'
     C                   ADD       MT$AMT        TOTDEP
     C                   ADD       MT$AMT        TOTWIR           11 2           Wire Transfers
    ?C                   When      MTREAS = 'CDC'
     C                   SUB       MT$AMT        TTCCRF           11 2           Credt Card Refunds
     C                   ADD       MT$AMT        TOTTCC                          Total Credit Cards
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
    ?C                   When      MTCUST = 999999
    ?C                             and MTSUFF = 'PC'
     C                   ADD       MT$AMT        TPETTY           11 2           Petty Cash
    ?C                   Other
     C                   ADD       MT$AMT        TOTADJ           11 2           Non-Cash Adjustment
    ?C                   EndSL
     C                   Z-SUB     MT$AMT        MT$AMT                          ** Reverse Sign
      *
    ?C     MTTTYP        WhenEQ    04
    ?C     MTCSAJ        ANDEQ     'Y'
    ?C     MTGLAC        ANDEQ     GDARRC
     C                   If        MTCUST = 999999
     C                   ADD       MT$AMT        TPETTY           11 2           Petty Cash
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   Else
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   SUB       MT$AMT        TOTCAJ           11 2           Cash Adjustments
     C                   EndIf
     C                   Z-SUB     MT$AMT        MT$AMT                          ** Reverse Sign
     C                   MOVEL     MSG(5)        TYPE              8
      *
    ?C     MTTTYP        WhenEQ    04
    ?C     MTCSAJ        ANDEQ     'Y'
    ?C     MTGLAC        ANDNE     GDARRC
    ?C     MTCUST        ANDEQ     999999
     C                   ADD       MT$AMT        TPETTY           11 2           Petty Cash
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
      *
    ?C     MTTTYP        WhenEQ    5
     C                   GOTO      NXT
      *
    ?C     MTTTYP        WhenEQ    06
     C     MTGLAC        ANDEQ     GDCASH
     C                   MOVEL     MSG(4)        TYPE              8
     C                   ADD       MT$AMT        TOTNAR           11 2
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
      *
    ?C     MTTTYP        WhenEQ    7
     C                   GOTO      NXT
      *
    ?C     MTTTYP        WhenEQ    08
     C                   ADD       MT$AMT        TOTAR$           11 2           Cash & Checks
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   MOVEL     MSG(1)        TYPE              8
      *
    ?C     MTTTYP        WhenEQ    09
     C                   ADD       MT$AMT        TOTDIS           11 2
     C                   MOVEL     MSG(3)        TYPE              8
      *
    ?C     MTTTYP        WhenEQ    10
    ?C     MTCRC#        ANDGT     0
    ?C     MTSUFF        ANDNE     'OA'
     C                   MOVEL     MTCRCD        MTCHEK
     C                   MOVEL     MTCRC#        DESC1            21
     C                   MOVE      MTCRCE        DESC1            21
     C                   MOVEL     DESC1         DESC
     C                   ADD       MT$AMT        TOTCC            11 2
     C                   ADD       MT$AMT        TOTTCC           11 2
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   MOVEL     MSG(6)        TYPE              8
     C                   Z-SUB     MT$AMT        MT$AMT                          ** Reverse Sign
      *
    ?C     MTTTYP        WhenEQ    10
    ?C     MTCRC#        ANDGT     0
    ?C     MTSUFF        ANDEQ     'OA'
     C                   ADD       MT$AMT        TTCCOA           11 2
     C                   ADD       MT$AMT        TOTTCC
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   MOVEL     MSG(13)       TYPE              8
     C                   Z-SUB     MT$AMT        MT$AMT                          ** Reverse Sign
      *
    ?C     MTTTYP        WhenEQ    10
    ?C     MTCRC#        ANDEQ     0
    ?C     MTSUFF        ANDNE     'OA'
     C                   ADD       MT$AMT        TOTAR$           11 2           Cash & Checks
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   Z-SUB     MT$AMT        MT$AMT
     C                   MOVEL     MSG(1)        TYPE              8
      *
    ?C     MTTTYP        WhenEQ    12
     C                   MOVEL     MSG(7)        TYPE              8
     C                   ADD       MT$AMT        TOTDEP
     C                   Z-Sub     MT$AMT        MT$AMT
     C                   ADD       MT$AMT        TOTRET           11 2
      *
    ?C     MTTTYP        WhenEQ    14
    ?C     MT$AMT        ANDGT     0.00
     C                   MOVEL     MSG(12)       TYPE              8
     C                   ADD       MT$AMT        TOTRCC           11 2
      *
    ?C                   Other
     C                   GOTO      NXT
    ?C                   EndSL
      *
     C                   ADD       1             FIRST
     C                   ADD       1             CNT

     C   OF              DO
    ?C                   EXCEPT    HDG
     C                   ENDDO

     C                   GOTO      NXT
      *
     C     END           TAG
    ?C                   ExSr      Print_Day
     C   OF              DO
    ?C                   EXCEPT    HDG
     C                   ENDDO
    ?C                   EXCEPT    TLR

     C                   SETON                                        LR
      *
    ?C     HDGTLR        BEGSR
    ?C                   EXCEPT    HDG
    ?C                   EXCEPT    TLR
    ?C                   EndSR
      *
    ?C     Print_Day     BEGSR
     C                   Z-SUB     TOTAR$        TOTAR$                         Cash & Checks
     C                   Z-SUB     TOTCC         TOTCC
     C                   Z-SUB     TOTTCC        TOTTCC
     C                   Z-SUB     TTCCOA        TTCCOA
     C                   Z-SUB     TOTDEP        TOTDEP                          Total G/L Cash
     C                   Eval      TTCHCK = TOTAR$ + TOTCAJ + TOTNAR             Total Cash / Checks
     C                   Eval      TGLMPC = TOTDEP + TPETTY                      G/L Cash less P/C
     C                   Eval      LRTGLMPC = LRTGLMPC + TGLMPC
     C                   Eval      LRTPETTY = LRTPETTY + TPETTY
     C                   Eval      LRTOTDEP = LRTOTDEP + TOTDEP
     C                   Eval      LRTOTRET = LRTOTRET + TOTRET
     C                   Eval      LRTOTWIR = LRTOTWIR + TOTWIR
     C                   Eval      LRTTCHCK = LRTTCHCK + TTCHCK
     C                   Eval      LRTOTNAR = LRTOTNAR + TOTNAR
     C                   Eval      LRTOTCAJ = LRTOTCAJ + TOTCAJ
     C                   Eval      LRTOTAR$ = LRTOTAR$ + TOTAR$
     C                   Eval      LRTOTTCC = LRTOTTCC + TOTTCC
     C                   Eval      LRTTCCRF = LRTTCCRF + TTCCRF
     C                   Eval      LRTTCCOA = LRTTCCOA + TTCCOA
     C                   Eval      LRTOTCC = LRTOTCC + TOTCC
     C                   Eval      LRTOTDIS = LRTOTDIS + TOTDIS
     C                   Eval      LRTOTRCC = LRTOTRCC + TOTRCC
     C                   Eval      LRTOTADJ = LRTOTADJ + TOTADJ
    ?C   91              Except    TLRD
     C                   Eval      *In91 = *On
     C                   Z-add     MTTDAT        SavMTTDAT         7 0
     C                   Eval      PrintDate = $MDYDate($Date(SavMTTDAT))
     C                   Eval      TGLMPC = *Zero
     C                   Eval      TPETTY = *Zero
     C                   Eval      TOTDEP = *Zero
     C                   Eval      TOTRET = *Zero
     C                   Eval      TOTWIR = *Zero
     C                   Eval      TTCHCK = *Zero
     C                   Eval      TOTNAR = *Zero
     C                   Eval      TOTCAJ = *Zero
     C                   Eval      TOTAR$ = *Zero
     C                   Eval      TOTTCC = *Zero
     C                   Eval      TTCCRF = *Zero
     C                   Eval      TTCCOA = *Zero
     C                   Eval      TOTCC = *Zero
     C                   Eval      TOTDIS = *Zero
     C                   Eval      TOTRCC = *Zero
     C                   Eval      TOTADJ = *Zero
    ?C                   EndSR
      *
    ?OARR353    E            HDG         0  0 02
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35

 +20 O                       RGNAMC              95
 +20 O                                          115 'Company:'
 +20 O                       LCO                118

 +40 O                       PAGE          Z    160
 +40 O                                          156 'Page:'
    ?OARR353    E            HDG         0  0
 +20 O                       RGNAMC              95
    ?OARR353    E            HDG         0  0
 +20 O                       RGNAMC              95
    ?O          E            HDG              03
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
 +20 O                                           87 'Multi-day Cash Receipts'
 +20 O                                           96 'Register'
 +40 O                       TIMOD              160 '  :  :  '
    ?O          E            HDG              04
 +20 O                                           70 'For Date:'
 +20 O                       DAYDTE        Y     79
 +20 O                                           90 'For User:'
 +20 O                       USNAME             121
    ?O          E            HDG              05
     O                                          020 '     '
     O                                          030 'Credit '
     O                                          040 'Credit '
     O                                          050 'Total '
     O                                          065 '     '
     O                                          075 'Cash '
     O                                          085 'Non- '
     O                                          100 'Total '
     O                                          110 '  '
     O                                          120 '  '
     O                                          135 'Total '
     O                                          145 'Petty '
     O                                          160 'G/L Cash '
    ?O          E            HDG              06
     O                                          020 'Credit '
     O                                          030 'Card '
     O                                          040 'Card '
     O                                          050 'Credit '
     O                                          065 'Cash/ '
     O                                          075 'Adjust- '
     O                                          085 'A/R '
     O                                          100 'Cash / '
     O                                          110 'Wire '
     O                                          120 'Returned '
     O                                          135 'G/L '
     O                                          145 'Cash '
     O                                          160 'Less '
    ?O          E            HDG              07
     O                                          007 'Date: '
     O                                          020 'Card: '
     O                                          030 'O/A: '
     O                                          040 'Refund: '
     O                                          050 'Card: '
     O                                          065 'Checks: '
     O                                          075 'ments: '
     O                                          085 'Cash: '
     O                                          100 'Checks: '
     O                                          110 'Transfers: '
     O                                          120 'Checks: '
     O                                          135 'Cash: '
     O                                          145 'Transfer: '
     O                                          160 'P/C: '
    ?O          E            HDG            2
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O                                          100 '____________________'
     O                                          120 '____________________'
     O                                          140 '____________________'
     O                                          160 '____________________'

    ?O          EF           TLRD        0  0
     O                       TGLMPC        J    160
     O                       TOTDEP        J    135
     O                       TTCHCK        J    100
     O                       TOTAR$        J     65
     O                       TOTTCC        J     50
     O                       PrintDate     Y      8
    ?O          EF           TLRD        0  0
     O                       TGLMPC        J    160
     O                       TOTDEP        J    135
     O                       TTCHCK        J    100
     O                       TOTAR$        J     65
     O                       TOTTCC        J     50
     O                       PrintDate     Y      8
    ?O          EF           TLRD        0  2
     O                       TGLMPC        JB   160
     O                       TPETTY        JB   145
     O                       TOTDEP        JB   135
     O                       TOTRET        JB   120
     O                       TOTWIR        JB   110
     O                       TTCHCK        JB   100
     O                       TOTNAR        JB    85
     O                       TOTCAJ        JB    75
     O                       TOTAR$        JB    65
     O                       TOTTCC        JB    50
     O                       TTCCRF        JB    40
     O                       TTCCOA        JB    30
     O                       TOTCC         JB    20
     O                       PrintDate     Y      8
    ?O          EF           TLR         0  0 72
     O                                          007 'TOTALS:'
    ?O          EF           TLR         0  0
     O                                          007 'TOTALS:'
    ?O          EF           TLR         0  1
     O                       LRTPETTY      JB   145
     O                       LRTOTRET      JB   120
     O                       LRTTCHCK      JB   100
     O                       LRTOTCAJ      JB    75
     O                       LRTOTTCC      JB    50
     O                       LRTTCCOA      JB    30
     O                                          007 'TOTALS:'
    ?O          EF           TLR
     O                       LRTGLMPC      JB   160
     O                       LRTOTDEP      JB   135
     O                       LRTOTWIR      JB   110
     O                       LRTOTNAR      JB    85
     O                       LRTOTAR$      JB    65
     O                       LRTTCCRF      JB    40
     O                       LRTOTCC       JB    20

**
Payment                        1
Adjust                         2
Discount                       3
Non A/R                        4
Cash Adj                       5
Crd Card                       6
Retd Chk                       7
Non-Cash                       8
All Users                      9
O/A Pay                       10
Apy C/M                       11
R.C.Chg.                      12
C/C O/A                       13
