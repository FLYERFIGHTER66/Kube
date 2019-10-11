      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- PSR120
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT UN-PRINTED ITEM LIST
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/22/02 EFD DO NOT PRINT READY BAY ORDERS.
      *
     FFPUTORDA  IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FPSR120    O    F   85        PRINTER OFLIND(*INOF)
      *
      *
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  RUNST                  1      1
     D  STRDAT                 4     10  0
     D  PLDATE                11     16  0
     D  ITEM                  17     28
     D  SIZE                  29     31
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  VOUT                 131    131  0
     D  LCANCL               133    133
      ***********************
      ** START HERE        **
      ***********************
     C     ITMKEY        KLIST
     C                   KFLD                    PDITEM
     C                   KFLD                    PDSIZE
     C     LOCKEY        KLIST
     C                   KFLD                    STRDAT
     C     LOCKEY        SETLL     FPUTORDA
     C     NXT           TAG
     C     LOCKEY        READE     FPUTORDA                               90
     C   90              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
     C     PDPRTD        IFEQ      'Y'
     C     PDRDYB        OREQ      'Y'
     C                   GOTO      NXT
     C                   END
     C     PDITEM        IFNE      IMITEM
     C     PDSIZE        ORNE      IMSIZE
     C     QTYORD        IFGT      0
     C   OF              EXCEPT    HEAD
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   Z-ADD     0             QTYORD            6 0
     C                   END
     C     ITMKEY        CHAIN     FMINVT                             91
     C                   END
     C                   ADD       PDQORD        QTYORD            6 0
     C                   ADD       PDQORD        TOTQTY            6 0
     C                   GOTO      NXT
      ** END PROG
     C     END           TAG
     C     TOTQTY        IFGT      0
     C   OF              EXCEPT    HEAD
     C                   EXCEPT    TOTL
     C                   END
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   SETON                                        OF
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OPSR120    E            HEAD           1 03
     O                                            6 'PSR120'
     O                                           21 'Requested by:'
     O                       USERID              32
     O                                           55 'Items Not Listed'
     O                       PAGE          Z     85
     O                                           81 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           47 'Ship Week:'
     O                       PLDATE        Y     56
     O                                           76 'Time:'
     O                       TIMOD               85 '  :  :  '
     O          E            HEAD           0
     O                                           26 'Item       Size'
     O                                           38 'Description'
     O                                           66 'Qty.Ord.'
     O          E            HEAD           1
     O                                           20 '           _________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           66 '______'
     O          EF           DETL           1
     O                       IMITEM              22
     O                       IMSIZE              26
     O                       IMDES1              57
     O                       QTYORD        1     64
     O          EF           TOTL           1
     O                                           64 '======'
     O          EF           TOTL           1
     O                                           56 'Total Quantity=========>'
     O                       TOTQTY        1     64
