      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1990
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
      **PROGRAM NAME-------- SAR310
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **DESCRIPTION--------- TAXES BY TAX JURISDICTION LISTS
      **                     DATA FROM TAX JURISDICTIONS.
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFMTAXF    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FSAR310    O    F  132        PRINTER OFLIND(*INOF)
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
      *****
      *****   ONE TIME CALC - TO GET TIME FOR REPORT AND   *****
      *****   TO GET NAME OF ORGANIZATION FOR REPORT       *****
      *****
     C   OF              SETON                                        OF
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVEL     '00'          MCCOMP
     C     CKEY          KLIST
     C                   KFLD                    MCCOMP
     C     CKEY          CHAIN(N)  FMCOMP                             90
     C                   SETON                                        8990
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       901011
     C                   READ      FMTAXF                                 90
     C   90              GOTO      END
     C     TXSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
      *
      ******  ACCUMULATE TOTAL TAX DUE -
      ******  COMPARE TO ZERO
      ******  WILL BE PRINTED ONLY IF GREATER THAN ZERO
      *
     C                   SETOFF                                       78
     C                   ADD       TXMMT1        TOTTAX           10 2
     C                   ADD       TXMMT2        TOTTAX
     C                   ADD       TXMMT3        TOTTAX
      *
     C     TOTTAX        COMP      0                                  78
     C  N78              Z-ADD     0             TOTTAX
      *
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
     OSAR310    E            HDG            1 03
     O                       PROGID              10
     O                       MCNAME              75
     O                                          114 'Page:'
     O                       PAGE          1    120
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           71 'Taxes By Jurisdiction'
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
     O                       TXTXJU               4
     O                       TXJUNM              36
     O                       TXMGRS        K     49
     O                       TXMRES        K     62
     O                       TXMTX1        K     75
     O                       TXMMT1        K     95
     O                       TXPCT1        K     83
     O                                          102 'State:'
     O          E            DETL           1
     O                       TXMTX2        K     75
     O                       TXMMT2        K     95
     O                       TXPCT2        K     83
     O                                          103 'County:'
     O          E            DETL           1
     O                       TXMTX3        K     75
     O                       TXMMT3        K     95
     O                       TXPCT3        K     83
     O                                          104 'Municip:'
     O          E            TLR            2
     O                       TOTTAX        KB   120
