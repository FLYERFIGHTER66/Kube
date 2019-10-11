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
      *PROGRAM NAME-------- BIR130
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- TAX JURISDICTION MASTER LISTING
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMTAXF    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FBIR130    O    F   80        PRINTER OFLIND(*INOF)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   MOVEL     '00'          COMP              2 0
     C     COMP          CHAIN     FMCORG                             90
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       90
     C                   READ      FMTAXF                                 90
     C   90              GOTO      END
      *
      * CHECK FOR DELETED RECORD
      *
     C     TXSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *                                                                   GLR110
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OBIR130    E            HDG            1 03
     O                       PROGID              10
     O                       RGNAMC              55
     O                       PAGE          1     80
     O                                           77 'Page'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           51 'Tax Jurisdiction Master'
     O                       TIMOD               80 '  :  :  '
     O          E            HDG            2
     O                                           13 'Requested by:'
     O                       USERID              24
     O          E            HDG            1
     O                                            8 'Tax'
     O                                           74 '--- Tax Percentages ---'
     O          E            HDG            0
     O                                           13 'Jurisdiction'
     O                                           31 'Description'
     O                                           53 'State'
     O                                           65 'County'
     O                                           80 'Muncipality'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           80 '________'
     O          EF           DETL           1
     O                       TXTXJU               8
     O                       TXJUNM              45
     O                       TXPCT1        1     53
     O                       TXPCT2        1     65
     O                       TXPCT3        1     77
