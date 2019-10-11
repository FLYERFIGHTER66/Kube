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
      *PROGRAM NAME-------- BIR124
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- STATE CODES MASTER FILE LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMSTAT    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFSYSCTL   IF   E             DISK
     FBIR124    O    F  132        PRINTER OFLIND(*INOF)
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
     C                   MOVEL     '00'          CKEY              2 0
     C     CKEY          CHAIN(N)  FMCORG                             90
      *
     C                   READ      FSYSCTL                                99
     C     ZZTYPE        IFEQ      'G'
     C                   SETON                                            88
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       90
     C                   READ      FMSTAT                                 90
     C   90              GOTO      END
     C                   ADD       1             X                 1 0
      *
     C     CNT           IFEQ      55
     C                   EXCEPT    HDG
     C                   Z-ADD     0             CNT
     C                   ENDIF
      *
     C     X             IFEQ      1
     C                   MOVEL     STCODE        STAT1             2
     C                   MOVEL     STNAME        DESC1            30
     C                   MOVEL     STPHYT        PHYT1             1
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     X             IFEQ      2
     C                   MOVEL     STCODE        STAT2             2
     C                   MOVEL     STNAME        DESC2            30
     C                   MOVEL     STPHYT        PHYT2             1
     C                   ENDIF
      *
     C                   EXCEPT    DETL
     C                   ADD       1             CNT               2 0
     C                   Z-ADD     0             X
     C                   GOTO      NXT
      *
     C     END           TAG
     C     X             IFGT      0
     C                   MOVEL     STCODE        STAT1
     C                   MOVEL     STNAME        DESC1
     C                   MOVEL     STPHYT        PHYT1
      *
     C                   MOVEL     *BLANKS       STAT2
     C                   MOVEL     *BLANKS       DESC2
     C                   MOVEL     *BLANKS       PHYT2
     C                   EXCEPT    DETL
     C                   ENDIF
     C                   SETON                                        LR
      *
     OBIR124    E            HDG            1 03
     O                       PROGID              10
     O                       RGNAMC              55
     O                       PAGE          1     80
     O                                           77 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           37 'State Codes'
     O                                           52 'Master Listing'
     O                       TIMOD               80 '  :  :  '
     O          E            HDG            2
     O                                           13 'Requested by:'
     O                       USERID              24
     O          E            HDG            0
     O                                            4 'Code'
     O                                           18 'Description'
     O               88                          38 'Phyto'
     O                                           44 'Code'
     O                                           58 'Description'
     O               88                          78 'Phyto'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           80 '________'
     O          E            DETL           1
     O                       STAT1                3
     O                       DESC1               34
     O               88      PHYT1               36
     O                       STAT2               43
     O                       DESC2               74
     O               88      PHYT2               76
