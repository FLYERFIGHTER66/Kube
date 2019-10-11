      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      *PROGRAM NAME-------- BIR140
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- G/L COMPANY DEFAULTS MASTER LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCDEF    IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FFMSVIA    IF   E           K DISK
     FFMSLSM    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FBIR140    O    F   80        PRINTER
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
      *
     C     LCO           CHAIN(N)  FMCORG                             90
     C                   EXCEPT    HDG
      *
     C     LCO           SETLL     FMCDEF
     C     NXT           TAG
     C                   SETOFF                                       90
     C     LCO           READE     FMCDEF                                 90
     C   90              GOTO      END
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
      *
     C     CDTMCD        CHAIN     FMTERM                             91
     C     CDSVIA        CHAIN     FMSVIA                             92
     C     CDSLSM        CHAIN     FMSLSM                             93
     C                   EXCEPT    DETL
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OBIR140    E            HDG            1 03
     O                       PROGID              10
     O                       RGNAMC              55
     O                       PAGE          1     80
     O                                           77 'Page'
     O          E            HDG            1
     O                       TDATE         Y      8
     O                                           52 'Company Defaults Listing'
     O                       TIMOD               80 '  :  :  '
     O          E            HDG            2
     O                                           13 'Requested by:'
     O                       USERID              24
     O                                           44 'For Company:'
     O                       LCO                 47
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           80 '________'
     O          E            DETL           1
     O                                           49 '** Customer File **'
     O          E            DETL           1
     O                                           49 '___________________'
     O          E            DETL           1
     O                                            6 'Terms:'
     O                       CDTMCD               9
     O              N91      TCDESC              40
     O               91                          32 '* Invalid Terms Code *'
     O                                           60 'Price Code:'
     O                       CDPRCD              65
     O          E            DETL           1
     O                                           15 'Contract Price:'
     O                       CDCTCD              17
     O                                           62 'Markup Price:'
     O                       CDMRKP              65
     O          E            DETL           1
     O                                            9 'Ship Via:'
     O                       CDSVIA              12
     O              N92      SVDESC              43
     O               92                          33 '* Invalid Ship Via *'
     O                                           61 'Back Orders:'
     O                       CDBOOK              65
     O          E            DETL           1
     O                                           12 'Salesperson:'
     O                       CDSLSM              15
     O              N93      SMNAME              46
     O               93                          39 '* Invalid Salesperson *'
     O                                           62 'Commission %:'
     O                       CDCOMM        J     69
     O          E            DETL           1
     O                                           11 'Cash/Check:'
     O                       CDCODF              15
     O                                           62 'Commission %:'
     O                       CDCOMM        J     69
