    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ARR350
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- DAILY CASH RECEIPTS REGISTER
      *
      * Type 1 = Invoice
      *      2 = Cash Receipt Payment
      *      3 = On Account Payment
      *      4 = Adjustment
      *      5 = Credit Memo
      *      6 = Non A/R Cash
      *      7 = Late Charge
      *      8 = Payment VOID
      *      9 = Discount
      *     10 = Payment on Credit Card
      *     11 = Downpayment
      *     12 = Returned Check
      *     14 = Returned Check Charge
      *
      *            CHANGE--DATE-------DESCRIPTION
      * MJT01 - 08/23/01 - CHANGE ADJUSTMENT DESCRIPTION
      *  8/29/02 - PRINT TOTALS ON SAME PAGE.
      *
      *
     FFMTRANCD  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFGLDF     IF   E           K DISK
     FARR350    O    F  120        PRINTER OFLIND(*INOF)
      *
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
      *
     D  TCC            S               N   Inz(*off)
     D  TTCHCK         S                   Like(TOTAR$1)
     D  TGLMPC         S                   Like(TOTAR$1)
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$Upper
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   Z-Add     *Zero         LastCust          6 0
     C                   Z-Add     *Zero         CustCount         6 0
     C                   MOVE      TMWRK         TDATE             6 0
      * GET USER I.D.
     C     USER          IFGT      *BLANKS
     C     USER          CHAIN     FMUSER                             90
     C                   ELSE
     C                   MOVEL     MSG(9)        USNAME
     C                   END
      *
     C                   Z-ADD     1             FIRST             6 0
     C                   Z-ADD     1             CNT               6 0
      *
     C                   MOVEL     '01'          GDTYPE
     C     GLDKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GDTYPE
     C     GLDKEY        CHAIN     FGLDF                              90
      *
     C                   Z-ADD     LDATE         ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##MDY         DAYDTE            6 0
      *
     C     LCO           CHAIN     FMCORG                             97
     C                   EXCEPT    HDG
      *
     C     LDATE         SETLL     FMTRANCD
     C     NXT           TAG
     C                   MOVEL     *BLANKS       DESC
     C     LDATE         READE     FMTRANCD                               90
     C   90              GOTO      END
     C                   If        LastCust <> *Zero and LastCust <> MTCUST
     C                   If        DetCount > 0
     C                   Except    CustTot
     C                   ENDIF
     C                   Z-Add     *Zero         Cust$AMT         11 2
     C                   Z-Add     *Zero         DetCount          6 0
     C                   ENDIF
     C                   Eval      LastCust = MTCUST
      *
      * OVER RIDE TYPE 04 IF NO HIT BELOW
     C     MTTTYP        IFEQ      04
     C                   MOVEL     MSG(2)        TYPE              8
MJT01C     MTSSUF        IFEQ      'OA'
MJT01C                   MOVEL     MSG(10)       TYPE
MJT01C                   END
MJT01C     MTSSUF        IFEQ      'CM'
MJT01C                   MOVEL     MSG(11)       TYPE
MJT01C                   END
MJT01C                   END
      *
     C     MTDESC        IFGT      *BLANKS
     C                   MOVEL     MTDESC        DESC             26
     C                   ENDIF
      *
     C                   Eval      MTCHEK = %Trim($UPPER(MTCHEK))
      *
    ?C                   Select
     C     MTCOMP        WhenNE    LCO
     C                   GOTO      NXT
      *
      * CHECK USER
     C     USER          WhenGT    *BLANKS
     C     MTUSER        ANDNE     USER
     C                   GOTO      NXT
      *
     C     MTTTYP        WhenEQ    1
     C                   GOTO      NXT
      *
     C     MTTTYP        WhenEQ    02
WJB  C     MTCHEK        andEQ     'CASH'
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   Eval      Cust$AMT -= MT$AMT
     C                   ADD       MT$AMT        TOTAR$1          11 2           Cash
     C                   Z-SUB     MT$AMT        MT$AMT                          ** Reverse Sign
     C                   MOVEL     MSG(1)        TYPE              8
      *
WJB  C     MTTTYP        WhenEQ    02
WJB  C     MTCHEK        andEQ     'WIRE'
WJB  C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   Eval      Cust$AMT -= MT$AMT
WJB  C                   ADD       MT$AMT        TOTWIR           11 2           Wire
WJB  C                   Z-SUB     MT$AMT        MT$AMT                          ** Reverse Sign
WJB  C                   MOVEL     MSG(1)        TYPE              8
WJB   *
WJB  C     MTTTYP        WhenEQ    02
WJB  C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
WJB  C                   Eval      Cust$AMT -= MT$AMT
WJB  C                   ADD       MT$AMT        TOTAR$2          11 2           Checks
WJB  C                   Z-SUB     MT$AMT        MT$AMT                          ** Reverse Sign
WJB  C                   MOVEL     MSG(1)        TYPE              8
      *
     C     MTTTYP        WhenEQ    03
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   Eval      Cust$AMT -= MT$AMT
WJB  C     MTCHEK        IfEq      'CASH'
     C                   ADD       MT$AMT        TOTAR$1          11 2           Cash
WJB  C                   Else
WJB  C                   ADD       MT$AMT        TOTAR$2          11 2           Checks
WJB  C                   EndIf
     C                   MOVEL     MSG(1)        TYPE              8
     C                   Z-SUB     MT$AMT        MT$AMT                          ** Reverse Sign
      *
     C     MTTTYP        WhenEQ    04
     C     MTCSAJ        ANDNE     'Y'
     C*    MTGLAC        ANDEQ     GDARRC
     C     MTGLAC        ANDNE     GDARRC
     C                   MOVEL     MSG(2)        TYPE              8
TEMP C                   Z-SUB     MT$AMT        MT$AMT                          ** Reverse Sign
    ?C                   Select
    ?C                   When      MTREAS = 'CSH'
    ?C                             and MTSUFF = 'OA'
    ?C                             and MTGLAC = 0
     C                   ADD       MT$AMT        TOTADJ           11 2           Non-Cash Adjustment
    ?C                   When      MTREAS = 'CSH'
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   Eval      Cust$AMT -= MT$AMT
     C                   SUB       MT$AMT        TOTCAJ           11 2           Cash Adjustments
     C                   MOVEL     MSG(5)        TYPE              8
    ?C                   When      MTREAS = 'WIR'
     C                   ADD       MT$AMT        TOTDEP                          Total G/L Cash
     C                   Eval      Cust$AMT -= MT$AMT
     C                   ADD       MT$AMT        TOTWIR           11 2           Wire Transfers
    ?C                   When      MTREAS = 'CDC'
    ?C                             and MTSUFF <> 'OA'
    ?C                             and MTGLAC = 0
     C                   ADD       MT$AMT        TOTADJ           11 2           Non-Cash Adjustment
    ?C                   When      MTREAS = 'CDC'
    ?C                             and MTSUFF <> 'OA'
     C                   SUB       MT$AMT        TTCCRF           11 2           Credt Card Refunds
     C                   ADD       MT$AMT        TOTTCC                          Total Credit Cards
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   Eval      Cust$AMT -= MT$AMT
    ?C                   When      MTREAS = 'CDC'
    ?C                             and MTSUFF =  'OA'
    ?C                             and MTGLAC <> 0
     C                   SUB       MT$AMT        TTCCRP           11 2           CC Refund Previous
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   Eval      Cust$AMT -= MT$AMT
    ?C                   When      MTREAS = 'CDC'
    ?C                             and MTSUFF =  'OA'
    ?C                             and MTGLAC = 0
     C                   ADD       MT$AMT        TOTADJ           11 2           Non-Cash Adjustment
    ?C                   When      MTCUST = 999999
    ?C                             and MTSUFF = 'PC'
     C                   ADD       MT$AMT        TPETTY           11 2           Petty Cash
    ?C                   Other
     C                   ADD       MT$AMT        TOTADJ           11 2           Non-Cash Adjustment
    ?C                   EndSL
     C                   Z-SUB     MT$AMT        MT$AMT                          ** Reverse Sign
      *
     C     MTTTYP        WhenEQ    04
     C     MTCSAJ        ANDEQ     'Y'
     C*    MTGLAC        ANDEQ     GDARRC
     C     MTGLAC        ANDNE     GDARRC
TEMP C                   Z-SUB     MT$AMT        MT$AMT                          ** Reverse Sign
     C                   If        MTCUST = 999999
     C                   ADD       MT$AMT        TPETTY           11 2           Total G/L Cash
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   Eval      Cust$AMT -= MT$AMT
     C                   Else
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   Eval      Cust$AMT -= MT$AMT
     C                   SUB       MT$AMT        TOTCAJ           11 2           Cash Adjustments
     C                   EndIf
     C                   Z-SUB     MT$AMT        MT$AMT                          ** Reverse Sign
     C                   MOVEL     MSG(5)        TYPE              8
      *
     C     MTTTYP        WhenEQ    04
     C     MTCSAJ        ANDEQ     'Y'
     C     MTGLAC        ANDNE     GDARRC
     C     MTCUST        ANDEQ     999999
     C                   ADD       MT$AMT        TPETTY           11 2           Petty Cash
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   Eval      Cust$AMT -= MT$AMT
      *
     C     MTTTYP        WhenEQ    5
     C                   GOTO      NXT
      *
     C     MTTTYP        WhenEQ    06
     C     MTGLAC        ANDEQ     GDCASH
     C                   MOVEL     MSG(4)        TYPE              8
     C                   ADD       MT$AMT        TOTNAR           11 2
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   Eval      Cust$AMT -= MT$AMT
      *
     C     MTTTYP        WhenEQ    7
     C                   GOTO      NXT
      *
     C     MTTTYP        WhenEQ    08
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   Eval      Cust$AMT -= MT$AMT
WJB  C     MTCHEK        IfEq      'CASH'
     C                   ADD       MT$AMT        TOTAR$1          11 2           Cash
WJB  C                   Else
WJB  C                   ADD       MT$AMT        TOTAR$2          11 2           Checks
WJB  C                   EndIf
     C                   MOVEL     MSG(1)        TYPE              8
      *
     C     MTTTYP        WhenEQ    09
     C                   ADD       MT$AMT        TOTDIS           11 2
     C                   MOVEL     MSG(3)        TYPE              8
      *
     C     MTTTYP        WhenEQ    10
EFD  C*    MTCRC#        ANDGT     0
WJB  C     MTSUFF        ANDNE     'OA'
     C                   MOVEL     MTCRCD        MTCHEK
     C                   MOVEL     MTCRC#        DESC1            21
     C                   MOVE      MTCRCE        DESC1            21
     C                   MOVEL     DESC1         DESC
     C                   ADD       MT$AMT        TOTCC            11 2
     C                   ADD       MT$AMT        TOTTCC           11 2
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   Eval      Cust$AMT -= MT$AMT
     C                   MOVEL     MSG(6)        TYPE              8
     C                   Z-SUB     MT$AMT        MT$AMT                          ** Reverse Sign
      *
     C     MTTTYP        WhenEQ    10
EFD  C*    MTCRC#        ANDGT     0
WJB  C     MTSUFF        ANDEQ     'OA'
     C                   ADD       MT$AMT        TTCCOA           11 2
     C                   ADD       MT$AMT        TOTTCC
     C                   ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C                   Eval      Cust$AMT -= MT$AMT
     C                   MOVEL     MSG(13)       TYPE              8
     C                   Z-SUB     MT$AMT        MT$AMT                          ** Reverse Sign
      *
EFD  C*    MTTTYP        WhenEQ    10
     C*    MTCRC#        ANDEQ     0
WJB  C*    MTSUFF        ANDNE     'OA'
     C*                  ADD       MT$AMT        TOTAR$           11 2           Cash & Checks
     C*                  ADD       MT$AMT        TOTDEP           11 2           Total G/L Cash
     C*                  Z-SUB     MT$AMT        MT$AMT
     C*                  MOVEL     MSG(1)        TYPE              8
      *
     C     MTTTYP        WhenEQ    12
     C                   MOVEL     MSG(7)        TYPE              8
     C                   ADD       MT$AMT        TOTDEP
     C                   Eval      Cust$AMT -= MT$AMT
     C                   Z-Sub     MT$AMT        MT$AMT
     C                   ADD       MT$AMT        TOTRET           11 2
      *
     C     MTTTYP        WhenEQ    14
     C     MT$AMT        ANDGT     0.00
     C                   MOVEL     MSG(12)       TYPE              8
     C                   ADD       MT$AMT        TOTRCC           11 2
      *
    ?C                   Other
     C                   GOTO      NXT
    ?C                   EndSL
      *
     C                   Eval      CMNAME = *Blanks
     C                   Eval      CNAME  = *Blanks
     C     MTCUST        CHAIN     FMCUST                             11
     C  N11CMSTAT        IFEQ      'D'
     C                   SETON                                        11
     C                   ENDIF
     C  N11              MOVEL     CMNAME        CNAME            23            SHORTEN NAME
     C                   If        MTCUST = 999999
     C                   Eval      CNAME  = 'Petty Cash'
     C                   EndIf
      *
     C                   ADD       1             FIRST
     C                   ADD       1             CNT
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
     C                   EXCEPT    DETL
     C                   Eval      DetCount += 1
      *
     C                   GOTO      NXT
      *
     C     END           TAG
EFD01C*WJB25             Z-SUB     TOTAR$        TOTAR$                         Cash & Checks
WJB25C                   Z-SUB     TOTAR$1       TOTAR$1                        Cash
WJB25C                   Z-SUB     TOTAR$2       TOTAR$2                        Checks
EFD01C                   Z-SUB     TOTCC         TOTCC
EFD01C                   Z-SUB     TOTTCC        TOTTCC
EFD01C                   Z-SUB     TTCCOA        TTCCOA
EFD01C                   Z-SUB     TOTDEP        TOTDEP                          Total G/L Cash
     C* WJB25            Eval      TTCHCK = TOTAR$ + TOTCAJ + TOTNAR + TPETTY    Total Cash / Checks
WJB25C                   Eval      TTCHCK =
WJB25C                             TOTAR$1 + TOTAR$2 + TOTCAJ + TOTNAR + TPETTY  Total Cash / Checks
     C                   Eval      TGLMPC = TOTDEP + TPETTY                      G/L Cash less P/C
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
     C                   EXCEPT    TLR

     C     TOTADJ        IFNE      0.00
     C   OF              ExSR      HDGTLR
     C                   EXCEPT    TLR01                                         TOTADJ  1
     C                   ENDIF

     C     TOTRCC        IFNE      0.00
     C   OF              ExSR      HDGTLR
     C                   EXCEPT    TLR02                                         TOTRCC  2
     C                   ENDIF

     C     TOTDIS        IFNE      0.00
     C   OF              ExSR      HDGTLR
     C                   EXCEPT    TLR03                                         TOTDIS  3
     C                   ENDIF

     C     TOTCC         IFNE      0.00
     C                   Eval      TCC = *On
     C   OF              ExSR      HDGTLR
     C                   EXCEPT    TLR04                                         TOTCC   4
     C                   ENDIF

WJB  C     TTCCOA        IFNE      0.00
WJB  C                   Eval      TCC = *On
WJB  C   OF              ExSR      HDGTLR
WJB  C                   EXCEPT    TLR05                                         TTCCOA  5
WJB  C                   ENDIF

WJB  C     TTCCRF        IFNE      0.00
WJB  C                   Eval      TCC = *On
WJB  C   OF              ExSR      HDGTLR
WJB  C                   EXCEPT    TLR06                                         TTCCRF  6
WJB  C                   ENDIF

WJB  C     TCC           IFEQ      *On
WJB  C                   EXCEPT    TLR07                                         TOTTCC  7
WJB  C                   ENDIF

WJB  C     TTCCRP        IFNE      0.00
WJB  C   OF              ExSR      HDGTLR
WJB  C                   EXCEPT    TLR07B                                        TTCCRP  7B
WJB  C                   ENDIF

     C*    TOTAR$        IFNE      0.00
     C*  OF              ExSR      HDGTLR
     C*                  EXCEPT    TLR08                                         TOTAR$  8
     C*                  ENDIF

     C     TOTAR$1       IFNE      0.00
     C   OF              ExSR      HDGTLR
     C                   EXCEPT    TLR08a                                        TOTAR$1 8a
     C                   ENDIF

     C     TOTAR$2       IFNE      0.00
     C   OF              ExSR      HDGTLR
     C                   EXCEPT    TLR08b                                        TOTAR$2 8b
     C                   ENDIF

     C     TOTCAJ        IFNE      0.00
     C   OF              ExSR      HDGTLR
     C                   EXCEPT    TLR09                                         TOTCAJ  9
     C                   ENDIF

     C     TOTNAR        IFNE      0.00
     C   OF              ExSR      HDGTLR
     C                   EXCEPT    TLR10                                         TOTNAR 10
     C                   ENDIF

     C     TPETTY        IFNE      0.00
     C   OF              ExSR      HDGTLR
     C                   EXCEPT    TLR15                                         TPETTY 15
     C   OF              ExSR      HDGTLR
     C                   ENDIF

     C     TTCHCK        IFNE      0.00
     C   OF              ExSR      HDGTLR
     C                   EXCEPT    TLR11                                         TOTNAR 11
     C                   ENDIF

     C     TOTWIR        IFNE      0.00
     C   OF              ExSR      HDGTLR
     C                   EXCEPT    TLR12                                         TOTNAR 12
     C                   ENDIF

     C     TOTRET        IFNE      0.00
     C   OF              ExSR      HDGTLR
     C                   EXCEPT    TLR13                                         TOTRET 13
     C                   ENDIF

     C     TOTDEP        IFNE      0.00
     C   OF              ExSR      HDGTLR
     C                   EXCEPT    TLR14                                         TOTDEP 14
     C                   EXCEPT    TLR16                                         TGLMPC 16
     C                   ENDIF

     C                   SETON                                        LR
      *
     C     HDGTLR        BEGSR
     C                   EXCEPT    HDG
     C                   EXCEPT    TLR
     C                   EndSR
      *
     OARR350    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           70 'Daily Cash Receipts Regi'
     O                                           74 'ster'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           50 'For Date:'
     O                       DAYDTE        Y     59
     O                                           70 'For User:'
     O                       USNAME             101
     O          E            HDG            1
     O                                            5 'Cust'
     O                                           40 '-Invoice-'
     O                                           57 '- Transaction -'
     O                                           69 'Check #/'
WJB  O*                                         106 'G/L'
WJB  O                                          104 'G/L'
WJB  O                                          108 'A'
     O                                          120 'Transaction'
     O          E            HDG            1
     O                                            6 'Number'
     O                                           17 'Name'
     O                                           34 '#'
     O                                           40 'Suf'
     O                                           48 'Date'
     O                                           55 'Type'
     O                                           70 'Cred Card'
     O                                           88 'Description'
     O* WJB                                     108 'Account'
WJB  O                                          106 'Account'
     O                                          108 'C'
     O                                          118 'Amount'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       DESC                98
     O                       MT$AMT        K    120
     O* WJB                  MTGLAC             108 '    -    '
WJB  O                       MTGLAC             106 '    -    '
WJB  O                       MTCSAJ             108
     O                       MTCHEK              71
     O                       TYPE                58
     O                       DAYDTE        Y     49
     O                       MTSUFF              40
     O                       MTINV#        Z     37
     O              N11      CNAME               30
     O               11                          24 'Inactive Customer'
     O                       MTCUST        Z      6
     O          E            CustTot        0
     O                                          105 'Total ==>'
     O                       Cust$AMT      K    120
     O          E            CustTot        2
     O                       Cust$AMT      K    120
     O          EF           TLR            2
     O                                           50 '_____________________'
     O                                           74 '________________________'
     O                                           98 '________________________'

     O          EF           TLR01          2
     O                                           60 'Non-Cash Adj:'
     O                       TOTADJ        JB    79

     O          EF           TLR02          2
     O                                           60 'Return Check Fees:'
     O                       TOTRCC        JB    79

     O          EF           TLR03          1
     O                                           60 'Discounts:'
     O                       TOTDIS        JB    79

     O          EF           TLR04          1
     O                                           60 'Credit Card:'
     O                       TOTCC         JB    79

WJB  O          EF           TLR05          1
WJB  O                                           60 'Credit Card O/A:'
WJB  O                       TTCCOA        JB    79

     O          EF           TLR06          1
     O                                           60 'Credit Card Refund:'
     O                       TTCCRF        JB    79

     O          EF           TLR07          2
     O                                           60 'Today Total Credit Card:'
     O                       TOTTCC        JB    79

     O          EF           TLR07B         2
     O                                           60 'C.C. Refund Previous:'
     O                       TTCCRP        JB    79

     O          EF           TLR08a         1
     O                                           60 'Cash:'
     O                       TOTAR$1       JB    79

     O          EF           TLR08b         1
     O                                           60 'Checks:'
     O                       TOTAR$2       JB    79

     O          EF           TLR09          1
     O                                           60 'Cash Adjustments:'
     O                       TOTCAJ        JB    79

     O          EF           TLR10          1
     O                                           60 'Non-A/R Cash:'
     O                       TOTNAR        JB    79

     O          EF           TLR15          1
     O                                           60 'Petty Cash Transfer:'
     O                       TPETTY        JB    79

     O          EF           TLR11          2
     O                                           60 'Total Cash / Checks:'
     O                       TTCHCK        JB    79

     O          EF           TLR12          1
     O                                           60 'Wire Transfers:'
     O                       TOTWIR        JB    79

     O          EF           TLR13          1
     O                                           60 'Returned Checks:'
     O                       TOTRET        JB    79

     O          EF           TLR14       1  1
     O                                           52 'Total G/L Cash For:'
     O                       DAYDTE        Y     61
     O                       TOTDEP        JB    79
     O                                           83 '**'

     O          EF           TLR16          1
     O                                           60 'G/L Cash Less P/C:'
     O                       TGLMPC        JB    79

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
