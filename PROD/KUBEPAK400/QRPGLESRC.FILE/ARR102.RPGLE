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
      *PROGRAM NAME-------- ARR102
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- BANK MASTER FILE LISTING
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMBANK    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FARR102    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LLIST                  3      3
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FMCORG                             90
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       901011
     C                   READ      FMBANK                                 90
     C   90              GOTO      END
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
      *
     C     GLKEY         KLIST
     C                   KFLD                    BACOMP
     C                   KFLD                    BAGLNO
     C     GLKEY         CHAIN     FMGLCH                             90
      *
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OARR102    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                       PAGE          1    120
     O                                          117 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           62 'Bank Master File List'
     O                                           80 'For All Companies'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            0
     O                                           20 'Code'
     O                                           30 'Co #'
     O                                           47 'Bank Account'
     O                                           80 'G/L Number'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL           1
     O                       BACODE              20
     O                       BACOMP              30
     O                       BADESC              65
     O                       BAGLNO              80 '    -    '
     O                       GCDESC             111
