      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      *PROGRAM NAME--------- CUC650
      *APPLICATION---------- CUTTING REQUIREMENTS
CAB   *DESCRIPTION----------CUT TRAY CHANGE REPORT
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FCUC650FM  CF   E             WORKSTN
     FFCALEN    IF   E           K DISK
WJB  FFMVEND    IF   E           K DISK
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
     D                UDS
      ** COMPANY NUMBER
     D  LCO                    1      2  0
      ** BEGIN READY DATE
     D  BEGDAT                 3      8  0                                      ARC380
      ** END READY DATE
     D  ENDDAT                 9     14  0                                      ARC380
      ** BEGIN READY DATE CYMD
     D  BEGCYM                15     21  0
      ** ENDING READY DATE CYMD
     D  ENDCYM                22     28  0
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
WJB  D  Vendor         S                   Like(VMVEND)
      *
WJB  C     *Entry        PList
WJB  C                   Parm                    Vendor
WJB  C     Vendor        Chain     FMVEND
     C     RSTART        TAG
     C                   Z-ADD     0             BEGDAT
     C                   Z-ADD     0             BEGCYM
     C                   Z-ADD     0             ENDDAT
     C                   Z-ADD     0             ENDCYM
     C                   Z-ADD     0             OBEG              6 0
     C                   Z-ADD     0             OEND              6 0
     C                   MOVEL     'XERPRT01'    LPRTR
     C                   MOVEL     '*NAR'        LFORM
     C                   MOVEL     'N'           LJOBQ
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     1             LCOPY
     C                   SETOFF                                       103938
     C                   SETOFF                                       303135
     C                   SETOFF                                       404145
     C                   SETOFF                                       489899
     C                   SETOFF                                       525354
      *
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       103938
     C                   SETOFF                                       303135
     C                   SETOFF                                       215051
     C                   SETOFF                                       404145
     C                   SETOFF                                       48  99
     C                   SETOFF                                       525354
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
      * CHECK FOR BEGINING DATE
     C     BEGDAT        IFGT      0
     C     BEGDAT        CHAIN     FCALEN                             30
     C   30              DO
     C                   SETON                                        99
     C                   Z-ADD     0             BEGCYM
     C                   GOTO      NXTA
     C                   ENDDO                                                  30 DO
     C                   Z-ADD     CLCYMD        BEGCYM
     C                   ELSE
     C                   SETON                                        3099
     C                   GOTO      NXTA
     C                   END                                                    BEGDAT>0
      *
      *
      * CHECK FOR END DATE
     C     ENDDAT        IFGT      0
     C     ENDDAT        CHAIN     FCALEN                             40
     C   40              DO
     C                   SETON                                        99
     C                   Z-ADD     0             ENDCYM
     C                   GOTO      NXTA
     C                   ENDDO                                                  40 DO
     C                   Z-ADD     CLCYMD        ENDCYM
     C                   ELSE
     C                   Z-ADD     BEGDAT        ENDDAT
     C                   Z-ADD     BEGCYM        ENDCYM
     C                   END                                                    ENDDAT>0
     C     ENDCYM        IFLT      BEGCYM
     C                   SETON                                        3999
     C                   GOTO      NXTA
     C                   END
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        5099
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        5199
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        5299
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        5399
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        5499
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VOUT          IFEQ      1
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*NO '        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      2
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      3
     C                   MOVEL     '*YES'        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      ** REDISPLAY
     C     BEGDAT        IFNE      OBEG
     C     ENDDAT        ORNE      OEND
     C                   SETOFF                                       98
     C                   Z-ADD     BEGDAT        OBEG
     C                   Z-ADD     ENDDAT        OEND
     C                   ENDIF
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA
     C                   ENDDO                                                  N98 DO
      *
     C     END           TAG
     C                   SETON                                        LR
      **
