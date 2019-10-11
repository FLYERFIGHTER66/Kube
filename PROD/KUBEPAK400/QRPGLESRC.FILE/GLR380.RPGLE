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
      *PROGRAM NAME-------- GLR380
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- ALLOCATION EDIT LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFGLALO    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FGLR380    O    F  121        PRINTER OFLIND(*INOF)
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
     C     LCO           CHAIN     FMCORG                             90
      *
     C                   EXCEPT    HDG
      *
     C                   MOVEL     *BLANKS       GAJEPR
     C                   Z-ADD     0             GAJENM
     C                   MOVEL     *BLANKS       GAJESF
     C                   Z-ADD     0             GASEQ#
     C     GLKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GAJEPR
     C                   KFLD                    GAJENM
     C                   KFLD                    GAJESF
     C                   KFLD                    GASEQ#
     C     GLKEY         SETLL     FGLALO
      *
     C     NXT           TAG
     C                   SETOFF                                           11    1220
     C                   SETOFF                                           77
     C     LCO           READE     FGLALO                                 90
     C   90              GOTO      END
      *
     C     GACOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     GASTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     CNT           IFGT      1
     C     GAJENM        ANDNE     OLJENM
     C     GAJEPR        ORNE      OLJEPR
     C     GAJESF        ORNE      OLJESF
     C                   EXCEPT    TL1
     C                   Z-ADD     1             CNT
     C                   SETOFF                                       20
     C                   ENDIF
      *
      * CHECK FOR DEBIT OR CREDIT AMOUNT
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C     CNT           IFEQ      1
     C                   SETON                                        77
     C                   ENDIF
     C                   EXCEPT    DETL
     C                   SETOFF                                       1112
      *
     C                   MOVEL     GAJEPR        OLJEPR            2
     C                   Z-ADD     GAJENM        OLJENM            6 0
     C                   MOVEL     GAJESF        OLJESF            2
      *
     C                   ADD       1             CNT
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OGLR380    E            HDG            1 03
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
     O                                           69 'Allocation Edit List'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           17 '- Journal Entry -'
     O                                           31 'J.E.'
     O                                           59 'From'
     O                                           71 'To'
     O                                           83 '%'
     O          E            HDG            0
     O                                            9 'Number'
     O                                           16 'Seq'
     O                                           37 'Description'
     O                                           60 'Account'
     O                                           74 'Account'
     O                                           87 'Allocated'
     O                                          104 'Description'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL           1
     O                       GADDES             120
     O                       GAPCT         MB    87
     O                       GATOAC              74 '    -    '
     O               77      GAFRAC              60 '    -    '
     O               77      GAJEDS              47
     O               77      GASEQ#        Z     16
     O               77      GAJESF              12
     O               77      GAJENM        Z      9
     O               77      GAJEPR               2
     O          EF           TL1            1
