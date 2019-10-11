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
      *PROGRAM NAME-------- BIR128
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- ACCOUNTING PERIOD MASTER LISTING
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMAPER    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FBIR128    O    F   80        PRINTER OFLIND(*INOF)
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
     C                   MOVEL     '00'          CKEY              2 0
     C     CKEY          CHAIN     FMCORG                             90
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       9028
     C                   READ      FMAPER                                 90
     C   90              GOTO      END
     C     ACCOMP        CHAIN(N)  FMCORG                             90
     C                   MOVEL     RGNAME        CNAME            30
      *
     C     ACMPCN        IFEQ      'M'
     C                   MOVEL     'Month'       MORP              6
     C                   SETON                                        28
     C                   ELSE
     C                   MOVEL     'Period'      MORP              6
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
     OBIR128    E            HDG            1 03
     O                       PROGID              10
     O                       RGNAMC              55
     O                       PAGE          1     80
     O                                           77 'Page'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           52 'Accounting Period Master'
     O                       TIMOD               80 '  :  :  '
     O          E            HDG            2
     O                                           13 'Requested by:'
     O                       USERID              24
     O          E            HDG            1
     O                                           58 'Start Dates'
     O                                           76 'End Dates'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           80 '________'
     O          EF           DETL        1  1
     O                                            9 'Company:'
     O                       ACCOMP              12
     O                       CNAME               43
     O                                           48 '1.'
     O                       ACST01        Y     57
     O                       ACEN01        Y     75
     O          EF           DETL           1
     O                                           48 '2.'
     O                       ACST02        Y     57
     O                       ACEN02        Y     75
     O          EF           DETL           1
     O                                           14 'Month/Period:'
     O                       ACMPCN              16
     O                                           18 '='
     O                       MORP                25
     O                                           48 '3.'
     O                       ACST03        Y     57
     O                       ACEN03        Y     75
     O          EF           DETL           1
     O                                           48 '4.'
     O                       ACST04        Y     57
     O                       ACEN04        Y     75
     O          EF           DETL           1
     O                                           20 'Fiscal Year Starts:'
     O                       ACFSST        Y     29
     O                                           48 '5.'
     O                       ACST05        Y     57
     O                       ACEN05        Y     75
     O          EF           DETL           1
     O                                           48 '6.'
     O                       ACST06        Y     57
     O                       ACEN06        Y     75
     O          EF           DETL           1
     O                                           48 '7.'
     O                       ACST07        Y     57
     O                       ACEN07        Y     75
     O          EF           DETL           1
     O                                           48 '8.'
     O                       ACST08        Y     57
     O                       ACEN08        Y     75
     O          EF           DETL           1
     O                                           48 '9.'
     O                       ACST09        Y     57
     O                       ACEN09        Y     75
     O          EF           DETL           1
     O                                           48 '10.'
     O                       ACST10        Y     57
     O                       ACEN10        Y     75
     O          EF           DETL           1
     O                                           48 '11.'
     O                       ACST11        Y     57
     O                       ACEN11        Y     75
     O          EF           DETL           1
     O                                           48 '12.'
     O                       ACST12        Y     57
     O                       ACEN12        Y     75
     O          EF  N28      DETL           1
     O                                           48 '13.'
     O                       ACST13        Y     57
     O                       ACEN13        Y     75
