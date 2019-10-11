      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.     1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   .  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR370
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- BACK ORDER REPORT
      *
      *
      *    CHANGE--DATE-------DESCRIPTION
      *
      *
     FFIORDISC  IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FBIR370    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LINCL                  3      3  0
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
     C                   SETON                                        8990
      *
     C                   Z-ADD     1             ITEM              6 0
     C                   Z-ADD     1             CNT               6 0
      *
      * 1 = ALL BACKORDERS
      * 2 = ONLY AVAILABLE TO SHIP
      *
     C     LINCL         IFEQ      1
     C                   SETON                                        10
     C                   ELSE
     C                   SETON                                        12
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FIORDISC                               90
     C   90              GOTO      END
      *
     C     OICOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OIQBOO        IFLE      0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OIITYP        IFNE      *BLANKS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OICUST        CHAIN     FMCUST                             91
      *
      *  GET ITEM MASTER RECORD
      *
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     KEY18         CHAIN     FMINVT                             75
     C                   EXSR      GETDES
      *
     C   12IMQTOH        IFLE      0
     C     IMQTAV        ORLT      0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OIITEM        IFNE      OITEM
     C     OISIZE        ORNE      OSIZE
     C     CNT           ANDGT     1
     C                   Z-ADD     1             ITEM
     C                   ENDIF
      *
     C     ITEM          IFEQ      1
     C                   EXCEPT    DETL1
     C                   ENDIF
      *
      *  11 = AVAILABLE TO SHIP
      *  12 = NOT AVAILABLE TO SHIP
      *
     C     OIORD#        CHAIN     FHORDR                             22
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DETL2
     C                   SETON                                        77
     C                   ADD       1             ITEM
     C                   ADD       1             CNT
     C                   MOVEL     OIITEM        OITEM            12
     C                   MOVEL     OISIZE        OSIZE             3
     C                   GOTO      NXT
      *
     C     END           TAG
     C  N77              EXCEPT    TLRN
     C                   SETON                                        LR
      *
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC             40
     C                   ENDSR
      *
     OBIR370    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          1    120
     O                                          116 'Page'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O               10                          66 'All Backorders'
     O               12                          65 'Backorders Available'
     O               12                          73 'To Ship'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                            5 'Item/'
     O                                           15 'Size'
     O                                           19 'Loc'
     O                                           23 'U/M'
     O                                           52 'Order'
     O                                           63 'Requested'
     O                                          110 '- - - - Quantity - - - -'
     O          E            HDG            0
     O                                            5 'Order'
     O                                           37 'Description'
     O                                           52 'Date'
     O                                           63 'Shp Date'
     O                                           90 'Ord'
     O                                          100 'Shpd'
     O                                          110 'B/O'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL1       1  0
     O                       IMQTAV        LB   120
     O                                          111 'Avail:'
     O                       IMQTAL        LB   101
     O                                           92 'Alloc:'
     O                       IMQTOH        LB    82
     O                                           73 'On Hand:'
     O                       DESC                64
     O                       IMPUOM              23
     O                       IMWHSE              19
     O                       IMSIZE              15
     O                       IMITEM              12
     O          E            DETL1          2
     O                                           23 '_______________________'
     O          E            DETL2          1
     O                       OIORD#        Z      6
     O                       OICUST        Z     13
     O                       CMNAME              45
     O                       OHDTOR        Y     54
     O                       OIDTRQ        Y     63
     O                       OIQBOO        M    110
     O                       OIQSHP        4    100
     O                       OIQORD        4     90
     O          E            TLRN        2  1
     O                                           55 '**** There Are No Transa'
     O                                           78 'ctions For The Report S'
     O                                           92 'elections ****'
      *
