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
      *PROGRAM NAME-------- GLR330
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- JOURNAL ENTRY POST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
      *
     FFGLWRK    UF   E           K DISK
     FFGLCTL    UF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFGLDET    O  A E           K DISK
     FGLR330    O    F  132        PRINTER OFLIND(*INOF)
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
     C     LCO           CHAIN     FMCOMP                             97
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
     C                   READ      FGLWRK                                 90
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
      * CHECK FOR DEBIT OR CREDIT AMOUNT
      *
     C     GW$AMT        IFGT      0
     C                   ADD       GW$AMT        DEBLR            11 2
     C                   ENDIF
     C     GW$AMT        IFLT      0
     C                   ADD       GW$AMT        CREDLR           11 2
     C                   ENDIF
      *
     C                   EXSR      UGLDET
     C                   GOTO      NXT
      *
     C     END           TAG
      *
     C                   MOVEL     'N'           GZOKP
     C     LCO           CHAIN     FGLCTL                             90
     C                   UPDATE    RGLCTL
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *********
      * UGLDET
      *********
     C     UGLDET        BEGSR
     C                   Z-ADD     LCO           CONO              2 0
     C                   Z-ADD     GWACDT        TRNDAT            6 0
     C                   CALL      'GETAPER'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    TRNDAT            6 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     ACTPER        #P                2 0
     C     #P            IFEQ      99
     C                   MOVEL     '9999'        GTAPER
     C                   ELSE
     C                   MOVE      GWACDT        YY                2 0
     C                   MOVEL     YY            GTAPER
     C                   MOVE      #P            GTAPER
     C                   ENDIF
     C                   MOVEL     'A'           GTSTAT
     C                   Z-ADD     GWCOMP        GTCOMP
     C                   Z-ADD     GWGLAC        GTACCT
     C                   Z-ADD     GW$AMT        GTDOL$
     C                   Z-ADD     GWACDT        GTTDAT
     C                   MOVEL     'J/E'         GTSRCE
     C                   MOVEL     *BLANKS       GTPROD
     C                   MOVEL     GWJENM        GTJENM
     C                   Z-ADD     GWACDT        GTTDAT
     C                   MOVEL     GWJESF        GTJESF
     C                   MOVEL     GWJEDS        GTJEDS
     C                   MOVEL     GWJETP        GTDETT
     C                   MOVEL     *BLANKS       GTPOST
     C                   MOVEL     GWDDES        GTSRDS
     C                   Z-ADD     TIMOD         GTTIME
     C                   MOVEL     USERID        GTUSER
     C                   MOVEL     GWSHFR        GTSHFR
     C                   Z-ADD     TDATE         GTDTLA
     C     GTTDAT        MULT      10000.01      GTRVDT            6 0
     C                   MOVEL     GTRVDT        YR                2 0
     C     YR            IFGT      70
     C                   MOVEL     0             CENT              1 0
     C                   ELSE
     C                   MOVEL     1             CENT
     C                   ENDIF
     C                   MOVEL     CENT          GTCYMD
     C                   MOVE      GTRVDT        GTCYMD
     C                   WRITE     RGLDET
      *
     C                   MOVEL     'D'           GWSTAT
     C                   MOVEL     'Y'           GWPOST
     C                   UPDATE    RGLWRK
      *
     C                   ENDSR
      *
     OGLR330    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       MCNAME              77
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           72 '* J/E Not Posted List *'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           21 '--- Journal Entry ---'
     O                                           31 'J.E.'
     O                                           55 'Acct'
     O                                           85 'Transaction'
     O                                          106 'Debit'
     O                                          120 'Credit'
     O          E            HDG            1
     O                                            9 'Number'
     O                                           20 'Date'
     O                                           37 'Description'
     O                                           55 'Per'
     O                                           64 'Account'
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
     O               12      GW$AMT        JB   121
     O               11      GW$AMT        JB   107
     O                       GWJEPR               2
     O                       GWJENM        Z      9
     O                       GWJESF              12
     O                       GWJEDT        Y     21
     O                       GWJEDS              52
     O                       GWPERD              55
     O                       GWGLAC              65 '    -    '
     O                       GWDDES              97
     O          E            TL1            1
     O                                          106 '-----------'
     O                                          120 '-----------'
     O          EF           TL1            2
     O                                           22 '**** Journal Entry Out'
     O                                           38 'Of Balance ****'
     O                                           80 'Journal Entry Totals:'
     O                       OLJEPR              84
     O                       OLJENM        Z     91
     O                       OLJESF              94
     O                       DEBL1         JB   107
     O                       CREDL1        JB   121
     O          E            TLR         1
     O                                          106 '==========='
     O                                          120 '==========='
     O          E            TLR         1
     O               30                          24 '**** Journal Entries For'
     O               30                          48 'This Company Are Out Of'
     O               30                          61 'Balance ****'
     O                                           80 'Company Totals:'
     O                       LCO           Z     83
     O                       DEBLR         JB   107
     O                       CREDLR        JB   121
