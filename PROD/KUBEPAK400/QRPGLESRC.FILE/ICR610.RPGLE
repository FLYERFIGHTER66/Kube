      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.,  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ICR610
      *SYSTEM-------------- INVENTORY
      *APPLICATION--------- PHYSICAL TO BOOK COMPARISON
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMINVT    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FICR610    O    F  120        PRINTER OFLIND(*INOF)
     F                                     FORMLEN(088)
     F                                     FORMOFL(082)
      *
      *
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
     D  LBCODE                 3      4
     D  LECODE                 5      6
     D  LBLOC                  7      9
     D  LELOC                 10     12
     D  LBLIST                13     16
     D  LELIST                17     20
     D  LBPC                  21     22
     D  LEPC                  23     24
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
      *
     C     LBCODE        IFGT      *BLANKS
     C                   SETON                                        01
     C                   ENDIF
      *
     C     LBLOC         IFGT      *BLANKS
     C     LELOC         ORGT      *BLANKS
     C                   SETON                                        02
     C                   ENDIF
      *
     C     LBLIST        IFGT      *BLANKS
     C                   SETON                                        03
     C                   ENDIF
      *
     C     LBPC          IFGT      *BLANKS
     C                   SETON                                        04
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   Z-ADD     0             DIFF1
     C                   Z-ADD     0             DIFF
     C                   READ      FMINVT                                 90
     C   90              GOTO      END
      *
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     IMLOTC        IFEQ      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   01IMCYCD        IFLT      LBCODE                                                      ARC38
     C     IMCYCD        ORGT      LECODE                                                      ARC38
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   02IMWHSE        IFLT      LBLOC                                                       ARC38
     C     IMWHSE        ORGT      LELOC                                                       ARC38
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   03IMLIST        IFLT      LBLIST
     C     IMLIST        ORGT      LELIST
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   04IMPCL1        IFLT      LBPC
     C     IMPCL1        ORGT      LEPC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   EXSR      GETDES
      *
     C     IMQTOH        SUB       IMQPHY        DIFF1            10 05251
      *
     C                   Z-SUB     DIFF1         DIFF             10 0
      *
     C     IMQTOH        MULT(H)   IMUCST        OHCST             9 2
     C     IMQPHY        MULT(H)   IMUCST        PHCST             9 2
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
      *
     C                   Z-ADD     IMQTOH        DQTOH            10 0
     C                   Z-ADD     IMQPHY        DQPHY            10 0
      *
     C                   EXCEPT    DETL
      *
     C                   ADD       IMQTOH        QTOH             11 0
     C                   ADD       IMQPHY        QPHY             11 0
     C                   ADD       OHCST         TOHCST           11 2
     C                   ADD       PHCST         TPHCST           11 2
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
      *********
      * GETDES
      *********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP             30
     C                   ENDSR
      *
     OICR610    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                                          114 'Page'
     O                       PAGE          1    120
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           57 'Physical To Book'
     O                                           78 'Inventory Comparison'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O               02                           9 'Location:'
     O               02      LBLOC               13
     O               02                          15 '-'
     O               02      LELOC               19
     O               01                          51 'Cycle Cd:'
     O               01      LBCODE              54
     O               01                          56 '-'
     O               01      LECODE              59
     O               03                          74 'List Cd:'
     O               03      LBLIST              79
     O               03                          81 '-'
     O               03      LELIST              85
     O               04                         112 'PC:'
     O               04      LBPC               115
     O               04                         117 '-'
     O               04      LEPC               120
     O          E            HDG            1
     O                                            4 'Item'
     O                                           33 'Description'
     O                                           50 'U/M'
     O                                           58 'On'
     O                                           82 'Physical'
     O                                          101 'Diff'
     O          E            HDG            0
     O                                           59 'Hand'
     O                                           70 'Cost'
     O                                           81 'Count'
     O                                           93 'Cost'
     O                                          101 '+or-'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       DIFF          J    102
     O                       PHCST         J     94
     O                       DQPHY         J     82
     O                       OHCST         J     72
     O                       DQTOH         J     60
     O                       IMITEM              12
     O                       IMSIZE              16
     O                       DESP                47
     O                       IMPUOM              50
     O               51                         120 'Phys > Than Book'
     O               52                         120 'Book > Than Phys'
     O          E            TLR            1
     O                                           40 'Report Totals:'
     O                       QTOH          J     60
     O                       QPHY          J     82
     O          E            TLR            1
     O                       TPHCST        J     94
     O                       TOHCST        J     72
