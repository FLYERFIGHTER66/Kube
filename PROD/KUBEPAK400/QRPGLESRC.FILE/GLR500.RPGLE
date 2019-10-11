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
      *PROGRAM NAME-------- GLR500
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- LIST DETAIL BY ACCOUNTING PERIOD
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  8/04/00 EFD FOR J/E IF SOURCE EQUALS GLMASTER DESC PRINT J/E
      *              DESCRIPTION
     FFGLDETAC  IF   E           K DISK
     FFGLBAL    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FGLR500    O    F  120        PRINTER OFLIND(*INOF)
      *
     D GLP             S             11  2 DIM(13)
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
     D  LACTPb                 3      4  0
     D  LBCYMD                 5     11  0
     D  LECYMD                12     18  0
     D  LBDATE                19     24  0
     D  LEDATE                25     30  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
     D  LACTPe               172    173  0
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
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     1             CNT               6 0
      *
     C     LCO           CHAIN     FMCORG                             97
      *
     C                   EXCEPT    HDG
     C     NXT           TAG
     C                   SETOFF                                       1415
      *
     C                   READ      FGLDETAC                               90
     C   90              GOTO      END
      *
     C     GTCOMP        IFNE      LCO                                                      =
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     GTACCT        IFEQ      0                                                        =
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CURRENT PERIOD ONLY
      *
     C                   MOVE      GTAPER        PERIOD            2 0
     C     PERIOD        IFLT      LACTPb
     C     PERIOD        orGT      LACTPe
     C                   GOTO      NXT
     C                   ENDIF
      *
      * DO NOT PRINT 0 BALANCE DETAIL RECORDS
      *
     C     GTDOL$        IFEQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     CNT           IFGT      1
     C     GTACCT        ANDNE     OLACCT
     C                   EXCEPT    TL1
     C     DETCNT        IFEQ      0
     C                   EXCEPT    TL1ERR
     C                   ENDIF
     C                   Z-ADD     0             DETCNT
     C     BALKEY        CHAIN     FGLBAL                             91
     C  N91              EXSR      GTBAL
     C                   Z-ADD     LACTPb        X1                2 0
     C                   Z-ADD     GLP(X1)       WKPBAL           11 2303132
     C                   Z-ADD     0             WKPBAL               303132
      *
     C     BALKEY        CHAIN     FMGLCH                             97
     C                   EXCEPT    DETL1
     C                   Z-ADD     0             WKPOST           11 2
     C                   Z-ADD     BEGBAL        TOTAL            11 2
     C                   Z-ADD     0             TOTDEB           10 2
     C                   Z-ADD     0             TOTCRD           10 2
     C                   ENDIF
      *
     C     CNT           IFEQ      1
     C     BALKEY        KLIST
     C                   KFLD                    GTCOMP
     C                   KFLD                    GTACCT
     C     BALKEY        CHAIN     FGLBAL                             91
      *
      * 91 = NO GLBAL RECORD
      *
     C  N91              EXSR      GTBAL
     C                   Z-ADD     LACTPb        X1                2 0
     C                   Z-ADD     BEGBAL        TOTAL            11 2
     C                   Z-ADD     GLP(X1)       WKPBAL           11 2303132
     C                   Z-ADD     0             WKPBAL               303132
      *
     C     BALKEY        CHAIN     FMGLCH                             97
     C                   EXCEPT    DETL1
     C                   ENDIF
      *
      * PROCESS DETAIL RECORD
      *
     C                   EXSR      CURPR
     C   OF              DO
     C                   SETON                                        77
     C                   EXCEPT    HDG
     C                   EXCEPT    DETL1
     C                   SETOFF                                       OF77
     C                   ENDDO
      *
     C     GTDOL$        IFLT      0
     C                   SETON                                        15
     C                   ELSE
     C                   SETON                                        14
     C                   ENDIF
      **  CHECK IF J/E AND WHAT DESC TO PRINT
     C     GTSRCE        IFEQ      'J/E'
     C     GTSRDS        IFNE      GCDESC
     C                   SETON                                        67
     C                   ELSE
     C                   SETOFF                                       67
     C                   END                                                    SRDS><DESC
     C                   ELSE
     C                   SETOFF                                       67
     C                   END                                                    GTSRCE = J/E
     C                   EXCEPT    DETL
     C                   SETON                                        88
     C                   ADD       1             CNT
     C                   ADD       1             DETCNT            6 0
     C                   MOVEL     GTACCT        OLACCT            8 0
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C   88              EXCEPT    TL1
     C  N88              EXCEPT    TLRN
     C                   SETON                                        LR
      *
     C                   EXSR      ADJBL
      *
      ***********
      * GTBAL   *   GET BEGINNING BALANCE FOR ACCOUNT
      ***********
     C     GTBAL         BEGSR
     C                   Z-ADD     GLBALT        BEGBAL           11 2
     C                   Z-ADD     0             X                 2 0
     C     AGAIN         TAG
     C                   ADD       1             X
     C     X             IFLT      LACTPb
     C     BEGBAL        ADD       GLP(X)        BEGBAL
     C                   GOTO      AGAIN
     C                   ENDIF
     C                   ENDSR
      ***********
      * CURPR   *  PROCESS CURRENT PERIOD
      ***********
     C     CURPR         BEGSR
      *
     C                   EXSR      CALTO
     C     GTPOST        IFEQ      'Y'
     C                   ADD       GTDOL$        WKPOST
     C                   ENDIF
      *
     C                   ENDSR
      ***********
      * CALTO   *  ACCUMULATE TOTALS FOR DETAIL LINES
      ***********
     C     CALTO         BEGSR
      *
     C                   ADD       GTDOL$        TOTAL
     C     GTDOL$        IFGT      0
     C                   ADD       GTDOL$        TOTDEB
     C                   ADD       GTDOL$        TCODEB           11 2
     C                   ENDIF
      *
     C     GTDOL$        IFLT      0
     C                   ADD       GTDOL$        TOTCRD
     C                   ADD       GTDOL$        TCOCRD           11 2
     C                   ENDIF
      *
     C                   ENDSR
      ***********
      * ADJBL   *
      ***********
      *  ADJUST PERIOD POSTING BALANCE TO REFLECT ANY POSTED AMOUNTS NOT
      *  REPRESENTED WITH GENERAL LEDGER DETAIL TRANSACTIONS.
      *
     C     ADJBL         BEGSR
      *
     C     WKPBAL        SUB       WKPOST        WKPBAL               3031
      *
     C   30
     COR 31              ADD       WKPBAL        TOTAL
     C   30              ADD       WKPBAL        TCODEB
     C   30              ADD       WKPBAL        TOTDEB
     C   31              ADD       WKPBAL        TCOCRD
     C   31              ADD       WKPBAL        TOTCRD
      *
     C                   ENDSR
     O*
     OGLR500    E            HDG            1 03
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
     O                                           66 'General Ledger'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           50 'For Period:'
     O                       LACTPb              53
     O                                           54 '-'
     O                       LACTPe              56
     O                       LBDATE        Y     68
     O                                           71 '-'
     O                       LEDATE        Y     81
     O          E            HDG            1
     O                                            9 'Account#/'
     O                                           21 'Description'
     O                                           73 'Beginning'
     O                                           95 '- Current Period'
     O                                          106 'Postings -'
     O                                          120 'Closing'
     O          E            HDG            0
     O                                            6 'J.E.'
     O                                           26 'Explanation'
     O                                           47 'Source'
     O                                           56 'Date'
     O                                           72 'Balance'
     O                                           88 'Debits'
     O                                          103 'Credits'
     O                                          120 'Balance'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL1          1
     O                       GTACCT               9 '    -    '
     O                       GCDESC              40
     O               77                          52 '(Continued)'
     O                       BEGBAL        J     74
     O          E            DETL           1
     O                       GTJEPR               2
     O                       GTJENM        Z      9
     O                       GTJESF              12
     O               67      GTSRDS              43
     O              N67      GTJEDS              43
     O                       GTSRCE              47
     O                       GTTDAT        Y     56
     O                     15GTDOL$        J    104
     O                     14GTDOL$        1     88
     O          E            TL1ERR         1
     O                                           26 'Period Balance With No'
     O                                           45 ' G/L Detail Records'
     O                     30WKPBAL        1B    88
     O                     31WKPBAL        JB   104
     O          E            TL1            1
     O                                           88 '-------------'
     O                                          104 '-------------'
     O          E            TL1            2
     O                                           61 'Current Totals:'
     O                       TOTAL         JB   120
     O                       TOTCRD        JB   104
     O                       TOTDEB        1B    88
     O          E            TLRN           1
     O                                           55 '**** There Are No Transa'
     O                                           78 'ctions For The Report S'
     O                                           92 'elections ****'
