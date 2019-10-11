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
      *PROGRAM NAME-------- GLR305
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- REVERSING JOURNAL ENTRY EDIT LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFGLREV    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFGLCTL    UF   E           K DISK
     FGLR305    O    F  121        PRINTER OFLIND(*INOF)
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
     C                   Z-ADD     1             CNT               6 0
      *
     C     LCO           CHAIN     FMCORG                             97
     C     LCO           CHAIN     FMAPER                             96
     C     ACMPCN        IFEQ      'M'
     C                   SETON                                        13
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
     C                   MOVEL     *BLANKS       GWJEPR
     C                   Z-ADD     0             GWJENM
     C                   MOVEL     *BLANKS       GWJESF
     C                   Z-ADD     1             GWSEQ#
     C     GLKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GWJEPR
     C                   KFLD                    GWJENM
     C                   KFLD                    GWJESF
     C                   KFLD                    GWSEQ#
     C     GLKEY         SETLL     FGLREV
      *
     C     NXT           TAG
     C                   SETOFF                                           11    1220
     C     LCO           READE     FGLREV                                 90
     C   90              GOTO      END
      *
     C     GWCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     GWSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     GWPOST        IFEQ      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     RESULT        IFNE      0
     C                   SETON                                        20
     C                   ENDIF
     C     RESULT        IFEQ      0
     C                   SETOFF                                       20
     C                   ENDIF
      *
      * 20 = JE OUT OF BALANCE
      *
     C     CNT           IFGT      1
     C     GWJENM        ANDNE     OLJENM
     C     GWJEPR        ORNE      OLJEPR
     C                   EXCEPT    TL1
     C                   Z-ADD     0             RESULT
     C                   Z-ADD     1             CNT
     C                   SETOFF                                       20
     C                   ENDIF
      *
      * CHECK FOR DEBIT OR CREDIT AMOUNT
      *
     C     GW$AMT        IFGT      0
     C                   SETON                                        11
     C                   ADD       GW$AMT        DEBL1            11 2
     C                   ADD       GW$AMT        DEBLR            11 2
     C                   ADD       GW$AMT        RESULT           11 2
     C                   ENDIF
     C     GW$AMT        IFLT      0
     C                   SETON                                        12
     C                   ADD       GW$AMT        CREDL1           11 2
     C                   ADD       GW$AMT        CREDLR           11 2
     C                   ADD       GW$AMT        RESULT           11 2
     C                   ENDIF
      *
     C                   MOVEL     GWDDES        DESC             24
     C     GWPERD        ADD       1             NPER              2 0
     C     NPER          IFLT      13
     C                   Z-ADD     NPER          TOPERD            2 0
     C                   GOTO      PEROK
     C                   ENDIF
      *
     C   13NPER          IFEQ      13
     C                   Z-ADD     01            TOPERD            2 0
     C                   ENDIF
     C  N13NPER          IFEQ      13
     C                   Z-ADD     NPER          TOPERD            2 0
     C                   ENDIF
      *
     C     PEROK         TAG
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   SETOFF                                       1112
      *
     C                   MOVEL     GWJEPR        OLJEPR            2
     C                   Z-ADD     GWJENM        OLJENM            6 0
      *
     C                   ADD       1             CNT
     C                   GOTO      NXT
      *
     C     END           TAG
     C     RESULT        IFNE      0
     C                   SETON                                        20
     C                   ENDIF
     C     RESULT        IFEQ      0
     C                   SETOFF                                       20
     C                   ENDIF
     C                   EXCEPT    TL1
      *
      * 30 = REPORT OUT OF BALANCE
      *
     C     LCO           CHAIN     FGLCTL                             90
     C     DEBLR         ADD       CREDLR        RESULT           11 2
     C     RESULT        IFNE      0
     C                   SETON                                        30
     C                   MOVEL     'N'           GZOKP
     C                   ENDIF
     C     RESULT        IFEQ      0
     C                   SETOFF                                       30
     C                   MOVEL     'Y'           GZOKRV
     C                   ENDIF
      *
     C                   UPDATE    RGLCTL
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
     OGLR305    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           67 'Reversing Journal Entry'
     O                                           77 'Edit List'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           21 '--- Journal Entry ---'
     O                                           31 'J.E.'
     O                                           58 'Period'
     O                                           85 'Transaction'
     O                                          106 'Debit'
     O                                          120 'Credit'
     O          E            HDG            1
     O                                            9 'Number'
     O                                           20 'Date'
     O                                           37 'Description'
     O                                           55 'Post'
     O                                           59 'Rev'
     O                                           69 'Account'
     O                                           85 'Description'
     O                                          106 'Amount'
     O                                          120 'Amount'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O               12      GW$AMT        LB   121
     O               11      GW$AMT        LB   109
     O                       DESC                97
     O                       GWGLAC              71 '    -    '
     O                       TOPERD              59
     O                       GWPERD              55
     O                       GWJEDS              52
     O                       GWACDT        Y     21
     O                       GWJESF              12
     O                       GWJENM        Z      9
     O                       GWJEPR               2
     O          E            TL1            1
     O                                          108 '-----------'
     O                                          120 '-----------'
     O          EF           TL1            2
     O               20                          22 '**** Journal Entry Out'
     O               20                          38 'Of Balance ****'
     O                                           76 'Journal Entry Totals:'
     O                       OLJEPR              80
     O                       OLJENM        Z     87
     O                       GWJESF              90
     O                       DEBL1         LB   109
     O                       CREDL1        LB   121
     O          E            TLR         1
     O                                          108 '==========='
     O                                          120 '==========='
     O          E            TLR         1  2
     O               30                          24 '**** Journal Entries For'
     O               30                          48 'This Company Are Out Of'
     O               30                          61 'Balance ****'
     O                                           80 'Company Totals:'
     O                       LCO           Z     83
     O                       DEBLR         LB   109
     O                       CREDLR        LB   121
     O          E            TLR         1
     O               30                          45 '**** This Must Be Correc'
     O               30                          68 'ted Before J/E Can Be P'
     O               30                          78 'osted ****'
