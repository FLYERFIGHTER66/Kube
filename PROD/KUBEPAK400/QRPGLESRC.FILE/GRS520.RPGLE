      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1995
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- GRS520  -  LOT TRANSACTION REPORT
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT SYSTEM
      **APPLICATION--------- PRODUCTION
      **DESCRIPTION--------- LIST WEEKLY PRODUCTION
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFLOTRN    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FGRS520    O    F  132        PRINTER OFLIND(*INOF)
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
     D                UDS
     D  LJOBQ                  6      6
     D  LFORM                  7     16
     D  LP1COP                25     26  0
     D  LBEGDT                37     42  0
     D  LENDDT                43     48  0
     D  LBEGIT                89    100
     D  LENDIT               104    115
     D  LSLOC                116    118
     D  LRLOC                119    121
     D  LREAS                122    124
     D  LCANCL               133    133
     D  LUSER                134    141
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     1             LOC               3 0
     C                   MOVEL     '00'          MCCOMP
     C     CKEY          KLIST
     C                   KFLD                    MCCOMP
     C     CKEY          CHAIN(N)  FMCOMP                             88
     C  N88              MOVEL     MCNAME        SVNAME           30
      *
     C     LBEGDT        IFGT      *ZEROS
     C                   SETON                                        15
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       161718
     C                   SETOFF                                       192021
     C                   READ      FLOTRN                                 77
     C   77              GOTO      END
      *
     C     FLLRDY        IFGT      *ZEROS
     C                   SETON                                        16
     C                   ENDIF
      *
     C     FLACTD        MULT      100.0001      ACTDTE            6 0
      *
     C   15FLACTD        IFLT      LBEGDT
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   15FLACTD        IFGT      LENDDT
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LBEGIT        IFGT      *BLANKS
     C     FLITEM        ANDLT     LBEGIT
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LENDIT        IFGT      *BLANKS
     C     FLITEM        ANDGT     LENDIT
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LSLOC         IFGT      *BLANKS
     C     FLLLOC        ANDNE     LSLOC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LRLOC         IFGT      *BLANKS
     C     FLNLOC        ANDNE     LRLOC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LREAS         IFGT      *BLANKS
     C     FLREAS        ANDNE     LREAS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LUSER         IFGT      *BLANKS
     C     FLUSER        ANDNE     LUSER
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     ITMKEY        KLIST
     C                   KFLD                    FLITEM
     C                   KFLD                    FLSIZE
     C     ITMKEY        CHAIN     FMINVT                             60
      *
     C                   MOVE      IMDES1        DESA             30
     C                   MOVE      IMDES2        DESB             30
     C     DESA          CAT       DESB:1        DES1             60
     C                   MOVE      IMDES3        DESC             30
     C                   MOVE      IMDES4        DESD             30
     C     DES1          CAT       DESC:1        DESP             32
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C     FLLRDY        IFNE      FLNRDY
     C                   SETON                                        1721
     C                   ENDIF
     C     FLLRDY        MULT      100.0001      LRDY              6 0
     C     FLNRDY        MULT      100.0001      NRDY              6 0
     C     FLLPHY        IFNE      FLNPHY
     C                   SETON                                        1821
     C                   ENDIF
     C     FLLCOD        IFNE      FLNCOD
     C                   SETON                                        1921
     C                   ENDIF
     C     FLLLOC        IFNE      FLNLOC
     C                   SETON                                        2021
     C                   ENDIF
     C                   EXCEPT    DTL1
     C   21              EXCEPT    DTL2
     C                   SETON                                        55
     C                   ADD       1             LOC               3 0
     C                   SETOFF                                       50
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OGRS520    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       SVNAME              75
     O                                          114 'Page'
     O                       PAGE          1    120
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           70 'Lot Transaction List'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           11 'Trans'
     O                                           72 'Ready'
     O          E            HDG            1
     O                                           10 'Date'
     O                                           18 'Item'
     O                                           29 'Size'
     O                                           44 'Description'
     O                                           71 'Date'
     O                                           79 'Phyto'
     O                                           85 'Code'
     O                                           91 'Reas'
     O                                           96 'Loc'
     O                                          109 'Qty'
     O                                          118 'User'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DTL1           1
     O               21                           4 'Ori:'
     O                       ACTDTE        Y     13
     O                       FLITEM              26
     O                       FLSIZE              29
     O                       DESP                67
     O               16      LRDY          Y     73
     O                       FLNPHY              77
     O                       FLNCOD              84
     O                       FLREAS              90
     O                       FLLLOC              95
     O                       FLQTY         M    111
     O                       FLUSER             120
     O          EF           DTL2           1
     O               17      NRDY          Y     73
     O               18      FLLPHY              77
     O               19      FLLCOD              84
     O               20      FLNLOC              95
     O                                            4 'Chg:'
