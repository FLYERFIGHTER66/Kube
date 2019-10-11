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
      *PROGRAM NAME-------- GLR120
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- G/L CHART OF ACCOUNTS MASTER LIST BY TYPE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFMGLCHTP  IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FGLR120    O    F   80        PRINTER OFLIND(*INOF)
      *
     D                UDS
     D  LCO                    1      2  0
     D  LSELEC                 3      3  0
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN(N)  FMCORG                             90
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       212223
     C                   SETOFF                                       2490
     C                   READ      FMGLCHTP                               90
     C   90              GOTO      END
      *
     C     GCCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK FOR DELETED RECORD
      *
     C     GCSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     GCATYP        IFEQ      1
     C                   SETON                                        21
     C                   ENDIF
     C     GCATYP        IFEQ      2
     C                   SETON                                        22
     C                   ENDIF
     C     GCATYP        IFEQ      3
     C                   SETON                                        23
     C                   ENDIF
     C     GCATYP        IFEQ      4
     C                   SETON                                        24
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OGLR120    E            HDG            1 03
     O                       PROGID              10
     O                                           18 'Req by:'
     O                       USERID              29
     O                       RGNAMC              55
     O                       PAGE          1     80
     O                                           77 'Page'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           45 'General Ledger Chart'
     O                                           57 'of Accounts'
     O                       TIMOD               80 '  :  :  '
     O          E            HDG            2
     O                                           45 'For Company:'
     O                       LCO                 48
     O          E            HDG            1
     O                                            8 'G/L'
     O                                           80 'Cons'
     O          E            HDG            0
     O                                            9 'Account'
     O                                           30 'Description'
     O                                           52 'Type'
     O                                           72 'Alpha Search'
     O                                           80 'Detl'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           80 '________'
     O          EF           DETL           1
     O                       GCGLNO         B     9 '    -    '
     O                       GCDESC         B    42
     O                       GCATYP         B    45
     O                                           46 '='
     O               21                          57 'Asset      '
     O               22                          57 'Liability  '
     O               23                          57 'Revenue    '
     O               24                          57 'Expense    '
     O                       GCLOOK         B    75
     O                       GCCONF              78
