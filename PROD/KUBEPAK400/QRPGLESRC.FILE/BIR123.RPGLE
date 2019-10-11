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
      *PROGRAM NAME-------- BIR123
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- TERMS CODES MASTER LISTING
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMTERM    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FBIR123    O    F  120        PRINTER OFLIND(*INOF)
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
     C                   MOVEL     '00'          COMP              2 0
     C     COMP          CHAIN(N)  FMCORG                             90
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       901011
     C                   READ      FMTERM                                 90
     C   90              GOTO      END
      *
     C     TCDDUE        IFGT      *ZEROS
     C                   SETON                                        10
     C                   ENDIF
      *
     C     TCNDUE        IFGT      *ZEROS
     C                   SETON                                        11
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OBIR123    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                       PAGE          1    120
     O                                          117 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           70 'Terms Codes Master List'
     O                                           73 'ing'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           84 '-Before Cut Off-'
     O                                          102 '-After Cut Off-'
     O          E            HDG            1
     O                                            9 '--Terms--'
     O                                           67 'Disc  Disc  Due   Cutoff'
     O                                           91 'Mths  Disc  Net   Mths'
     O                                          117 'Disc  Net   Disc     Net'
     O          E            HDG            0
     O                                           22 'Code Type  Description'
     O                                           66 ' %   Days  Days   Days'
     O                                           92 'To Add  Due  Due  To Add'
     O                                          111 ' Due  Due  Due Dt '
     O                                          120 'Due Date'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL           1
     O                       TCTERM               3
     O                       TCTRTP               7
     O                       TCDESC              41
     O                       TCTRAT        1     47
     O                       TCTDAY        Z     52
     O                       TCTDAS        Z     58
     O                       TCCUTO        Z     65
     O                       TCMBCO        Z     72
     O                       TCDBCO        Z     78
     O                       TCNBCO        Z     83
     O                       TCMACO        Z     90
     O                       TCDACO        Z     96
     O                       TCNACO        Z    102
     O               10      TCDDUE        Y    111
     O               11      TCNDUE        Y    120
