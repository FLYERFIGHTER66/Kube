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
      *PROGRAM NAME-------- ARR103
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- CREDIT CARD MASTER FILE LISTING
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCRED    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMBANK    IF   E           K DISK
     FARR103    O    F  120        PRINTER OFLIND(*INOF)
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
     C                   MOVEL     '01'          RGCOMP
     C     RGCOMP        CHAIN(N)  FMCORG                             90
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FMCRED                                 90
     C   90              GOTO      END
      *
     C     CCBANK        CHAIN     FMBANK                             90
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OARR103    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                       PAGE          1    120
     O                                          117 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           71 'Credit Card Master List'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            0
     O                                           14 'Code'
     O                                           30 'Description'
     O                                           60 'Bank'
     O                                           93 'G/L Acct'
     O                                          110 'Telephone #'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL           1
     O                       CCCODE              14
     O                       CCDESC              45
     O                       CCBANK              52
     O                       BADESC              83
     O                       BAGLNO              93 '    -    '
     O                       CCTELE             110 '   -   -    '
