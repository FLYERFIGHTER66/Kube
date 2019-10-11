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
      **PROGRAM NAME-------- GRS500  -  LOT AVAILABILITY REPORT
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT SYSTEM
      **APPLICATION--------- PRODUCTION
      **DESCRIPTION--------- LIST LOT AVAILABILITY
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFDLOTRDR  IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FGRS500    O    F  132        PRINTER OFLIND(*INOF)
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
     D  LBEGDT                 1      6  0
     D  LENDDT                 7     12  0
     D  LPC1                  13     14
     D  LPC2                  15     16
     D  LSUM                  17     17
     D  LJOBQ                 18     18
     D  LFORM                 19     28
     D  LP1COP                29     30  0
     D  LBEGIT                89    100
     D  LSIZE                101    103
     D  LCANCL               133    133
      *
     C   OF              SETON                                        OF
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     1             ITM               3 0
     C                   Z-ADD     *ZEROS        KEY               2 0
     C     KEY           CHAIN     FMCOMP                             88
      *
     C     LBEGIT        IFGT      *BLANKS
     C                   SETON                                        6065
     C                   ENDIF
      *
     C     LBEGDT        IFGT      *ZEROS
     C     LBEGDT        MULT      10000.01      BDAT1             6 0
     C                   MOVEL     BDAT1         YY                2 0
     C                   MOVE      BDAT1         BDATE             7 0
     C     YY            IFLE      70
     C                   MOVEL     1             BDATE
     C                   ELSE
     C                   MOVEL     0             BDATE
     C                   END
     C     LENDDT        MULT      10000.01      EDAT1             6 0
     C                   MOVEL     EDAT1         YY                2 0
     C                   MOVE      EDAT1         EDATE             7 0
     C     YY            IFLE      70
     C                   MOVEL     1             EDATE
     C                   ELSE
     C                   MOVEL     0             EDATE
     C                   END
     C                   SETON                                        6165
     C                   ENDIF
      *
     C     LPC1          IFGT      *BLANKS
     C                   SETON                                        6265
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      RDLOTRD                                77
     C   77              GOTO      END
     C                   Z-ADD     LRCRDY        WK6               6 0
     C     WK6           MULT      100.0001      SHPDTE            6 0
      *
      * ONLY 1 ITEM
      *
     C   60LRITEM        IFNE      LBEGIT
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   60LRSIZE        IFNE      LSIZE
     C                   GOTO      NXT
     C                   ENDIF
      *
      * ONLY CERTAIN READY DATES
      *
     C   61LRCRDY        IFLT      BDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   61LRCRDY        IFGT      EDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
      * ONLY CERTAIN PRODUCT CLASSES
      *
     C   62LRPRCL        IFLT      LPC1
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   62LRPRCL        IFGT      LPC2
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LRITEM        IFEQ      SAVITM
     C     LRSIZE        ANDEQ     SAVSZE
     C                   GOTO      NOCHG
     C                   ENDIF
     C   55              EXCEPT    TL1
      *
     C                   Z-ADD     1             ITM
     C     ITMKEY        KLIST
     C                   KFLD                    LRITEM
     C                   KFLD                    LRSIZE
     C     ITMKEY        CHAIN     FMINVT                             50
      *
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    LRITEM
     C                   PARM                    LRSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESCP            50
     C     NOCHG         TAG
      *
     C     LRQTOH        SUB       LRQTAL        QTAV             11 1
     C                   ADD       LRQTOH        TLQTOH           12 1
     C                   ADD       LRQTAL        TLQTAL           12 1
     C                   ADD       QTAV          TLQTAV           12 1
      *
     C                   MOVEL     LRITEM        SAVITM           12
     C                   MOVEL     LRSIZE        SAVSZE            3
     C     ITM           IFEQ      1
     C                   SETON                                        50
     C                   ENDIF
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DTL1
     C                   SETON                                        55
     C                   ADD       1             ITM
     C                   SETOFF                                       50
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TL1
     C                   SETON                                        LR
      *
     OGRS500    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       MCNAME              75
     O                                          114 'Page'
     O                       PAGE          1    120
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           62 'Lot Availabili'
     O                                           71 'ty Report'
     O                       TIMOD              120 '  :  :  '
     O          E   N65      HDG            1
     O                                            1 ' '
     O          E    65      HDG            2
     O               60                          15 'Requested Item:'
     O               60      LBEGIT              31
     O               60      LSIZE               34
     O               61                          60 'Requested Dates:'
     O               61      LBEGDT        Y     69
     O               61                          71 '-'
     O               61      LENDDT        Y     80
     O               62                         112 'Product Classes:'
     O               62      LPC2               115
     O               62                         117 '-'
     O               62      LPC2               120
     O          E            HDG            1
     O                                           19 'Pr'
     O                                           78 'Ready'
     O                                           97 'Qty'
     O                                          108 'Qty'
     O                                          119 'Qty'
     O          E            HDG            1
     O                                            4 'Item'
     O                                           16 'Size'
     O                                           19 'Cl'
     O                                           89 'Phyto'
     O                                           42 'Description'
     O                                           83 'Loc'
     O                                           77 'Date'
     O                                           97 'O/H'
     O                                          109 'Alloc'
     O                                          120 'Avail'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DTL1           1
     O                       QTAV          J    120
     O                       LRQTAL        J    109
     O                       LRQTOH        J     98
     O                       LRCPHY              87
     O*                        SHPDTEY   82
     O                       LRCLOC              83
     O                       SHPDTE        Y     79
     O               50      DESCP               70
     O               50      LRPRCL              19
     O               50      LRSIZE              16
     O               50      LRITEM              12
     O          E            TL1            1
     O                                          120 '---------'
     O                                          109 '---------'
     O                                           98 '---------'
     O          E            TL1            2
     O                                           85 'Item Totals ====>'
     O                       TLQTAV        JB   120
     O                       TLQTAL        JB   109
     O                       TLQTOH        JB    98
