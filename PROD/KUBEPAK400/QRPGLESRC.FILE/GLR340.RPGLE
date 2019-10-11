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
      *PROGRAM NAME-------- GLR340
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- POST START UP TO GLBAL FILE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFGLENT    IF   E           K DISK
     FFGLBAL    IF A E           K DISK
     FFMGLCH    IF   E           K DISK
     FGLR340    O    F  120        PRINTER OFLIND(*INOF)
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
     C                   Z-ADD     1             FIRST             2 0
      *
     C     NXT           TAG
     C                   SETOFF                                       11
     C                   READ      FGLENT                                 90
     C   90              GOTO      END
      *
     C     GLKEY         KLIST
     C                   KFLD                    GLCOMP
     C                   KFLD                    GLGLNO
     C     GLKEY         CHAIN     FGLBAL                             11
      *
     C   11              GOTO      NODUP
     C     FIRST         IFEQ      1
     C                   EXCEPT    HDG
     C                   ENDIF
      *
     C     GLKEY         CHAIN     FMGLCH                             90
     C                   EXCEPT    DETL
     C                   ADD       1             FIRST
     C                   GOTO      NXT
      *
     C     NODUP         TAG
      *
     C                   MOVEL     'A'           GLSTAT
     C                   Z-ADD     TIMOD         GLTIME
     C                   Z-ADD     TDATE         GLDTLA
     C                   MOVEL     USERID        GLUSER
     C                   WRITE     RGLBAL
     C                   GOTO      NXT
      *
     C     END           TAG
     C   11              EXCEPT    TLR
     C                   SETON                                        LR
      *
     OGLR340    E            HDG            1 03
     O                       PROGID              10
     O                                           25 'Requested by:'
     O                       USERID              36
     O                                           61 'G/L Balance Forward'
     O                                           79 'Duplicate Records'
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          1    120
     O                                          117 'Page:'
     O          E            HDG            2
     O                       TDATE         Y     18
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           12 'Company'
     O                                           25 'G/L Acct'
     O          E            HDG            1
     O                                           11 'Number'
     O                                           24 'Number'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       GLCOMP               9
     O                       GLGLNO              26 '    -    '
     O                       GCDESC              57
     O          E            TLR         2  2
     O                                           24 '** The Accounts Listed A'
     O                                           48 'bove Were Not Added To T'
     O                                           72 'he G/L Balance File.  Th'
     O                                           96 'ese Accounts Are Already'
     O                                          120 'In The Balance File **  '
