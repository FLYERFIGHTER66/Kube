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
      *PROGRAM NAME-------- BIR117
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- FREIGHT CODE MASTER LISTING
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFFPERC    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FBIR117    O    F   80        PRINTER OFLIND(*INOF)
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
     C     LCO           CHAIN(N)  FMCORG                             90
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       901011
     C                   READ      FFPERC                                 90
     C   90              GOTO      END
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C     FPTYPE        IFEQ      'P'
     C                   SETON                                        77
     C                   ENDIF
      *
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OBIR117    E            HDG            1 03
     O                       PROGID              10
     O                       RGNAMC              55
     O                       PAGE          1     80
     O                                           77 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           52 'Freight Code Master List'
     O                       TIMOD               80 '  :  :  '
     O          E            HDG            1
     O                                           13 'Requested by:'
     O                       USERID              24
     O          E            HDG            1
     O                                            2 'Co'
     O                                           12 'Freight'
     O          E            HDG            0
     O                                            2 '#'
     O                                           12 '  Code '
     O                                           20 'Type'
     O                                           30 'Charge'
     O                                           45 'Percent'
     O                                           60 'Minimum'
     O                                           75 'Maximum'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           80 '________'
     O          EF           DETL           1
     O                       FPCONO               2
     O                       FPCODE              12
     O                       FPTYPE              19
     O              N77      FPCHRG        MB    30
     O               77      FPCHRG        MB    45
     O                       FPMIN         MB    60
     O                       FPMAX         MB    75
