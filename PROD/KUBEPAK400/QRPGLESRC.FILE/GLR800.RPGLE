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
      *PROGRAM NAME-------- GLR800
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- PRINT BUDGET WORKSHEET
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMGLCH    IF   E           K DISK
     FFGLBUD    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFGLBAL    IF   E           K DISK
     FGLR800    O    F  120        PRINTER OFLIND(*INOF)
      *
     D BAL             S             11  2 DIM(13)                              CURRENT BALANC
     D BUD             S             11  2 DIM(13)                              CURRENT BUDGETL
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
     D  LBUDG                  3      3
     D  LALL                   4      4
     D  LREV                   5      5
     D  LEXP                   6      6
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
     IRGLBAL
     I              GLT01                       BAL(1)
     I              GLT02                       BAL(2)
     I              GLT03                       BAL(3)
     I              GLT04                       BAL(4)
     I              GLT05                       BAL(5)
     I              GLT06                       BAL(6)
     I              GLT07                       BAL(7)
     I              GLT08                       BAL(8)
     I              GLT09                       BAL(9)
     I              GLT10                       BAL(10)
     I              GLT11                       BAL(11)
     I              GLT12                       BAL(12)
     I              GLT13                       BAL(13)
      *
     IRGLBUD
     I              GBC01                       BUD(1)
     I              GBC02                       BUD(2)
     I              GBC03                       BUD(3)
     I              GBC04                       BUD(4)
     I              GBC05                       BUD(5)
     I              GBC06                       BUD(6)
     I              GBC07                       BUD(7)
     I              GBC08                       BUD(8)
     I              GBC09                       BUD(9)
     I              GBC10                       BUD(10)
     I              GBC11                       BUD(11)
     I              GBC12                       BUD(12)
     I              GBC13                       BUD(13)
      *
     C                   EXCEPT    HDG
      *
     C     LCO           SETLL     FGLBUD
      *
     C     NXT           TAG
     C                   Z-ADD     0             BAL
     C                   Z-ADD     0             BUD
     C                   Z-ADD     1             X                 2 0
     C     LCO           READE     FGLBUD                                 90
     C   90              GOTO      END
      *
     C     GLKEY         KLIST
     C                   KFLD                    GBCOMP
     C                   KFLD                    GBGLNO
     C     GLKEY         CHAIN     FMGLCH                             97        GET ACCT DESC.
      *
      * DO NOT INCLUDE REVENUE ACCOUNTS
      *
     C  N60GCATYP        IFEQ      3
     C                   GOTO      NXT
     C                   ENDIF
      *
      * DO NOT INCLUDE EXPENSE ACCOUNTS
      *
     C  N65GCATYP        IFEQ      4
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     GLKEY         CHAIN     FGLBAL                             97        GET ACCT BALC.
      *
     C   10              GOTO      MTH
     C     X             DOUEQ     14
     C     X             IFEQ      1
     C                   SETON                                        77
     C                   ENDIF
     C   OF              SETON                                        77
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF77
     C                   EXCEPT    DETL
     C                   SETON                                        88
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   GOTO      NXT
      *
     C     MTH           TAG
     C     X             DOUEQ     13
     C     X             IFEQ      1
     C                   SETON                                        77
     C                   ENDIF
     C   OF              SETON                                        77
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF77
     C                   EXCEPT    DETL
     C                   SETON                                        88
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C  N88              EXCEPT    TLR
     C                   SETON                                        LR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN(N)  FMCORG                             92
      *
      * CHECK IF 12 MONTHS OR 13 PERIODS
      *
     C     LCO           CHAIN     FMAPER                             89
      *
     C     ACMPCN        IFEQ      'M'
     C                   SETON                                        10
     C                   ENDIF
      *
     C     LREV          IFEQ      'Y'
     C                   SETON                                        60
     C                   ENDIF
     C     LEXP          IFEQ      'Y'
     C                   SETON                                        65
     C                   ENDIF
      *
     C                   ENDSR
     OGLR800    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                                          116 'Page:'
     O                       PAGE          1    120
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           67 'Budget Worksheet'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           58 'Fiscal'
     O                                           75 'Current Year'
     O                                           93 'Current Year'
     O                                          115 'Next Year'
     O          E            HDG            0
     O                                            8 'Acct#'
     O                                           29 'Description'
     O                                           58 'Period'
     O                                           72 'Actual'
     O                                           91 'Budget'
     O                                          114 'Budget'
     O          E            HDG            1
     O                                           10 '----------'
     O                                           39 '------------------------'
     O                                           58 '------'
     O                                           75 '------------'
     O                                           93 '------------'
     O                                          120 '-----------------------'
     O          E            DETL           2
     O               77      GBGLNO         B     9 '    -    '
     O               77      GCDESC         B    45
     O                       X                   56
     O                                           57 '.'
     O                       BAL(X)        J     76
     O                       BUD(X)        J     94
     O                                          120 '_______________________'
     O          E            TLR            2
     O                                           62 '**** There Are No Record'
     O                                           83 's For Selections ****'
