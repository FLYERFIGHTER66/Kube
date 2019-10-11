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
      *PROGRAM NAME-------- ARR351
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- DAILY CASH RECEIPTS REGISTER
      *                     BY CHECK NUMBER
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  8/22/02 EFD DO NOT SKIP TO NEW PAGE FOR TOTALS.  PER BILL
      * 11/21/02 EFD01 INCLUDE ADJUSTMENTS TO CASH DEPOSIT
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
      *
      *
     FFMTRANTY  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FARR354    O    F  120        PRINTER OFLIND(*INOF)
      *
     D MSG             S              8    DIM(20) CTDATA PERRCD(1)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
     D  PROGID                 1     10                                         PROGRAM NAME
     D  RLIBR                 81     90                                         RUN LIBRARY
     D  USERID               254    263                                         USER I.D.
     D  SLIBR                314    323                                         SOURCE LIBRARY
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
      *? Function Prototypes
     D/COPY QFunctDefn,$Upper

     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
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
      *
     C                   Z-ADD     LDATE         ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##MDY         DAYDTE            6 0
WJB  C                   MOVEL     MSG(1)        TYPE              8
      *
     C     LCO           CHAIN     FMCORG                             97
     C                   EXCEPT    HDG
      *
     C     LDATE         SETLL     FMTRANTY
     C     NXT           TAG
     C                   MOVEL     *BLANKS       DESC
     C     LDATE         READE     FMTRANTY                               90
     C   90              GOTO      END
WJB  C     -1            Mult      MT$AMT        MT$AMT
      *
     C     MTCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
WJB  C                   If        (MTTTYP=2 and
WJB  C                             %Trim($UPPER(MTCHEK)) = 'WIRE') or
WJB  C                             (MTTTYP=3 and
WJB  C                             %Trim($UPPER(MTCHEK)) = 'WIRE')
WJB  C                   Else
WJB  C                   GOTO      NXT
WJB  C                   Endif
      *
      * CHECK USER
     C     USER          IFGT      *BLANKS
     C     MTUSER        ANDNE     USER
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     MTDESC        IFGT      *BLANKS
     C                   MOVEL     MTDESC        DESC             26
     C                   ENDIF
      *
     C                   Select
     C                   When      MTTTYP = 2
     C                   Eval      TYPE = 'Payment'
     C                   ADD       MT$AMT        TOTWIR            9 2
     C                   When      MTTTYP = 3
     C                   Eval      TYPE = 'Adjust '
     C                   ADD       MT$AMT        TOTADJ            9 2
     C                   EndSl
      *
     C                   ADD       MT$AMT        TOTDEP            9 2
      *
     C     MTCUST        CHAIN     FMCUST                             11
     C  N11CMSTAT        IFEQ      'D'
     C                   SETON                                        11
     C                   ENDIF
     C  N11              MOVEL     CMNAME        CNAME            23            SHORTEN NAME
      *
     C                   ADD       1             FIRST
     C                   ADD       1             CNT
     C                   MOVEL     MTCHEK        OCHEK            10
     C                   Z-ADD     MTCUST        OCUST             6 0
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
     C                   EXCEPT    DETL
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
     OARR354    E            HDG            1 03
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
     O                                           70 'Daily Wire Receipts Regi'
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
     O                                          108 'Transaction'
     O          E            HDG            1
     O                                            6 'Number'
     O                                           17 'Name'
     O                                           34 '#'
     O                                           40 'Suf'
     O                                           48 'Date'
     O                                           55 'Type'
     O                                           70 'Cred Card'
     O                                           88 'Description'
     O                                          108 '   Amount  '
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       MT$AMT        K    108
     O                       DESC                98
     O                       MTCHEK              71
     O                       TYPE                58
     O                       DAYDTE        Y     49
     O                       MTSUFF              40
     O                       MTINV#        Z     37
     O              N11      CNAME               30
     O               11                          24 'Inactive Customer'
     O                       MTCUST        Z      6
     O          E            TLR         1  1
     O                                          120 '-----------'
     O                                           94 'Deposit Summary For:'
     O                       DAYDTE        Y    103
     O          E            TLR         1  0
     O                                           94 'Total Wire Type P:'
     O                                          107 '===========>'
     O                       TOTWIR        JB   120
     O          E            TLR         1  0
     O                                           94 'Total Wire Type A:'
     O                                          107 '===========>'
     O                       TOTADJ        JB   120
     O          E            TLR         1  0
     O                                           94 'Total Wire Deposit:'
     O                                          107 '===========>'
     O                       TOTDEP        JB   120
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
                               10
                               11
                               12
                               13
                               14
                               15
                               16
                               17
                               18
                               19
                               20
