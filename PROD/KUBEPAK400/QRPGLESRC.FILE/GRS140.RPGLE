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
      *PROGRAM NAME-------- GRS140
      *SYSTEM-------------- TGMS
      *APPLICATION--------- LIST CODES MASTER LISTING
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  7/20/00 EFD ADD PRICES.
      *
     FFMCOMP    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFLISTCD   IF   E           K DISK
     FGRS140    O    F  120        PRINTER OFLIND(*INOF)
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
     C                   MOVEL     '00'          MCCOMP
     C     CKEY          KLIST
     C                   KFLD                    MCCOMP
     C     CKEY          CHAIN(N)  FMCOMP                             90
     C     MCPRCO        CHAIN     FMCORG                             90
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       90
     C                   READ      FLISTCD                                90
     C   90              GOTO      END
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OGRS140    E            HDG            1 03
     O                       PROGID              10
     O                       RGNAMC              80
     O                       PAGE          1    120
     O                                          117 'Page'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           74 'List Codes Listing'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           13 'Requested by:'
     O                       USERID              24
     O          E            HDG            1
     O                                           14 'Code'
     O                                           30 'Description'
     O                                           60 'Short Desc'
     O                                           71 'Price 1'
     O                                           82 'Price 2'
     O                                           93 'Price 3'
     O                                          104 'Price 4'
     O                                          115 'Price 5'
     O          E            HDG            2
     O                                           24 '     ___________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL           2
     O                       LCCODE              14
     O                       LCDESC              49
     O                       LCDESS              60
     O                       LCSEL1        2     71
     O                       LCSEL2        2     82
     O                       LCSEL3        2     93
     O                       LCSEL4        2    104
     O                       LCSEL5        2    115
