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
      *PROGRAM NAME-------- GLR300
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- JOURNAL ENTRY EDIT LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFGLWRK    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFGLCTL    UF   E           K DISK
     FGLR300    O    F  121        PRINTER OFLIND(*INOF)
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
     C     LCO           CHAIN     FGLCTL                             97
     C     LCO           CHAIN     FMCORG                             90
      *
     C                   EXCEPT    HDG
      *
     C                   MOVEL     *BLANKS       GWJEPR
     C                   Z-ADD     0             GWJENM
     C                   MOVEL     *BLANKS       GWJESF
     C     GLKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GWJEPR
     C                   KFLD                    GWJENM
     C                   KFLD                    GWJESF
     C     GLKEY         SETLL     FGLWRK
      *
     C     NXT           TAG
     C                   SETOFF                                           11    1220
     C     LCO           READE     FGLWRK                                 90
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
     C                   MOVEL     GWJEDS        JEDS             28
     C                   MOVEL     GWDDES        DDES             28
      *
      * 20 = JE OUT OF BALANCE
      *
     C     CNT           IFGT      1
     C     GWJENM        ANDNE     OLJENM
     C     GWJEPR        ORNE      OLJEPR
     C     GWJESF        ORNE      OLJESF
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
     C     GWPERD        IFEQ      99
     C                   SETON                                        77
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   SETOFF                                       1112
      *
     C                   MOVEL     GWJEPR        OLJEPR            2
     C                   Z-ADD     GWJENM        OLJENM            6 0
     C                   MOVEL     GWJESF        OLJESF            2
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
     C                   MOVEL     'Y'           GZOKP
     C                   ENDIF
      *
     C                   UPDATE    RGLCTL
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
     OGLR300    E            HDG            1 03
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
     O                                           71 'Journal Entry Edit List'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           21 '--- Journal Entry ---'
     O                                           31 'J.E.'
     O                                           53 'Acct'
     O                                           82 'Transaction'
     O                                          106 'Debit'
     O                                          120 'Credit'
     O          E            HDG            0
     O                                            9 'Number'
     O                                           20 'Date'
     O                                           37 'Description'
     O                                           53 'Per'
     O                                           62 'Account'
     O                                           82 'Description'
     O                                          106 'Amount'
     O                                          120 'Amount'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O               12      GW$AMT        JB   121
     O               11      GW$AMT        1B   106
     O                       DDES                93
     O                       GWGLAC              63 '    -    '
     O                       GWPERD              53
     O                       JEDS                50
     O                       GWJEDT        Y     21
     O                       GWJESF              12
     O                       GWJENM        Z      9
     O                       GWJEPR               2
     O          E            TL1            1
     O                                          106 '------------'
     O                                          120 '------------'
     O          EF           TL1            2
     O               20                          22 '**** Journal Entry Out'
     O               20                          38 'Of Balance ****'
     O                                           76 'Journal Entry Totals:'
     O                       OLJEPR              80
     O                       OLJENM        Z     87
     O                       OLJESF              90
     O                       DEBL1         1B   106
     O                       CREDL1        JB   121
     O          E            TLR         1
     O                                          106 '============'
     O                                          120 '============'
     O          E            TLR         1  2
     O               30                          24 '**** Journal Entries For'
     O               30                          48 'This Company Are Out Of'
     O               30                          61 'Balance ****'
     O                                           80 'Company Totals:'
     O                       LCO           Z     83
     O                       DEBLR         1B   106
     O                       CREDLR        JB   121
     O          E            TLR         1
     O               30                          45 '**** This Must Be Correc'
     O               30                          68 'ted Before J/E Can Be P'
     O               30                          78 'osted ****'
     O          E    77      TLR         1
     O               77                          33 '*** Warning - There are'
     O               77                          58 'Journal Entries On Repor'
     O               77                          81 't For Next Fiscal Year.'
     O          E    77      TLR         1
     O               77                          34 'This Is Not An Error'
     O               77                          59 'It Is Just A Warning'
