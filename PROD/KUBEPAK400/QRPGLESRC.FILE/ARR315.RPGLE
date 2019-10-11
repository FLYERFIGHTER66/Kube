      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ARR315
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- TAXES BY TAX JURISDICTION LISTS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/06/01 EFD CLEAR FIELDS IN FMTAXD IF NO HIT ON CHAIN.  EFD01
      *
      *
     FFMTAXF    IF   E           K DISK
     FFTAXD     IF   E           K DISK
     FFTAXDS    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FARR315    O    F  120        PRINTER OFLIND(*INOF)
      *
     D MTH             S              9    DIM(12) CTDATA PERRCD(1)
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
     D  LMONTH                 3      4  0
     D  LYEAR                  5      8  0
     D  LSUMM                  9      9
     D  LTAXJ                 10     12
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
     C     LCO           CHAIN(N)  FMCORG                             90
      *
     C                   MOVEL     LYEAR         YEAR              4
     C                   Z-ADD     LMONTH        X                 2 0
     C                   MOVEL     MTH(X)        MONTH             9
     C     MONTH         CAT       YEAR:1        PERIOD           14
     C                   EXCEPT    HDG
      *
     C     LSUMM         IFEQ      'D'
     C                   SETON                                        35
     C                   ENDIF
      *
     C     NXT           TAG
     C                   SETOFF                                       901011
     C                   READ      FMTAXF                                 90
     C   90              GOTO      END
      *
     C     TXSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   35TXTXJU        IFNE      LTAXJ
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     TXKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    TXTXJU
     C                   KFLD                    LYEAR
     C                   KFLD                    LMONTH
     C     TXKEY         CHAIN     FTAXD                              90
EFD01 * CLEAR FIELDS IF NO HIT ON FTAXD
EFD01C   90              DO
EFD01C                   Z-ADD     0             TDMGRS
EFD01C                   Z-ADD     0             TDMRES
EFD01C                   Z-ADD     0             TDMTX1
EFD01C                   Z-ADD     0             TDMTX2
EFD01C                   Z-ADD     0             TDMTX3
EFD01C                   Z-ADD     0             TDAMT1
EFD01C                   Z-ADD     0             TDAMT2
EFD01C                   Z-ADD     0             TDAMT3
EFD01C                   ENDDO                                                  90  DO
      *
      * ACCUMULATE TOTAL TAX DUE
      *
     C                   SETOFF                                       78
     C                   ADD       TDAMT1        TOTTAX           10 2
     C                   ADD       TDAMT2        TOTTAX
     C                   ADD       TDAMT3        TOTTAX
      *
     C     TOTTAX        IFEQ      0
     C                   Z-ADD     0             TOTTAX
     C                   ENDIF
      *
     C                   ADD       TOTTAX        TOTLR            10 2
     C                   ADD       TDMGRS        MGRSLR           10 2
     C                   ADD       TDMRES        MRESLR           10 2
     C                   ADD       TDMTX1        MTX1LR           10 2
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DETL
      *
     C  N35              GOTO      NXT
      *
     C                   EXCEPT    DHDG
     C     TXKEY         SETLL     FTAXDS                             91
     C     NXTD          TAG
     C     TXKEY         READE     FTAXDS                                 92
     C   92              GOTO      END
     C   OF              EXCEPT    HDG
     C   OF              EXCEPT    DHDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DDETL
      *
     C                   ADD       TSMTX1        TOTAL            10 2
     C                   ADD       TSAMT1        TAXLR            10 2
     C                   GOTO      NXTD
      *
     C     END           TAG
     C  N35              EXCEPT    TLR
     C   35              EXCEPT    TLR35
     C                   SETON                                        LR
      *
     OARR315    E            HDG            1 03
     O                       PROGID              10
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           70 'Taxes By Jurisdiction'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           55 'For:'
     O                       PERIOD              70
     O          E            HDG            1
     O                                            4 'Tax'
     O                                           46 'Monthly'
     O                                           64 'Non-Taxable'
     O                                           80 'Taxable'
     O          E            HDG            1
     O                                            4 'Code'
     O                                           20 'Jurisdiction'
     O                                           48 'Gross Sales'
     O                                           61 'Sales'
     O                                           79 'Sales'
     O                                          104 'Rate'
     O                                          120 'Tax Due'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       TXTXJU               4
     O                       TXJUNM              36
     O                       TDMGRS        J     48
     O                       TDMRES        J     64
     O                       TDMTX1        J     80
     O                                           95 'State:'
     O                       TXPCT1        K    105
     O                       TDAMT1        K    120
     O          E            DETL           1
     O                       TDMTX2        K     80
     O                       TDAMT2        K    120
     O                       TXPCT2        K    105
     O                                           95 'County:'
     O          E            DETL           1
     O                       TDMTX3        K     80
     O                       TDAMT3        K    120
     O                       TXPCT3        K    105
     O                                           95 'Municip:'
     O          E            DETL        1  2
     O                       TOTTAX        JB   120
     O                                          101 'Total Tax Due For:'
     O                       TXTXJU             105
     O          E            DHDG           2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DHDG           1
     O                                           42 'Inv #'
     O                                           60 'Taxable Amt'
     O                                           80 'Tax Billed'
     O          E            DHDG           2
     O                                           42 '_____'
     O                                           60 '___________'
     O                                           80 '__________'
     O          E            DDETL          1
     O                       TDINV#        Z     42
     O                       TSMTX1        J     60
     O                       TSAMT1        J     80
     O          E            TLR         2
     O                                           30 '** Report Totals:'
     O                       MGRSLR        J     48
     O                       MRESLR        J     64
     O                       MTX1LR        J     80
     O                       TOTLR         JB   120
     O          E            TLR35       2
     O                                           30 '** Report Totals:'
     O                       TOTAL         J     60
     O                       TAXLR         J     80
**
January
February
March
April
May
June
July
August
September
October
November
December
