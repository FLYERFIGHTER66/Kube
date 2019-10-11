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
      *PROGRAM NAME-------- GLR320
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- STARTUP EDIT LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFGLENT    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FGLR320    O    F  132        PRINTER OFLIND(*INOF)
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
     C     LCO           CHAIN(N)  FMCORG                             90
     C                   SETON                                        8990
     C                   Z-ADD     1             FIRST             2 0
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FGLENT                                 90
     C   90              GOTO      END
      *
     C     GLCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     GLCOMP        CHAIN(N)  FMAPER                             90
     C     ACMPCN        IFEQ      'M'
     C                   SETON                                            30
     C                   ENDIF
      *
      * CHAIN TO MGLCH FOR ACCOUNT DESCRIPTION
      *
     C     GCKEY         KLIST
     C                   KFLD                    GLCOMP
     C                   KFLD                    GLGLNO
     C     GCKEY         CHAIN     FMGLCH                             11
      *
     C                   ADD       GLT01         C1               11 2
     C                   ADD       GLT02         C1               11 2
     C                   ADD       GLT03         C1               11 2
     C                   ADD       GLT04         C1               11 2
     C                   ADD       GLT05         C1               11 2
     C                   ADD       GLT06         C1               11 2
     C                   ADD       GLT07         C1               11 2
     C                   ADD       GLT08         C1               11 2
     C                   ADD       GLT09         C1               11 2
     C                   ADD       GLT10         C1               11 2
     C                   ADD       GLT11         C1               11 2
     C                   ADD       GLT12         C1               11 2
     C  N30              ADD       GLT13         C1               11 2
      *
     C                   ADD       GLL01         P1               11 2
     C                   ADD       GLL02         P1               11 2
     C                   ADD       GLL03         P1               11 2
     C                   ADD       GLL04         P1               11 2
     C                   ADD       GLL05         P1               11 2
     C                   ADD       GLL06         P1               11 2
     C                   ADD       GLL07         P1               11 2
     C                   ADD       GLL08         P1               11 2
     C                   ADD       GLL09         P1               11 2
     C                   ADD       GLL10         P1               11 2
     C                   ADD       GLL11         P1               11 2
     C                   ADD       GLL12         P1               11 2
     C  N30              ADD       GLL13         P1               11 2
      *
      * ACCUMULATE COMPANY TOTALS FOR BEGINNING BALANCES
      *
     C                   ADD       GLBALT        COBALT           11 2
     C                   ADD       GLBALL        COBALL           11 2
     C                   ADD       C1            LC1              11 2
     C                   ADD       P1            LP1              11 2
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TLR
     C                   SETON                                        LR
     O*
     OGLR320    E            HDG            1 03
     O                       PROGID              10
     O                                           25 'Requested by:'
     O                       USERID              36
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                                          115 'Page:'
     O                       PAGE          1    120
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           57 'G/L Balances'
     O                                           75 'Startup Edit List'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           56 '---------'
     O                                           69 'Current Year'
     O                                           79 '---------'
     O                                           97 '---------'
     O                                          111 'Previous Year'
     O                                          120 '--------'
     O          E            HDG            0
     O                                           12 'GL Account'
     O                                           30 'Description'
     O                                           57 'Beg. Balance'
     O                                           62 'Per'
     O                                           78 'Period Amount'
     O                                           98 'Beg. Balance'
     O                                          103 'Per'
     O                                          120 'Period Amount'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       GLCOMP               2
     O                                            3 '-'
     O                       GLGLNO              12 '    -    '
     O              N11      GCDESC              43
     O               11                          43 '* Account Master Error *'
     O                       GLBALT        J     58
     O                                           62 '01'
     O                       GLT01         J     78
     O                       GLBALL        J     99
     O                                          103 '01'
     O                       GLL01         J    120
     O          E            DETL           1
     O                                           62 '02'
     O                       GLT02         J     78
     O                                          103 '02'
     O                       GLL02         J    120
     O          E            DETL           1
     O                                           62 '03'
     O                       GLT03         J     78
     O                                          103 '03'
     O                       GLL03         J    120
     O          E            DETL           1
     O                                           62 '04'
     O                       GLT04         J     78
     O                                          103 '04'
     O                       GLL04         J    120
     O          E            DETL           1
     O                                           62 '05'
     O                       GLT05         J     78
     O                                          103 '05'
     O                       GLL05         J    120
     O          E            DETL           1
     O                                           62 '06'
     O                       GLT06         J     78
     O                                          103 '06'
     O                       GLL06         J    120
     O          E            DETL           1
     O                                           62 '07'
     O                       GLT07         J     78
     O                                          103 '07'
     O                       GLL07         J    120
     O          E            DETL           1
     O                                           62 '08'
     O                       GLT08         J     78
     O                                          103 '08'
     O                       GLL08         J    120
     O          E            DETL           1
     O                                           62 '09'
     O                       GLT09         J     78
     O                                          103 '09'
     O                       GLL09         J    120
     O          E            DETL           1
     O                                           62 '10'
     O                       GLT10         J     78
     O                                          103 '10'
     O                       GLL10         J    120
     O          E            DETL           1
     O                                           62 '11'
     O                       GLT11         J     78
     O                                          103 '11'
     O                       GLL11         J    120
     O          E            DETL           1
     O                                           62 '12'
     O                       GLT12         J     78
     O                                          103 '12'
     O                       GLL12         J    120
     O          E            DETL           1
     O              N30                          62 '13'
     O              N30      GLT13         J     78
     O              N30                         103 '13'
     O              N30      GLL13         J    120
     O          E            DETL           2
     O                                           42 '** Account Balances:'
     O                       GLBALT        J     58
     O                       C1            JB    78
     O                       GLBALL        J     99
     O                       P1            JB   120
     O          E            TLR         2  2
     O                                           42 '*** Company Balances:'
     O                       COBALT        J     58
     O                       LC1           JB    78
     O                       COBALL        J     99
     O                       LP1           JB   120
