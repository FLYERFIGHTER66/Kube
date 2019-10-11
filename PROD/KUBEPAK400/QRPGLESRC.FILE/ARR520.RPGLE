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
      *PROGRAM NAME-------- ARR520
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- MONTHLY CASH RECEIPTS JOURNAL
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMTRANDT  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFGLDF     IF   E           K DISK
     FARR520    O    F  121        PRINTER OFLIND(*INOF)
      *
     D MSG             S              8    DIM(20) CTDATA PERRCD(1)
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
     D  LACTP                  3      4  0
     D  LBDATE                 5     11  0
     D  LEDATE                12     18  0
     D  LPRIOR                17     17
     D  LSLSM                 19     20
     D  LADJ                  24     24
     D  LONACT                25     25
     D  LARCST                26     31  0
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     LBDATE        ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##MDY         PERBEG            6 0
      *
     C                   Z-ADD     LEDATE        ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##MDY         PEREND            6 0
      *
     C                   MOVEL     '01'          GDTYPE
     C     GLDKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GDTYPE
     C     GLDKEY        CHAIN     FGLDF                              90
      *
     C     LCO           CHAIN     FMCORG                             97
      *
     C                   Z-ADD     1             FIRST             6 0
      *
     C     LACTP         IFGT      0
     C                   SETON                                        77
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FMTRANDT                               90
     C   90              GOTO      END
      *
     C     MTCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     MTTTYP        IFEQ      01
     C     MTTTYP        OREQ      05
     C     MTTTYP        OREQ      07
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   MOVEL     MTDESC        DESC             26
      *
     C                   Z-ADD     MTTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         DAYDTE            6 0
      *
     C                   MOVEL     MTTTYP        X                 2 0
      *
     C     MTTDAT        IFLT      LBDATE
     C     MTTDAT        ORGT      LEDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     FIRST         IFNE      1
     C     MTTDAT        ANDNE     OMDATE
     C*                    Z-ADD1         CNT
     C                   EXCEPT    TL1
     C                   ENDIF
      *
     C     MTTTYP        IFEQ      02
     C     MTTTYP        OREQ      03
     C     MTTTYP        OREQ      08
     C                   ADD       MT$AMT        TOTAR$           11 2
     C                   MOVEL     MSG(1)        TYPE              8
     C                   ENDIF
      *
     C     MTTTYP        IFEQ      10
     C                   MOVEL     MTCRCD        MTCHEK
     C                   MOVEL     MTCRC#        DESC1            21
     C                   MOVE      MTCRCE        DESC1
     C                   MOVEL     DESC1         DESC
     C                   ADD       MT$AMT        TOTCC            11 2
     C                   MOVEL     MSG(6)        TYPE              8
     C                   ENDIF
      *
     C     MTTTYP        IFEQ      04
     C     MTCSAJ        ANDEQ     'N'
     C     MTGLAC        ANDEQ     GDARRC
     C                   ADD       MT$AMT        TOTADJ           11 2
     C                   MOVEL     MSG(2)        TYPE              8
     C                   ENDIF
      *
     C     MTTTYP        IFEQ      04
     C     MTCSAJ        ANDEQ     'Y'
     C     MTGLAC        ANDEQ     GDARRC
     C                   ADD       MT$AMT        TOTCAJ           11 2
     C                   MOVEL     MSG(5)        TYPE              8
     C                   ENDIF
      *
MJT01C     MTTTYP        IFEQ      04
MJT01C     MTSSUF        IFEQ      'OA'
MJT01C                   MOVEL     MSG(7)        TYPE
MJT01C                   END
MJT01C     MTSSUF        IFEQ      'CM'
MJT01C                   MOVEL     MSG(8)        TYPE
MJT01C                   END
MJT01C                   ENDIF
      *
     C     MTTTYP        IFEQ      06
     C     MTGLAC        ANDEQ     GDCASH
     C                   MOVEL     MSG(4)        TYPE              8
     C                   ADD       MT$AMT        TOTNAR           11 2
     C                   ENDIF
      *
     C     MTTTYP        IFEQ      09
     C                   ADD       MT$AMT        TOTDIS           11 2
     C                   MOVEL     MSG(3)        TYPE              8
     C                   ENDIF
      *
     C     MTTTYP        IFNE      12
     C     MTTTYP        ANDNE     04
     C     MTTTYP        ANDNE     06
     C                   SUB       MT$AMT        TOTDEP           11 2
     C*                    ADD  MT$AMT    TOTDEP 112
     C                   ENDIF
      *
     C     MTTTYP        IFEQ      04
     C     MTCSAJ        ANDEQ     'Y'
     C     MTGLAC        ANDEQ     GDARRC
     C                   ADD       MT$AMT        TOTDEP           11 2
     C                   ENDIF
      *
     C     MTTTYP        IFEQ      06
     C     MTGLAC        ANDEQ     GDCASH
     C                   ADD       MT$AMT        TOTDEP           11 2
     C                   ENDIF
      *
     C     MTCUST        CHAIN     FMCUST                             11
      *
     C  N11CMSTAT        IFEQ      'D'
     C                   SETON                                        11
     C                   ENDIF
     C  N11              MOVEL     CMNAME        CNAME            23
      *
      * ADD OTHER DETAIL AMOUNTS TO DAILY AND MONTHLY TOTALS
      *
     C                   ADD       MT$AMT        DAYINV           11 2
      *
     C                   ADD       DAYINV        TOTINV           11 2
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
      *
     C                   EXCEPT    DETL
     C                   ADD       1             FIRST
     C                   Z-ADD     MTTDAT        OMDATE            7 0
     C                   Z-ADD     OMDATE        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD
     C                   PARM                    ##MDY
     C                   PARM                    ##ERR
     C                   Z-ADD     ##MDY         MDAT              6 0
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TL1
     C                   Z-SUB     TOTAR$        TOTAR$
     C                   Z-SUB     TOTCC         TOTCC
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
     OARR520    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           96 'Company:'
     O                       LCO                 99
     O                       PAGE          1    120
     O                                          116 'Page'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           69 'Monthly Cash Receipts Jo'
     O                                           74 'urnal'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O              N77                          72 'For Dates:'
     O              N77      PERBEG        Y     81
     O              N77                          83 '-'
     O              N77      PEREND        Y     92
     O               77                          69 'For Accounting Period:'
     O               77      LACTP               72
     O          E            HDG            1
     O                                            5 'Cust'
     O                                           40 '-Invoice-'
     O                                           57 '- Transaction -'
     O                                           69 'Check #/'
     O*                                  81 'Check'
     O                                          106 'G/L'
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
     O*                                  78 'Date'
     O                                          108 'Account'
     O                                          118 'Amount'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       MT$AMT        K    120
     O                       MTGLAC             108 '    -    '
     O*                        MTCKDTY   75
     O                       DESC                98
     O                       MTCHEK              71
     O                       TYPE                58
     O                       DAYDTE        Y     49
     O                       MTSUFF              40
     O                       MTINV#        Z     37
     O              N11      CNAME               30
     O               11                          28 '* Inactive Customer *'
     O                       MTCUST        Z      6
     O          E            TL1         1  2
     O                                           39 'Total For Date:'
     O                       MDAT          Y     49
     O                       DAYINV        KB   120
     O          E            TLR            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           96 'Company:'
     O                       LCO                 99
     O                       PAGE          1    120
     O                                          116 'Page'
     O          E            TLR            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           57 'Monthly Invoice Journal'
     O              N77                          68 'For Dates:'
     O              N77      LBDATE        Y     77
     O              N77                          79 '-'
     O              N77      LEDATE        Y     88
     O               77                          80 'For Accounting Period:'
     O               77      LACTP               83
     O                       TIMOD              120 '  :  :  '
     O          E            TLR            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            TLR            1
     O                                           63 'C O M P A N Y'
     O                                           77 'T O T A L S'
     O          E            TLR            1
     O                       RGNAMC              77
     O          E            TLR            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            TLR            1
     O                                           60 'Total Cash/Checks:'
     O                       TOTAR$        JB    79
     O          E            TLR            1
     O                                           60 'Total Credit Card:'
     O                       TOTCC         JB    79
     O          E            TLR            1
     O                                           60 'Non-Cash Adj:'
     O                       TOTADJ        JB    79
     O          E            TLR            1
     O                                           60 'Total Discounts:'
     O                       TOTDIS        JB    79
     O          E            TLR            1
     O                                           60 'Total Non-A/R Cash:'
     O                       TOTNAR        JB    79
     O          E            TLR            1
     O                                           60 'Cash Adjustments:'
     O                       TOTCAJ        JB    79
     O          E            TLR         1  1
     O                                           60 'Total Deposit:'
     O                       TOTDEP        JB    79
     O                                           83 '**'
** TYPE
Payment
Adjust
Discount
Non A/R
Cash Adj
Crd Card
O/A Pay
Apy C/M
