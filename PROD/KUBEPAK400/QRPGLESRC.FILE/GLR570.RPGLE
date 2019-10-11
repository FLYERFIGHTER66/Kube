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
      *PROGRAM NAME-------- GLR570
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- GENERAL LEDGER TRIAL BALANCE BY ACCOUNT.
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMGLCHTP  IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFGLBAL    IF   E           K DISK
     FGLR570    O    F  132        PRINTER OFLIND(*INOF)
      *
     D CR              S             11  2 DIM(13)
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
     D  LACTPb                 3      4  0                                      Beggining Period
     D  LBEGDT                 5     10  0                                      GLR360
     D  LENDDT                11     16  0                                      GLR360
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
     D  LACTPe               172    173  0                                      Ending Period
     D  Libraries            174    273                                         Ending Period

     D                 DS
     D  Libs                        100
     D  Lib                          10    DIM(10) OVERLAY(Libs)
      *
     IRGLBAL
      *
     I              GLT01                       CR(1)
     I              GLT02                       CR(2)
     I              GLT03                       CR(3)
     I              GLT04                       CR(4)
     I              GLT05                       CR(5)
     I              GLT06                       CR(6)
     I              GLT07                       CR(7)
     I              GLT08                       CR(8)
     I              GLT09                       CR(9)
     I              GLT10                       CR(10)
     I              GLT11                       CR(11)
     I              GLT12                       CR(12)
     I              GLT13                       CR(13)
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Eval      Libs = Libraries
     C                   Z-ADD     *Zero         W                 2 0
     C                   Z-ADD     *Zero         X                 2 0
     C                   Z-ADD     LACTPb        Y                 2 0
     C                   Z-ADD     LACTPe        Z                 2 0
     C                   Z-ADD     1             FIRST             5 0
      *
     C     LCO           CHAIN     FMCORG                             88
     C                   EXCEPT    HDG
      *
     C     LCO           SETLL     FMGLCHTP
      *
     C     NXT           TAG
     C                   SETOFF                                       111213
     C                   SETOFF                                       145152
     C                   SETOFF                                       525354
     C     LCO           READE     FMGLCHTP                               90
     C   90              GOTO      ENDP
      *
     C     GCSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     FIRST         IFGT      1
     C     GCATYP        ANDNE     OTYPE
     C                   EXSR      GETTYP
     C                   EXCEPT    TL1
     C                   SETOFF                                       40
     C   52              EXCEPT    TL2
     C                   ENDIF
      *
      * CALCULATE BALANCE AMOUNTS FOR EACH ACCOUNT
      *
     C                   Z-ADD     1             X                 2 0
     C     KEYGL         KLIST
     C                   KFLD                    GCCOMP
     C                   KFLD                    GCGLNO
     C     KEYGL         CHAIN     FGLBAL                             97        GET $ AMOUNTS
     C   97              GOTO      END
     C     ACCUM         TAG
     C*                  ADD       CR(X)         YTDC             11 2          YTD CURRENT
     C                   ADD       CR(X)         YTDC             11 2          YTD CURRENT
     C*    X             IFLT      Y
     C     X             IFLT      Z
     C                   ADD       1             X
     C                   GOTO      ACCUM
     C                   ENDIF
     C     YTDC          ADD       GLBALT        CURBAL           11 2          CURRENT BALANCE
     C     Y             Do        Z             W
     C                   ADD       CR(W)         CRY              11 2
     C                   EndDo
     C     END           TAG
      *
      * DETERMINE TYPE OF ACCOUNT
      *
     C     GCATYP        IFEQ      1
     C     GCATYP        OREQ      2
     C                   SETON                                            40
     C                   ENDIF
     C     GCATYP        IFEQ      3
     C     GCATYP        OREQ      4
     C                   SETON                                            42
     C                   ENDIF
      *
      * TOTAL TYPE
      *
     C  N13
     CANN14              ADD       GLBALT        BALL1            11 2                      BAL
     C     Y             Do        Z             W
     C*                  ADD       CR(Y)         CURL1            11 2                      L
     C                   ADD       CR(W)         CURL1            11 2                      L
     C                   EndDo
     C                   ADD       YTDC          YTDL1            11 2                      L
     C                   ADD       CURBAL        TOTL1            11 2                      L
      *
      * TOTAL ASSETS - LIABILITIES
      *
     C   40              ADD       GLBALT        ALBAL            11 2          TOTAL PRIOR BAL
     C     Y             Do        Z             W
     C*  40              ADD       CR(Y)         ALCUR            11 2          TOTAL BAL
     C   40              ADD       CR(W)         ALCUR            11 2          TOTAL BAL
     C                   EndDo
     C   40              ADD       YTDC          ALYTD            11 2          TOTAL YTD BAL
     C   40              ADD       CURBAL        ALTOT            11 2          TOTAL CUR BAL
      *
      * REVENUE - EXPENSES
      *
     C   42              ADD       GLBALT        REBAL            11 2          TOTAL PRIOR BAL
     C     Y             Do        Z             W
     C*  42              ADD       CR(Y)         RECUR            11 2          TOTAL BAL
     C   42              ADD       CR(W)         RECUR            11 2          TOTAL BAL
     C                   EndDo
     C   42              ADD       YTDC          REYTD            11 2          TOTAL YTD BAL
     C   42              ADD       CURBAL        RETOT            11 2          TOTAL CUR BAL
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   ADD       1             FIRST
     C                   MOVEL     GCATYP        OTYPE             1 0
     C                   GOTO      NXT
      *
      * REVERSE THE TOTAL PROFIT/LOSS SIGN
      *
     C     ENDP          TAG
     C                   Z-SUB     REBAL         FBALT            11 2
     C                   Z-SUB     RECUR         FCUR             11 2
     C                   Z-SUB     REYTD         FYTDC            11 2
     C                   Z-SUB     RETOT         FCURBL           11 2
      *
     C                   SETON                                        54
     C                   EXCEPT    TL1
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *********
      * GETTYP
      *********
     C     GETTYP        BEGSR
     C     OTYPE         IFEQ      1
     C                   SETON                                        51
     C                   ENDIF
     C     OTYPE         IFEQ      2
     C                   SETON                                        52
     C                   ENDIF
     C     OTYPE         IFEQ      3
     C                   SETON                                        53
     C                   ENDIF
     C     OTYPE         IFEQ      4
     C                   SETON                                        54
     C                   ENDIF
     C                   ENDSR
      *
     OGLR570    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           72 'Trial Balance By Account'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           48 'For Period(s):'
     O                       LACTPb              51
     O                                           52 '-'
     O                       LACTPe              54
     O                       LBEGDT        Y     66
     O                                           69 '-'
     O                       LENDDT        Y     79
     O          E            HDG            1
     O                                           68 'Prior'
     O          E            HDG            1
     O                                           10 'G/L'
     O                                           69 'Year End'
     O                                           84 'Current'
     O                                           96 'YTD'
     O                                          114 'Current'
     O          E            HDG            1
     O                                           12 'Account'
     O                                           35 'Description'
     O                                           69 'Balance'
     O                                           84 'Period(s)'
     O                                           99 'Balance'
     O                                          114 'Balance'
     O          E            HDG            2
     O                                           24 '------------------------'
     O                                           48 '------------------------'
     O                                           72 '------------------------'
     O                                           96 '------------------------'
     O                                          120 '------------------------'
     O          E            DETL           1
     O                       GCGLNO              14 '    -    '
     O                       GCDESC              45
     O              N13N14   GLBALT        JB    70
     O*                      CR(Y)         JB    85
     O                       CRY           JB    85
     O                       YTDC          JB   100
     O                       CURBAL        JB   115
     O          E            TL1            1
     O                                           69 '------------'
     O                                           84 '------------'
     O                                           99 '------------'
     O                                          114 '------------'
     O          E            TL1            2
     O               51                          35 '** Total Assets'
     O               52                          40 '** Total Liabilities'
     O               53                          36 '** Total Revenue'
     O               54                          37 '** Total Expenses'
     O              N53N54   BALL1         JB    70
     O                       CURL1         JB    85
     O                       YTDL1         JB   100
     O                       TOTL1         JB   115
     O          E            TL2            2
     O                                           44 '*** Total Assets & Liabi'
     O                                           50 'lities'
     O                       ALBAL         JB    70
     O                       ALCUR         JB    85
     O                       ALYTD         JB   100
     O                       ALTOT         JB   115
     O          E            TLR            1
     O                                           69 '============'
     O                                           84 '============'
     O                                           99 '============'
     O                                          114 '============'
     O          E            TLR         1
     O                                           44 '*** Total Profit or Loss'
     O                       FBALT         J     70
     O                       FCUR          J     85
     O                       FYTDC         J    100
     O                       FCURBL        J    115
