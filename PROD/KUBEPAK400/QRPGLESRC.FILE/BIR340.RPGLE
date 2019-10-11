      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR340
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- DAILY INVOICE REGISTER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFARWRINV  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FBIR340    O    F  120        PRINTER OFLIND(*INOF)
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
      *
     D                UDS
     D  LCO                    1      2  0
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     1             FIRST             6 0
      *
     C     LCO           CHAIN(N)  FMCORG                             90
     C                   Z-ADD     0             CNT               6 0
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FARWRINV                               90
     C   90              GOTO      END
      *
     C     ATCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     ATSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     FIRST         IFNE      1
     C     ATTDAT        ANDNE     OTTDAT
     C                   EXCEPT    TL1
     C                   Z-ADD     1             CNT
     C                   ENDIF
     C                   Z-ADD     ATTDAT        OTTDAT            7 0
      *
     C     ATSHCU        CHAIN     FMCUST                             90
     C  N90              MOVEL     CMNAME        CUSNAM           23
      *
      * 01 = INVOICE  07 = LATE CHARGE
      *
     C     ATTTYP        IFEQ      01
     C     ATTTYP        OREQ      07
     C                   SETON                                        51
     C                   ENDIF
      *
      * COMBINE DISCOUNTS AND ADD TO DAY AND COMPANY TOTALS
      *
     C     ATDIS$        ADD       ATQDI$        DISAMT            7 2
     C     DISAMT        ADD       DAYDIS        DAYDIS            9 2
     C   51              ADD       ATDIS$        TOTDIS            9 2
     C  N51              ADD       ATDIS$        TDISCM            9 2
     C   51              ADD       ATQDI$        TOTQDI            9 2
     C  N51              ADD       ATQDI$        TQDICM            9 2
      *
      * COMBINE 4 TAXES AND ADD TO DAY AND COMPANY TOTALS
      *
     C                   Z-ADD     0             WORK1
     C                   Z-ADD     0             WORK2
      *
     C     ATAMT1        ADD       ATAMT2        WORK1             7 2
     C                   ADD       ATAMT3        WORK2             7 2
     C     WORK1         ADD       WORK2         TAXAMT            7 2
     C     TAXAMT        ADD       DAYTAX        DAYTAX            9 2
      *
     C   51ATAMT1        ADD       TOTTX1        TOTTX1            9 2
     C  N51ATAMT1        ADD       TTX1CM        TTX1CM            9 2
     C   51ATAMT2        ADD       TOTTX2        TOTTX2            9 2
     C  N51ATAMT2        ADD       TTX2CM        TTX2CM            9 2
     C   51ATAMT3        ADD       TOTTX3        TOTTX3            9 2
     C  N51ATAMT3        ADD       TTX3CM        TTX3CM            9 2
      *
      * ADD OTHER DETAIL AMOUNTS TO DAY TOTALS
      *
     C     ATMER$        ADD       DAYMER        DAYMER           11 2
     C     ATFRT$        ADD       DAYFRT        DAYFRT            9 2
     C     ATSPL$        ADD       DAYSPL        DAYSPL            9 2
     C     AT$AMT        ADD       DAYINV        DAYINV           11 2
      *
      * ADD ALL AMTS TO TOTALS FOR INVOICE OR CREDIT MEMO
      *
     C   51              ADD       ATMER$        TOTMER           11 2
     C  N51              ADD       ATMER$        TMERCM           11 2
     C   51              ADD       ATFRT$        TOTFRT            9 2
     C  N51              ADD       ATFRT$        TFRTCM            9 2
     C   51              ADD       ATSPL$        TOTSPL            9 2
     C  N51              ADD       ATSPL$        TSPLCM            9 2
     C   51              ADD       AT$AMT        TOTINV           11 2
     C  N51              ADD       AT$AMT        TINVCM           11 2
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO
      *
     C                   Z-ADD     ATTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TDAT              6 0
     C                   EXCEPT    DETL
     C                   ADD       1             FIRST
     C                   SETON                                        77
     C                   GOTO      NXT
      *
     C     END           TAG
     C   77              EXCEPT    TL1
     C   77              EXCEPT    TLR
     C  N77              EXCEPT    TLRN
     C                   SETON                                        LR
      *
     OBIR340    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                                          114 'Page:'
     O                       PAGE          1    120
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           70 'Daily Invoice Register'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           17 ' Inv     Ship To '
     O                                           26 'Customer'
     O                                           43 'A/R'
     O                                           54 'Invoice'
     O                                           64 'Merch.'
     O                                           75 'Disc.'
     O                                           86 'Freight'
     O                                           97 'Special'
     O                                          119 'Invoice'
     O          E            HDG            0
     O                                            6 'Number'
     O                                           44 'Cust #'
     O                                           52 'Date'
     O                                           64 'Amount'
     O                                           75 'Amount'
     O                                           86 'Charge'
     O                                           97 'Charge'
     O                                          108 'Taxes'
     O                                          118 'Total'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       AT$AMT        MB   120
     O                       TAXAMT        MB   109
     O                       ATSPL$        MB    98
     O                       ATFRT$        MB    87
     O                       DISAMT        MB    76
     O                       ATMER$        MB    65
     O                       ATINV#        ZB     6
     O*                        ATSUFF B   9
     O                       ATSHCU        ZB    13
     O                       CUSNAM         B    37
     O                       ATCUST        ZB    44
     O                       TDAT          Y     54
     O          E            TL1         1  3
     O                                           44 'Total For Date:'
     O                       DAYINV        MB   120
     O                       DAYTAX        MB   109
     O                       DAYSPL        MB    98
     O                       DAYFRT        MB    87
     O                       DAYDIS        MB    76
     O                       DAYMER        MB    65
     O                       TDAT          Y     54
     O          E            TLR            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                                          114 'Page:'
     O                       PAGE          1    120
     O          E            TLR            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           70 'Daily Invoice Register'
     O                       TIMOD              120 '  :  :  '
     O          E            TLR            3
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            TLR            1
     O                                           67 'C O M P A N Y'
     O                                           81 'T O T A L S'
     O          E            TLR            2
     O                       RGNAMC              75
     O          E            TLR            0
     O                                           49 'Invoices'
     O                                           97 'Credit Memos'
     O          E            TLR            2
     O                                           46 '________________________'
     O                                           70 '________________________'
     O                                           94 '________________________'
     O                                          106 '______________'
     O          E            TLR            2
     O                       TOTMER        KB    43
     O                                           71 'Merchandise'
     O                       TMERCM        KB    95
     O          E            TLR            2
     O                       TOTQDI        KB    43
     O                                           71 'Qty. Discount'
     O                       TQDICM        KB    95
     O          E            TLR            2
     O                       TOTDIS        KB    43
     O                                           71 'Trade Discount'
     O                       TDISCM        KB    95
     O          E            TLR            2
     O                       TOTFRT        KB    43
     O                                           71 'Freight'
     O                       TFRTCM        KB    95
     O          E            TLR            2
     O                       TOTSPL        KB    43
     O                                           71 'Special Charges'
     O                       TSPLCM        KB    95
     O          E            TLR            2
     O                                           71 'T A X E S'
     O          E            TLR            2
     O                       TOTTX1        KB    43
     O                                           71 'State'
     O                       TTX1CM        KB    95
     O          E            TLR            2
     O                       TOTTX2        KB    43
     O                                           71 'County'
     O                       TTX2CM        KB    95
     O          E            TLR            2
     O                       TOTTX3        KB    43
     O                                           71 'City'
     O                       TTX3CM        KB    95
     O          E            TLR            2
     O                       TOTINV        KB    43
     O                                           71 'Invoice Total'
     O                       TINVCM        KB    95
     O          E            TLRN           2
     O                                           48 'There Are No Records For'
     O                                           72 ' This Daily Invoice Regi'
     O                                           76 'ster'
      *
