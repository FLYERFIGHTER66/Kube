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
      *PROGRAM NAME-------- ARR535
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- MONTHLY CREDIT MEMO JOURNAL
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMTRANDT  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FARR535    O    F  121        PRINTER OFLIND(*INOF)
      *
     D MSG             S             30    DIM(2) CTDATA PERRCD(1)              MESSAGES
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
     D  LPROG                 29     36
     D  LNAME                 37     66
     D  LPRTR                100    109
     D  LFORM                110    113
     D  LCOPY                114    115  0
     D  LJOB                 116    116
     D  LHOLD                117    120
     D  LSAVE                121    124
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FMCORG                             97
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
     C                   Z-ADD     LEDATE        ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##MDY         PEREND            6 0
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
     C     MTTTYP        IFNE      05
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     MTTDAT        IFGT      LEDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     MTTDAT        ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##MDY         DAYDTE            6 0
      *
     C     MTTDAT        IFLT      LBDATE
     C     MTTDAT        ORGT      LEDATE
     C                   GOTO      NXT
     C                   ENDIF
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
     C     MTCUST        CHAIN     FMCUST                             90
      *
     C  N90CMSTAT        IFEQ      'D'
     C                   SETON                                        90
     C                   ENDIF
     C   90              MOVEL     MSG(1)        CMNAME
     C                   MOVEL     CMNAME        CNAME            23
      *
      * COMBINE DISCOUNTS AND ADD TO DAILY AND MONTHLY TOTALS
      *
     C                   Z-ADD     0             DISAMT            7 2
     C                   ADD       MTQDIS        DISAMT            7 2
     C                   ADD       MTDIS$        DISAMT
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
     C                   ADD       TAXAMT        DAYTAX            9 2
      *
     C                   ADD       MTAMT1        TOTTX1            9 2
     C                   ADD       MTAMT2        TOTTX2            9 2
     C                   ADD       MTAMT3        TOTTX3            9 2
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
     C*                    ADD  DAYMER    TOTMER 112
     C*                    ADD  DAYFRT    TOTFRT  92
     C*                    ADD  DAYSPL    TOTSPL  92
     C*                    ADD  DAYINV    TOTINV 112
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
      *
     C                   EXCEPT    DETL
     C                   SETON                                        88
     C                   ADD       1             FIRST
     C                   ADD       1             CNT
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
     OARR535    E            HDG            1 03
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
     O                                           69 'Monthly Credit Memo Jou'
     O                                           73 'rnal'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           55 'For Period:'
     O                       PERBEG        Y     64
     O                                           66 '-'
     O                       PEREND        Y     75
     O          E            HDG            1
     O                                            6 'CrM'
     O                                           15 'A/R'
     O                                           46 'Ship To'
     O                                           55 'Cr Memo'
     O                                           65 'Merch'
     O                                           76 'Disc'
     O                                           87 'Freight'
     O                                           98 'Special'
     O                                          119 'Invoice'
     O          E            HDG            1
     O                                            5 '#'
     O                                           16 'Cust #'
     O                                           26 'Customer'
     O                                           45 'Cust #'
     O                                           53 'Date'
     O                                           64 'Amt'
     O                                           76 'Amt'
     O                                           86 'Chrgs'
     O                                           97 'Chrgs'
     O                                          109 'Taxes'
     O                                          118 'Total'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       MT$AMT        K    120
     O                       TAXAMT        K    109
     O                       MTSPL$        K     98
     O                       MTFRT$        K     87
     O                       DISAMT        K     76
     O                       MTMER$        K     66
     O                       DAYDTE        Y     55
     O                       MTSHCU        Z     46
     O                       CNAME               39
     O                       MTCUST        Z     15
     O                       MTSUFF               8
     O                       MTINV#        Z      6
     O          E            TL1         1  1
     O                                           44 'Total For Date:'
     O                       DAYINV        KB   120
     O                       DAYTAX        KB   109
     O                       DAYSPL        KB    98
     O                       DAYFRT        KB    87
     O                       DAYDIS        KB    76
     O                       DAYMER        KB    66
     O                       DTEDAY        Y     55
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
     O                                           69 'Monthly Credit Memo Jou'
     O                                           73 'rnal'
     O                       TIMOD              120 '  :  :  '
     O          E            TLR            2
     O                                           56 'For Period:'
     O                       PERBEG        Y     65
     O                                           67 '-'
     O                       PEREND        Y     76
     O          E            TLR            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            TLR            1
     O                                           59 'C O M P A N Y'
     O                                           73 'T O T A L S'
     O          E            TLR            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            TLR            2
     O                                           55 'Merchandise:'
     O                       TOTMER        K     75
     O          E            TLR            2
     O                                           55 'Quantity Discount:'
     O                       TOTQDI        K     75
     O          E            TLR            2
     O                                           55 'Trade Discount:'
     O                       TOTDIS        K     75
     O          E            TLR            2
     O                                           55 'Freight:'
     O                       TOTFRT        K     75
     O          E            TLR            2
     O                                           55 'Special Charges:'
     O                       TOTSPL        K     75
     O          E            TLR            0
     O                                           65 'T A X E S'
     O          E            TLR            2
     O                                           65 '_________'
     O          E            TLR            2
     O                                           55 'State:'
     O                       TOTTX1        K     75
     O          E            TLR            2
     O                                           55 'County:'
     O                       TOTTX2        K     75
     O          E            TLR            3
     O                                           55 'City:'
     O                       TOTTX3        K     75
     O          E            TLR            2
     O                                           55 'Credit Memo Totals:'
     O                       TOTINV        K     75
     O          E            TLRN           1
     O                                           55 '**** There Are No Transa'
     O                                           78 'ctions For The Report S'
     O                                           92 'elections ****'
** MESSAGE
 ** Customer # Not On File **
