      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1997
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
      **PROGRAM NAME-------- SAR315
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **DESCRIPTION--------- TAXES BY TAX JURISDICTION LISTS
      **                     DATA FROM TAX JURISDICTIONS FTAXD FILE
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFTAXD     IF   E           K DISK
     FFMTAXF    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FSAR315    O    F  132        PRINTER OFLIND(*INOF)
      *
     D MTH             S              9    DIM(12) CTDATA PERRCD(1)             MONTH
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
     D                UDS
     D  LMONTH                 1      2  0
     D  LYEAR                  3      6  0
     D  LCO                    7      8  0
     D  LPRTR                100    109
     D  LFORM                110    113
     D  LCOPY                114    115  0
     D  LHOLD                116    119
     D  LSAVE                120    123
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVE      LMONTH        MM                2 0
      *
     C     LCO           CHAIN     FMCOMP                             97
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       901011
     C                   READ      FTAXD                                  90
     C   90              GOTO      END
      *
     C     TDYEAR        IFNE      LYEAR
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     TDMTH         IFNE      LMONTH
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     TDCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     TDTXJU        CHAIN     FMTAXF                             90
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
      *
      ******  ACCUMULATE TOTAL TAX DUE -
      *
     C                   SETOFF                                       78
     C                   ADD       TDAMT1        TOTTAX           10 2
     C                   ADD       TDAMT2        TOTTAX
     C                   ADD       TDAMT3        TOTTAX
      *
     C     TDMGRS        SUB       TDMRES        NONTAX            9 2
      *
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
     OSAR315    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       MCNAME              77
     O                                           90 'Company:'                  APR500
     O                       LCO                 93                             APR500
     O                       PAGE          1    120
     O                                          117 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           68 'Taxes By Jurisdiction'
     O          E            HDG            1
     O                                           50 'For:'
     O                       MTH(MM)             60
     O                       LYEAR               65
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                            4 'Tax'
     O                                           20 'Jurisdiction'
     O                                           46 'Monthly'
     O                                           62 'Non-Taxable'
     O                                           74 'Taxable'
     O                                           82 'Rate'
     O                                           94 'Tax Due'
     O                                          120 'Total Tax'
     O          E            HDG            1
     O                                            4 'Code'
     O                                           48 'Gross Sales'
     O                                           59 'Sales'
     O                                           73 'Sales'
     O                                          118 'Due'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       TDTXJU               4
     O                       TXJUNM              36
     O                       TDMGRS        K     49
     O                       NONTAX        K     62
     O                       TDMTX1        K     75
     O                       TDAMT1        K     95
     O                       TXPCT1        K     83
     O                                          102 'State:'
     O                       TDAMT1        K    120
     O          E            DETL           1
     O                       TDMTX2        K     75
     O                       TDAMT2        K     95
     O                       TXPCT2        K     83
     O                                          103 'County:'
     O          E            DETL           1
     O                       TDMTX3        K     75
     O                       TDAMT3        K     95
     O                       TXPCT3        K     83
     O                                          104 'Municip:'
     O          E            TLR            2
     O                       TOTTAX        KB   120
** MONTH NAMES
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
