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
      *PROGRAM NAME-------- GLR350
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- POST MONTHLY DETAIL TO G/L BALANCE FORWARD
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFGLDETAA  UF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFGLBAL    UF A E           K DISK
     FFGLDF     IF   E           K DISK
     FFGLCTL    UF   E           K DISK
     FGLR350    O    F  120        PRINTER OFLIND(*INOF)
     FGLR350E   O    F  120        PRINTER OFLIND(*INOA)
      *
      *
     D GLP             S             11  2 DIM(13)
     D GLN             S             11  2 DIM(13)
     D GLTPER          S             11  2 DIM(13)
     D GLLPER          S             11  2 DIM(13)
     D MSG             S             22    DIM(5) CTDATA PERRCD(1)
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
     D  LBCYMD                 5     11  0
     D  LECYMD                12     18  0
     D  LBDATE                19     24  0
     D  LEDATE                25     30  0
     D  CON                   31     43
     D                                     DIM(13)
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
     I              GLT01                       GLP(1)
     I              GLT02                       GLP(2)
     I              GLT03                       GLP(3)
     I              GLT04                       GLP(4)
     I              GLT05                       GLP(5)
     I              GLT06                       GLP(6)
     I              GLT07                       GLP(7)
     I              GLT08                       GLP(8)
     I              GLT09                       GLP(9)
     I              GLT10                       GLP(10)
     I              GLT11                       GLP(11)
     I              GLT12                       GLP(12)
     I              GLT13                       GLP(13)
     I              GLL01                       GLN(1)
     I              GLL02                       GLN(2)
     I              GLL03                       GLN(3)
     I              GLL04                       GLN(4)
     I              GLL05                       GLN(5)
     I              GLL06                       GLN(6)
     I              GLL07                       GLN(7)
     I              GLL08                       GLN(8)
     I              GLL09                       GLN(9)
     I              GLL10                       GLN(10)
     I              GLL11                       GLN(11)
     I              GLL12                       GLN(12)
     I              GLL13                       GLN(13)
      *
      * 99 ON = NO DEFAULT RECORD CANCEL POST
      *         CHECKED IN *INZSR
     C   99              GOTO      END
      *
     C                   Z-ADD     1             CNTL1             6 0
     C                   Z-ADD     1             CNTL2             6 0
     C                   MOVE      *BLANKS       POST              1
      *
     C     GLKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GLNO
      *
     C                   EXCEPT    HDGA
     C                   EXCEPT    HDGB
      *
     C                   SETOFF                                       OAOF
     C     DETKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    POST
     C     DETKEY        SETLL     FGLDETAA
      *
      ************************
      ** MAIN LINE CODE     **
      ************************
     C     NXT           TAG
     C                   SETOFF                                       111273
     C     LCO           READE     FGLDETAA                               90
     C   90              GOTO      END
      *
     C     GTPOST        IFEQ      'Y'
     C                   GOTO      END
     C                   ENDIF
      *
     C     GTAPER        IFEQ      9999
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   MOVE      GTAPER        PRTST             2 0
     C     PRTST         IFGT      LACTP
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   SETOFF                                       1112
     C     GTDOL$        IFGT      0
     C                   SETON                                        11
     C                   ELSE
     C                   SETON                                        12
     C                   ENDIF
      *
      * PERIOD CHANGE
      *
     C     GTAPER        IFNE      OAPER
     C     OAPER         ANDGT     0
     C                   EXCEPT    TL1
     C                   EXSR      UGLBAL
      *
     C                   Z-ADD     0             WKTOT
     C                   Z-ADD     0             OACCT
     C                   Z-ADD     GDINC$        GCGLNO
      *
     C     WKREV         ADD       WKEXP         INCTOT           12 2
     C                   Z-ADD     INCTOT        WKTOT            12 2
     C                   EXSR      UGLBAL
     C                   Z-ADD     0             WKREV            12 2
     C                   Z-ADD     0             WKEXP            12 2
     C                   Z-ADD     0             WKTOT            12 2
     C                   EXCEPT    TL2
     C                   MOVEL     'Y'           CON(PR)
     C                   Z-ADD     1             CNTL2
     C                   Z-ADD     1             CNTL1
     C                   ELSE
      *
      * ACCOUNT CHANGE
      *
     C     GTACCT        IFNE      OACCT
     C     OACCT         ANDGT     0
     C                   EXSR      UGLBAL
     C                   EXCEPT    TL1
     C                   Z-ADD     0             WKTOT
     C                   Z-ADD     0             OACCT
     C                   Z-ADD     1             CNTL1
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      GTAPER        PR                2 0
     C     OACCT         IFLE      0
     C                   EXSR      GETGL
     C                   END
      *
      * 73 = ERROR
      *
     C  N73              GOTO      NOERR
     C                   SETON                                        72
     C     GTDOL$        IFGT      0
     C                   ADD       GTDOL$        ERRDBT           12 2
     C                   ENDIF
     C     GTDOL$        IFLT      0
     C                   ADD       GTDOL$        ERRCRD           12 2
     C                   ENDIF
     C   OF              DO
     C                   EXCEPT    HDGA
     C                   ENDDO
     C                   EXCEPT    DETLA
     C                   GOTO      NXT
     C     NOERR         TAG
      * 77 = HAVE RECORDS TO POST
      *
     C                   SETON                                        77
      *
     C                   MOVEL     GTSRDS        DESC             11
     C   OF              DO
     C                   EXCEPT    HDGB
     C                   ENDDO
     C                   EXCEPT    DETL
     C                   ADD       1             CNTL1
     C                   ADD       1             CNTL2
     C                   Z-ADD     GTACCT        OACCT             8 0
     C                   Z-ADD     GTAPER        OAPER             4 0
     C                   ADD       GTDOL$        WKTOT
      *
     C                   MOVEL     'Y'           GTPOST
     C                   Z-ADD     TDATE         GTDTLA
     C                   Z-ADD     TIMOD         GTTIME
     C                   MOVEL     USERID        GTUSER
     C   77              UPDATE    RGLDET
      *
     C                   EXSR      ACTOT
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C  N99              DO
     C   72              EXCEPT    TLRA
     C  N72              EXCEPT    TLRNO
     C   77              EXSR      UGLBAL
     C                   Z-ADD     GDINC$        GCGLNO
     C     WKREV         ADD       WKEXP         INCTOT           12 2
     C                   Z-ADD     INCTOT        WKTOT
     C   77              EXSR      UGLBAL
     C                   EXCEPT    TL1
     C                   EXCEPT    TL2
     C     PR            IFGT      0
     C                   MOVEL     'Y'           CON(PR)
     C                   END
      *
     C     LCO           CHAIN     FGLCTL                             90
     C                   Z-ADD     TDATE         GZPOST
     C                   UPDATE    RGLCTL
     C                   EXCEPT    TLR
     C                   ENDDO                                                  N99 DO
     C                   SETON                                        LR
      *
      **********
      * ACTOT  *
      **********
      *
      * SUBROUTINE ACTOT ACCUMULATES TOTAL DEBIT/CREDIT AMOUNTS
      * ACCUMULATES THE P/L INCOME AFFECT OF REVENUE AND EXPENSES
      *
     C     ACTOT         BEGSR
      * DEBITS
     C     GTDOL$        IFGT      0
     C                   ADD       GTDOL$        TOTL1D           12 2
     C                   ADD       GTDOL$        TOTL2D           12 2
     C                   ADD       GTDOL$        TOTLRD           12 2
     C                   ENDIF
      * CREDITS
     C     GTDOL$        IFLT      0
     C                   ADD       GTDOL$        TOTL1C           12 2
     C                   ADD       GTDOL$        TOTL2C           12 2
     C                   ADD       GTDOL$        TOTLRC           12 2
     C                   ENDIF
      * NET TOTALS
     C                   ADD       GTDOL$        TOTL1            12 2
     C                   ADD       GTDOL$        TOTL2            12 2
     C                   ADD       GTDOL$        TOTLR            12 2
     C   31              ADD       GTDOL$        WKREV
     C   32              ADD       GTDOL$        WKEXP
     C                   ENDSR
      *
      **********
      * GETGL  *
      **********
      *
     C     GETGL         BEGSR
      *
     C                   SETOFF                                       707173
     C                   SETOFF                                       3132
      *
      *  VALIDATE ACCOUNT NUMBER AND TYPE OF ACCOUNT
      *
     C                   Z-ADD     GTACCT        GLNO              8 0
     C     GLKEY         CHAIN     FMGLCH                             20
      *
     C   20              MOVE      MSG(1)        ERR              22
     C   20              SETON                                        73
     C   20              GOTO      ENDGET
      *
     C     GCSTAT        IFEQ      'D'
     C                   SETON                                        73
     C                   MOVE      MSG(2)        ERR
     C                   GOTO      ENDGET
     C                   ENDIF
      * REVENUE
     C     GCATYP        IFEQ      3
     C                   SETON                                        31
     C                   ENDIF
      * EXPENSE
     C     GCATYP        IFEQ      4
     C                   SETON                                        32
     C                   ENDIF
      *
     C     ENDGET        ENDSR
      *
      ***********
      * UGLBAL  *
      ***********
      *
     C     UGLBAL        BEGSR
     C                   Z-ADD     GCGLNO        GLNO
     C     GLKEY         CHAIN     FGLBAL                             24
     C   24              GOTO      NEWREC
      *
      * UPDATE EXISTING RECORD IN GLBAL
      *
     C                   ADD       WKTOT         GLP(PR)
     C                   Z-ADD     TDATE         GLDTLA
     C                   Z-ADD     TIMOD         GLTIME
     C                   MOVEL     USERID        GLUSER
     C                   UPDATE    RGLBAL
     C                   GOTO      EGLBAL
      *
      * ADD RECORD TO GLBAL
      *
     C     NEWREC        TAG
     C                   Z-ADD     0             GLP
     C                   Z-ADD     0             GLN
     C                   MOVEL     'A'           GLSTAT
     C                   Z-ADD     LCO           GLCOMP
     C                   Z-ADD     GCGLNO        GLGLNO
     C                   Z-ADD     0             GLBALT
     C                   Z-ADD     0             GLBALL
     C                   Z-ADD     0             GLBUDT
     C                   Z-ADD     0             GLBUDL
     C                   Z-ADD     WKTOT         GLP(PR)
     C                   Z-ADD     TDATE         GLDTLA
     C                   Z-ADD     TIMOD         GLTIME
     C                   MOVEL     USERID        GLUSER
     C                   WRITE     RGLBAL
      *
     C     EGLBAL        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVE      *BLANKS       CON
      *
     C     LCO           CHAIN     FMCORG                             97
      *
      * GET PROFIT/LOSS ACCOUNT
      *
     C                   MOVEL     '01'          GDTYPE
     C     DEFKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GDTYPE
     C     DEFKEY        CHAIN     FGLDF                              99
     C  N99GDINC$        IFLE      0
     C                   SETON                                        99
     C                   END
     C   99              DO
     C                   EXCEPT    HDGA
     C                   EXCEPT    ERR99
     C                   ENDDO
     C                   ENDSR
      *
     OGLR350E   E            HDGA           1 03
     O                                            7 'GLR350E'
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                                          115 'Page:'
     O                       PAGE1         1    120
     O          E            HDGA           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           70 'G/L Detail Not Posted'
     O                       TIMOD              120 '  :  :  '
     O          E            HDGA           2
     O                                           52 'For Period:'
     O                       LACTP               55
     O                       LBDATE        Y     66
     O                                           69 '-'
     O                       LEDATE        Y     79
     O          E            HDGA           1
     O                                           11 'Account'
     O                                           16 'Typ'
     O                                           21 'Src'
     O                                           27 'J.E.'
     O          E            HDGA           0
     O                                            2 'Co'
     O                                           10 'Number'
     O                                           21 'Ref'
     O                                           26 'No.'
     O                                           35 'Date'
     O                                           62 'J.E. Description'
     O                                           81 'Debit'
     O                                           95 'Credit'
     O                                          113 'Explanation'
     O          E            HDGA           2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETLA          1
     O                       LCO                  2
     O                       GTACCT              12 '    -    '
     O                       GTDETT              15
     O                       GTSRCE              21
     O                       GTJENM        Z     28
     O                       GTTDAT        Y     37
     O                       GTJEDS              68
     O                  11   GTDOL$        J     82
     O                  12   GTDOL$        J     96
     O                       ERR                120
     O          E            TLRNO       2  1
     O                                           70 '**** No Unposted Records'
     O                                           75 '****'
     O          E            ERR99       1  1
     O                                           24 '**** There is No G/l Def'
     O                                           46 'ault Retained Earnings'
     O                                           70 'Account Number for this'
     O                                           94 'Company. Post Cancelled'
     O                                           99 '****'
     O          E            TLRA        2  1
     O                       ERRCRD        J     96
     O                       ERRDBT        J     82
     O                                           66 'Unposted Totals:'
     OGLR350    E            HDGB           1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDGB           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           68 'G/L Detail Posted'
     O                       TIMOD              120 '  :  :  '
     O          E            HDGB           2
     O                                           52 'For Period:'
     O                       LACTP               55
     O                       LBDATE        Y     66
     O                                           69 '-'
     O                       LEDATE        Y     79
     O          E            HDGB           1
     O                                           13 'Src'
     O          E            HDGB           0
     O                                            9 'Account'
     O                                           13 'Ref'
     O                                           23 '- JE # -'
     O                                           34 'Date'
     O                                           52 'Description'
     O                                           91 'Debit'
     O                                          105 'Credit'
     O                                          120 'Net Amount'
     O          E            HDGB           2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       GTACCT               9 '    -    '
     O                       GTSRCE              13
     O                       GTJEPR              16
     O                       GTJENM        Z     23
     O                       GTJESF              26
     O                       GTTDAT        Y     35
     O                       GTJEDS              66
     O                       DESC                78
     O                  11   GTDOL$        J     92
     O                  12   GTDOL$        J    106
     O          E            TL1         1  2
     O                       TOTL1         JB   120
     O                       TOTL1C        JB   106
     O                       TOTL1D        JB    92
     O                       OACCT               75 '    -    '
     O                                           65 'Total For Account:'
     O          E            TL2         1  1
     O                       TOTL2         JB   120
     O                       TOTL2C        JB   106
     O                       TOTL2D        JB    92
     O                       PR                  68
     O                                           65 'Total Posted For Period:'
     O          E            TL2         1  2
     O                       GDINC$               9 '    -    '
     O                                           65 'Profit/Loss Posted:'
     O                       PR                  68
     O                       INCTOT        J    120
     O          E            TLR         1  1
     O                                           51 'Totals Posted to Balance'
     O                                           65 'Forward File:'
     O                       TOTLRC        JB   106
     O                       TOTLRD        JB    92
** MESSAGES
Invalid Account Number
Account Number Deleted
