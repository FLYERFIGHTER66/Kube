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
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR185
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- ALTERNATE PRICE CODE LISTING
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMALTP    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FBIR185    O    F  132        PRINTER OFLIND(*INOF)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     00            KEY               2 0
     C     KEY           CHAIN     FMCORG                             88
     C                   SETON                                        8990
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FMALTP                                 90
     C   90              GOTO      END
      *
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OBIR185    E            HDG            1 03
     O                       PROGID              10
     O                                           25 'Requested by:'
     O                       USERID              36
     O                       RGNAMC              75
     O                       PAGE          1    120
     O                                          117 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     20
     O                                           71 'Alternate Price Codes'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           10 'Code'
     O                                           30 'From Date'
     O                                           50 'To Date'
     O                                           70 'Unit Price'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL           1
     O                       ALCODE               9
     O                       ALBDTE              30 '  /  /    '
     O                       ALEDTE              50 '  /  /    '
     O                       ALUPRI        4     70
