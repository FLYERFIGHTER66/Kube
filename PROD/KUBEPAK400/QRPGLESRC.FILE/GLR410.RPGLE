      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
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
      *PROGRAM NAME-------- GLR410
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- DAILY GENERAL JOURNAL LISTING
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFGLDETDT  IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FGLR410    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LDATE                  3      8  0
     D  LSRCE                  9     11
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
     C     LCO           CHAIN(N)  FMCORG                             92
     C                   EXCEPT    HDG
      *
     C                   Z-ADD     0             JENM              6 0
     C                   Z-ADD     0             ACCT              8 0
     C     GTKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    CDATE
     C                   KFLD                    JENM
     C                   KFLD                    LSRCE
     C                   KFLD                    ACCT
     C     GTKEY         SETLL     FGLDETDT
      *
     C     NXT           TAG
     C                   SETOFF                                       50
     C                   READ      FGLDETDT                               90
     C   90              GOTO      END
      *
     C     GTCYMD        IFGT      CDATE
     C                   GOTO      END
     C                   ENDIF
      *
     C   77GTSRCE        IFNE      LSRCE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   MOVEL     GTJEPR        NWJE              8
     C                   MOVE      GTJENM        NWJE
     C                   MOVEL     NWJE          NWJENM           10
     C                   MOVE      GTJESF        NWJENM
      *
     C     CNT           IFGT      1
     C     NWJENM        ANDNE     OLJENM
     C                   EXCEPT    TL1
     C                   Z-ADD     1             JE
     C                   Z-ADD     1             CNT
     C                   ENDIF
      *
     C     JE            IFEQ      1
     C                   SETON                                        50
     C                   ENDIF
      *
      * CHECK FOR DEBIT OR CREDIT AMOUNT
      *
     C                   SETOFF                                       1112
     C     GTDOL$        IFGT      0
     C                   ADD       GTDOL$        TOJDEB           10 2
     C                   ADD       GTDOL$        TOCDEB           10 2
     C                   SETON                                        11
     C                   ENDIF
     C     GTDOL$        IFLT      0
     C                   ADD       GTDOL$        TOJCRD           10 2
     C                   ADD       GTDOL$        TOCCRD           10 2
     C                   SETON                                        12
     C                   ENDIF
      *
      * CHAIN FOR G/L ACCOUNT DESCRIPTION
      *
     C     GLKEY         KLIST
     C                   KFLD                    GTCOMP
     C                   KFLD                    GTACCT
     C     GLKEY         CHAIN     FMGLCH                             94
     C                   MOVEL     GCDESC        DESC             24
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   SETON                                        88
     C                   ADD       1             CNT
     C                   ADD       1             JE
     C                   MOVEL     GTJEPR        OLJEPR            2
     C                   Z-ADD     GTJENM        OLJENU            6 0
     C                   MOVEL     GTJESF        OLJESF            2
     C                   MOVEL     GTJEPR        OLJE              8
     C                   MOVE      GTJENM        OLJE
     C                   MOVEL     OLJE          OLJENM           10
     C                   MOVE      GTJESF        OLJENM
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C     CNT           IFGT      1
     C                   EXCEPT    TL1
     C                   ENDIF
     C   88              EXCEPT    TLR
     C  N88              EXCEPT    TLRN
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
     C     LSRCE         IFGT      *BLANKS
     C                   SETON                                        77
     C                   ENDIF
      *
     C                   Z-ADD     LDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        CDATE             7 0
      *
     C                   Z-ADD     1             CNT               4 0
     C                   Z-ADD     1             JE                4 0
      *
     C                   ENDSR
      *
     OGLR410    E            HDG            1 03
     O                       PROGID              10
     O                                           25 'Requested by:'
     O                       USERID              36
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                                          115 'Page:'
     O                       PAGE          1    120
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           70 'Daily General Journal'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           67 'For Transactions Dated:'
     O                       LDATE         Y     76
     O               77                         116 'For Source:'
     O               77      LSRCE              120
     O          E            HDG            1
     O                                            8 'J.E.'
     O                                          105 '-------'
     O                                          120 'Amounts ------'
     O          E            HDG            0
     O                                            9 'Number'
     O                                           20 'Date'
     O                                           25 'SRC'
     O                                           37 'Explanation'
     O                                           66 'Account'
     O                                           80 'Description'
     O                                          105 'Debit'
     O                                          120 'Credit'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O               50      GTJEPR               2
     O               50      GTJENM        Z      9
     O               50      GTJESF              12
     O                       GTTDAT        Y     21
     O                       GTSRCE              25
     O                       GTJEDS              56
     O                       GTACCT              66 '    -    '
     O                       DESC                91
     O               11      GTDOL$        MB   106
     O               12      GTDOL$        MB   120
     O          E            TL1            1
     O                                          105 '------------'
     O                                          119 '------------'
     O          E            TL1            2
     O                                           75 'Journal Entry Totals:'
     O                       OLJEPR              78
     O                       OLJENU        Z     84
     O                       OLJESF              87
     O                       TOJDEB        JB   106
     O                       TOJCRD        JB   120
     O          E            TLR            1
     O                                          105 '============'
     O                                          119 '============'
     O          E            TLR            1
     O                                           75 'Company Totals:'
     O                       GTCOMP        Z     78
     O                       TOCDEB        JB   106
     O                       TOCCRD        JB   120
     O          E            TLRN           1
     O                                           45 '**** There Are No Transa'
     O                                           68 'ctions For This Date An'
     O                                           84 'd/Or Source ****'
