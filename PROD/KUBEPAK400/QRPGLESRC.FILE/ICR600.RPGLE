      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.        1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ICR600
      *APPLICATION--------- INVENTORY
      *DESCRIPTION--------- PRINT PHYSICAL COUNT SHEETS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMINVT    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FICR600    O    F  120        PRINTER OFLIND(*INOF)
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
     C     LBCODE        IFGT      *BLANKS
     C                   SETON                                        20
     C                   ENDIF
      *
     C     LBLOC         IFGT      *BLANKS
     C     LELOC         ORGT      *BLANKS
     C                   SETON                                        21
     C                   ENDIF
      *
     C     LBLIST        IFGT      *BLANKS
     C                   SETON                                        22
     C                   ENDIF
      *
     C     LBPC          IFGT      *BLANKS
     C                   SETON                                        23
     C                   ENDIF
      *
     C     LCO           CHAIN     FMCORG                             88
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
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
     C   20IMCYCD        IFLT      LBCODE                                                      ARC38
     C     IMCYCD        ORGT      LECODE                                                      ARC38
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   21IMWHSE        IFLT      LBLOC                                                       ARC38
     C     IMWHSE        ORGT      LELOC                                                       ARC38
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   22IMLIST        IFLT      LBLIST
     C     IMLIST        ORGT      LELIST
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   23IMPCL1        IFLT      LBPC
     C     IMPCL1        ORGT      LEPC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   EXSR      GETDES
      *
     C   OF              EXCEPT    HDG
     C                   EXCEPT    DETL
      *
     C                   GOTO      NXT
      *
     C     END           TAG
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
     C                   MOVEL     DESCO         DESP             40
     C                   ENDSR
     OICR600    E            HDG            1 03
     O                       PROGID              10
     O                                           25 'Requested by:'
     O                       USERID              36
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           62 'Physical Inventory'
     O                                           75 'Count Sheets'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O               21                           9 'Location:'
     O               21      LBLOC               13
     O               21                          15 '-'
     O               21      LELOC               19
     O               20                          51 'Cycle Cd:'
     O               20      LBCODE              54
     O               20                          56 '-'
     O               20      LECODE              59
     O               22                          74 'List Cd:'
     O               22      LBLIST              79
     O               22                          81 '-'
     O               22      LELIST              85
     O               23                         112 'PC:'
     O               23      LBPC               115
     O               23                         117 '-'
     O               23      LEPC               120
     O          E            HDG            0
     O                                            5 'Bin'
     O                                           11 'Item'
     O                                           23 'Size'
     O                                           27 'Loc'
     O                                           50 'Description'
     O                                           72 'U/M'
     O                                           89 'Count'
     O                                          120 'Counted By'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL        1  1
     O                       IMBIN#               6
     O                       IMITEM              19
     O                       IMSIZE              23
     O                       IMWHSE              27
     O                       DESP                68
     O                       IMPUOM              72
     O                                           89 '__________'
     O                                          120 '__________'
