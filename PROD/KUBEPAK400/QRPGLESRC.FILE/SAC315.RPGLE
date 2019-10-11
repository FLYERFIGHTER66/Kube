      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1997
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
      **PROGRAM NAME-------- SAC315
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS TAXES BY TAX JURISDICTION
      **PROGRAMMER---------- GD
      **APPLICATION--------- TAXES BY TAX JURISDICTION
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FSAC315FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     D  LMONTH                 1      2  0
     D  LYEAR                  3      6  0
     D  LCO                    7      8  0
     D  LPRTR                100    109
     D  LFORM                110    113
     D  LCOPY                114    115  0
     D  LHOLD                116    119
     D  LSAVE                120    123
     D  LCANCL               133    133
      *
     C                   Z-ADD     01            VCO
     C                   MOVEL     '*NAR'        VFORMS
     C                   Z-ADD     01            VCOPY
     C                   Z-ADD     1             VOUT
     C                   MOVEL     LPRTR         VPRTR
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101520
     C                   SETOFF                                       304052
     C                   SETOFF                                       54
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C                   MOVEL     *BLANKS       LCANCL
      *
     C                   Z-ADD     VMONTH        LMONTH
     C                   Z-ADD     VYEAR         LYEAR
     C                   Z-ADD     VCO           LCO
     C                   MOVEL     VFORMS        LFORM
     C                   Z-ADD     VCOPY         LCOPY
     C                   MOVEL     VPRTR         LPRTR
      *
     C     VMONTH        IFLE      *ZEROS                                                   K
     C     VMONTH        ORGT      12                                                       K
     C                   SETON                                        10
     C   10              GOTO      NXTA
     C                   ENDIF
      *
     C     VYEAR         IFLT      1998                                                     K
     C                   SETON                                        20
     C   20              GOTO      NXTA
     C                   ENDIF
      *
     C     VFORMS        IFEQ      *BLANKS                                                  K
     C                   SETON                                        30
     C   30              GOTO      NXTA
     C                   ENDIF
      *
     C     VCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        40
     C   40              GOTO      NXTA
     C                   ENDIF
      *
     C     VPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        52
     C   52              GOTO      NXTA
     C                   ENDIF
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C   54              GOTO      NXTA
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
      *
     C     END           TAG
     C                   SETON                                        LR
      *
