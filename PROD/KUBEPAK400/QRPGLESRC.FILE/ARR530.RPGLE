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
      *PROGRAM NAME-------- ARR530
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- MONTHLY INVOICE JOURNAL
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMTRANDT  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FARR530    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LSLSM                 20     21
     D  LSHFR                 22     24
     D  LFRT                  25     25
     D  LSPEC                 26     26
     D  LTAX                  27     27
     D  LARCST                28     33  0
     D  LSHIP                 34     39  0
     D  LINC                  89     89  0
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
     C                   Z-ADD     1             FIRST             6 0
     C                   Z-ADD     1             CNT               6 0
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
      * INCLUDE INVOICE TYPES
     C     LINC          IFEQ      1
     C                   SETON                                        20
     C                   ENDIF
     C     LINC          IFEQ      2
     C                   SETON                                        21
     C                   ENDIF
     C     LINC          IFEQ      3
     C                   SETON                                        19
     C                   ENDIF
      *
      * INCLUDE SPECIFIC SALESPERSON
     C     LSLSM         IFGT      *BLANKS
     C                   SETON                                        22
     C                   ENDIF
      * INCLUDE SPECIFIC SHIP FROM
     C     LSHFR         IFGT      *BLANKS
     C                   SETON                                        23
     C                   ENDIF
      * INCLUDE ONLY INVOICES WITH FREIGHT
     C     LFRT          IFEQ      'Y'
     C                   SETON                                        24
     C                   ENDIF
      * INCLUDE ONLY INVOICES WITH SPECIAL CHARGES
     C     LSPEC         IFEQ      'Y'
     C                   SETON                                        25
     C                   ENDIF
      * INCLUDE ONLY INVOICES WITH TAX CHARGES
     C     LTAX          IFEQ      'Y'
     C                   SETON                                        26
     C                   ENDIF
     C   24
     COR 25
     COR 26              SETON                                        30
      * INCLUDE ONLY SPECIFIC A/R CUSTOMER
     C     LARCST        IFGT      0
     C                   SETON                                        27
     C                   ENDIF
      * INCLUDE ONLY SPECIFIC SHIP TO CUSTOMER
     C     LSHIP         IFGT      0
     C                   SETON                                        28
     C                   ENDIF
      *
     C     LCO           CHAIN     FMCORG                             97
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
     C     MTTTYP        IFNE      1
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     MTTDAT        IFGT      LEDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     MTCUST        CHAIN     FMCUST                             11
     C     CMSTAT        IFEQ      'D'
     C                   SETON                                        11
     C                   ENDIF
     C  N11              MOVEL     CMNAME        CNAME            23            SHORTEN NAME
      *
     C                   Z-ADD     MTTDAT        ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##MDY         DAYDTE            6 0
      *
     C     FIRST         IFNE      1
     C     MTTDAT        ANDNE     OTTDAT
     C                   Z-ADD     OTTDAT        ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##MDY         DTEDAY            6 0
     C                   EXCEPT    TL1
     C                   Z-ADD     1             CNT
     C                   ENDIF
     C                   Z-ADD     MTTDAT        OTTDAT            7 0
      *
     C     MTTDAT        IFLT      LBDATE
     C     MTTDAT        ORGT      LEDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LINC          IFEQ      2
     C     MTPOS         ANDEQ     '   '
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LINC          IFEQ      3
     C     MTPOS         ANDEQ     'POS'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   22MTSLM1        IFNE      LSLSM
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   23MTSHFR        IFNE      LSHFR
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   24MTFRT$        IFEQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   25MTSPL$        IFEQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     0             TAXAMT
     C   26MTAMT1        ADD       MTAMT2        TAXAMT            7 2
     C   26              ADD       MTAMT3        TAXAMT
     C   26TAXAMT        IFEQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   27MTCUST        IFNE      LARCST
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   28MTSHCU        IFNE      LSHIP
     C                   GOTO      NXT
     C                   ENDIF
      *
      * COMBINE DISCOUNTS AND ADD TO DAILY AND MONTHLY TOTALS
      *
     C                   Z-ADD     0             DISAMT            7 2
     C     MTDIS$        ADD       MTQDIS        DISAMT            7 2
     C                   ADD       DISAMT        DAYDIS            9 2
     C                   ADD       MTDIS$        TOTDIS            9 2
     C                   ADD       MTQDIS        TOTQDI            9 2
      *
      * COMBINE 4 TAXES AND ADD TO DAILY AND MONTHLY TOTALS
      *
     C                   Z-ADD     0             WORK1             7 2
     C                   Z-ADD     0             WORK2             7 2
     C                   Z-ADD     0             TAXAMT            7 2
     C     MTAMT1        ADD       MTAMT2        WORK1             7 2
     C                   ADD       MTAMT3        WORK2             7 2
     C     WORK1         ADD       WORK2         TAXAMT            7 2
     C     TAXAMT        ADD       DAYTAX        DAYTAX            9 2
      *
     C     MTAMT1        ADD       TOTTX1        TOTTX1            9 2
     C     MTAMT2        ADD       TOTTX2        TOTTX2            9 2
     C     MTAMT3        ADD       TOTTX3        TOTTX3            9 2
      *
      * ADD OTHER DETAIL AMOUNTS TO DAILY AND MONTHLY TOTALS
      *
     C                   ADD       MTMER$        DAYMER           11 2
     C                   ADD       MTFRT$        DAYFRT            9 2
     C                   ADD       MTSPL$        DAYSPL            9 2
     C                   ADD       MT$AMT        DAYINV           11 2
      *
     C                   ADD       MTMER$        TOTMER           11 2
     C                   ADD       MTFRT$        TOTFRT            9 2
     C                   ADD       MTSPL$        TOTSPL            9 2
     C                   ADD       MT$AMT        TOTINV           11 2
      *
     C                   ADD       1             FIRST
     C                   ADD       1             CNT
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
     C                   EXCEPT    DETL
     C                   SETON                                        88
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   Z-ADD     OTTDAT        ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##MDY         DTEDAY            6 0
     C     CNT           IFGT      1
     C                   EXCEPT    TL1
     C                   ENDIF
     C   88              EXCEPT    TLR
     C  N88              EXCEPT    TLRN
     C                   SETON                                        LR
      *
     OARR530    E            HDG            1 03
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
     O                                           71 'Monthly Invoice Journal'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           55 'For Period:'
     O                       PERBEG        Y     64
     O                                           66 '-'
     O                       PEREND        Y     75
     O               22                         117 '* For Salesperson -'
     O               22      LSLSM              120
     O               28                          21 '* For Ship Customer -'
     O               28      LSHIP         Z     27
     O          E            HDG            1
     O               20N30                       66 'All Invoices'
     O               20 24                       66 'All Invoices With '
     O               20 24                       73 'Freight'
     O               20 25                       62 'All Invoices With '
     O               20 25                       77 'Special Charges'
     O               20 26                       71 'All Invoices With Tax'
     O               21N30                       66 'POS Invoices'
     O               21 24                       66 'POS Invoices With '
     O               21 24                       73 'Freight'
     O               21 25                       62 'POS Invoices With '
     O               21 25                       77 'Special Charges'
     O               21 26                       71 'POS Invoices With Tax'
     O               19N30                       68 'Regular Invoices'
     O               19 24                       68 'Regular Invoices With '
     O               19 24                       75 'Freight'
     O               19 25                       63 'Regular Invoices With '
     O               19 25                       79 'Special Charges'
     O               19 26                       72 'Regular Invoices With Ta'
     O               19 26                       73 'x'
     O               27                         114 '* For A/R Customer -'
     O               27      LARCST        Z    120
     O          E            HDG            1
     O               23                         117 '* For Ship From -'
     O               23      LSHFR              120
     O          E            HDG            1
     O                                            4 'Inv'
     O                                           13 'A/R'
     O                                           46 'Ship To'
     O                                           55 'Invoice'
     O                                           66 'Merch'
     O                                           75 'Disc'
     O                                           86 'Freight'
     O                                           97 'Special'
     O                                          119 'Invoice'
     O          E            HDG            1
     O                                            6 'Number'
     O                                           16 'Cust #'
     O                                           26 'Customer'
     O                                           45 'Cust #'
     O                                           54 'Date'
     O                                           66 'Amount'
     O                                           76 'Amount'
     O                                           86 'Charge'
     O                                           97 'Charge'
     O                                          106 'Taxes'
     O                                          118 'Total'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       MT$AMT        K    120
     O                       TAXAMT        K    106
     O                       MTSPL$        K     97
     O                       MTFRT$        K     86
     O                       DISAMT        K     77
     O                       MTMER$        K     67
     O                       DAYDTE        Y     55
     O                       MTSHCU        Z     46
     O              N11      CNAME               39
     O               11                          33 'Inactive Customer'
     O                       MTCUST        Z     15
     O                       MTSUFF               8
     O                       MTINV#        Z      6
     O          E            TL1         1  2
     O                                           44 'Total For Date:'
     O                       DAYINV        KB   120
     O                       DAYTAX        KB   106
     O                       DAYSPL        KB    97
     O                       DAYFRT        KB    86
     O                       DAYDIS        KB    77
     O                       DAYMER        KB    67
     O                       DTEDAY        Y     55
     O          E            TLR            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            TLR            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           71 'Monthly Invoice Journal'
     O                       TIMOD              120 '  :  :  '
     O          E            TLR            1
     O                                           55 'For Period:'
     O                       PERBEG        Y     64
     O                                           66 '-'
     O                       PEREND        Y     75
     O          E            TLR            1
     O                                           59 'C O M P A N Y'
     O                                           73 'T O T A L S'
     O          E            TLR            2
     O                                           50 '_____________________'
     O                                           74 '________________________'
     O                                           98 '________________________'
     O          E            TLR            2
     O                       TOTMER        K     74
     O                                           61 'Merchandise:'
     O          E            TLR            2
     O                                           61 'Quantity Discount:'
     O                       TOTQDI        K     74
     O          E            TLR            2
     O                                           61 'Trade Discount:'
     O                       TOTDIS        K     74
     O          E            TLR            2
     O                                           61 'Freight:'
     O                       TOTFRT        K     74
     O          E            TLR            2
     O                                           61 'Special Charges:'
     O                       TOTSPL        K     74
     O          E            TLR            0
     O                                           61 'T A X E S'
     O          E            TLR            2
     O                                           61 '_________'
     O          E            TLR            2
     O                                           61 'State:'
     O                       TOTTX1        K     74
     O          E            TLR            2
     O                                           61 'County:'
     O                       TOTTX2        K     74
     O          E            TLR            3
     O                                           61 'City:'
     O                       TOTTX3        K     74
     O          E            TLR            2
     O                       TOTINV        K     74
     O                                           61 'Invoice Totals:'
     O          E            TLRN           1
     O                                           55 '**** There Are No Transa'
     O                                           78 'ctions For The Report S'
     O                                           92 'elections ****'
