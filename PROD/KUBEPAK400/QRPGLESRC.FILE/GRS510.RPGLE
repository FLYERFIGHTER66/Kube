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
      **PROGRAM NAME-------- GRS510  -  WEEKLY PRODUCTION LIST
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
     FFDLOTLOC  IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FGRS510    O    F  132        PRINTER OFLIND(*INOF)
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
     D  LPRODT                 1      6  0
     D  LLOC                   7      9
     D  LSUM                  17     17
     D  LJOBQ                 18     18
     D  LFORM                 19     28
     D  LP1COP                29     30  0
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     1             LOC               3 0
     C                   Z-ADD     *ZEROS        KEY               2 0
     C     KEY           CHAIN     FMCOMP                             88
      *
     C     LPRODT        MULT      10000.01      PDATE             6 0
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      RDLOT                                  77
     C   77              GOTO      END
      *
     C     LDSOWD        MULT      100.0001      PRODTE            6 0
     C     LDCRDY        MULT      100.0001      SHPDTE            6 0
      *
     C     LDSOWD        IFNE      PDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LLOC          IFGT      *BLANKS
     C     LDGLOC        ANDNE     LLOC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   55LDGLOC        IFNE      SAVLOC
     C                   EXCEPT    TL1
     C                   Z-ADD     1             LOC
     C                   ENDIF
      *
     C     ITMKEY        KLIST
     C                   KFLD                    LDITEM
     C                   KFLD                    LDSIZE
     C     ITMKEY        CHAIN     FMINVT                             60
      *
     C                   MOVE      IMDES1        DESA             30
     C                   MOVE      IMDES2        DESB             30
     C     DESA          CAT       DESB:1        DES1             60
     C                   MOVE      IMDES3        DESC             30
     C                   MOVE      IMDES4        DESD             30
     C     DESC          CAT       DESD:1        DES2             60
     C     DES1          CAT       DES2:1        DESCP            50
     C     NOCHG         TAG
      *
     C                   ADD       LDQTOH        TLQTOH           12 1
     C                   ADD       LDSOWN        TLQSOW           12 1
      *
     C                   MOVEL     LDGLOC        SAVLOC            3
     C     LOC           IFEQ      1
     C                   SETON                                        50
     C                   ENDIF
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DTL1
     C                   SETON                                        55
     C                   ADD       1             LOC               3 0
     C                   SETOFF                                       50
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TL1
     C                   SETON                                        LR
      *
     OGRS510    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       MCNAME              75
     O                                          114 'Page'
     O                       PAGE          1    120
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           62 'Weekly Product'
     O                                           70 'ion List'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                            4 'Prod'
     O                                           23 'Pr'
     O                                           25 'P'
     O                                           86 'Prodn'
     O                                           97 'Qty'
     O                                          107 'Qty'
     O                                          120 'Ready'
     O          E            HDG            1
     O                                            4 'Loc'
     O                                           10 'Item'
     O                                           20 'Size'
     O                                           23 'Cl'
     O                                           25 'H'
     O                                           45 'Description'
     O                                           86 'Date'
     O                                           98 'Sown'
     O                                          108 'Avail'
     O                                          120 'Date'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DTL1           1
     O                       SHPDTE        Y    120
     O                       LDQTOH        J    109
     O                       LDSOWN        J     99
     O               50      PRODTE        Y     86
     O                       DESCP               76
     O                       LDPHYT              25
     O                       LDPRCL              23
     O                       LDSIZE              20
     O                       LDITEM              16
     O               50      LDGLOC               3
     O          E            TL1            1
     O                                          109 '---------'
     O                                           99 '---------'
     O          E            TL1            2
     O                                           85 'Location Totals ====>'
     O                       TLQTOH        JB   109
     O                       TLQSOW        JB    99
