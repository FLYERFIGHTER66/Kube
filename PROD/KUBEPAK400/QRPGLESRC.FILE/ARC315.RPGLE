      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
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
      *PROGRAM NAME-------- ARC315
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- TAXES BY TAX JURISDICTION
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMTAXF    IF   E           K DISK
     FARC315FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     D  LCO                    1      2  0
     D  LMONTH                 3      4  0
     D  LYEAR                  5      8  0
     D  LSUMM                  9      9
     D  LTAXJ                 10     12
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
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   SETOFF                                       354050
     C                   SETOFF                                       515253
     C                   SETOFF                                       54
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C     LMONTH        IFLE      0
     C     LMONTH        ORGT      12
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LMONTH        IFNE      OMONTH
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LMONTH        OMONTH            2 0
      *
     C     LYEAR         IFLE      1997
     C     LYEAR         ORGT      2025
     C                   SETON                                        20
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LYEAR         IFNE      OYEAR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LYEAR         OYEAR             4 0
      *
     C     LSUMM         IFNE      'D'
     C     LSUMM         ANDNE     'S'
     C                   SETON                                        30
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LSUMM         IFNE      OSUMM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LSUMM         OSUMM             1
      *
     C     LSUMM         IFEQ      'D'
     C                   SETON                                        35
     C                   ENDIF
      *
     C     1             SUBST     LTAXJ:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LTAXJ         TXTXJU            3
     C                   CALL      'LKTAXJ'
     C                   PARM                    TXTXJU
     C                   PARM                    TXJUNM           30
     C                   MOVEL     *BLANKS       LTAXJ
     C                   MOVEL     TXTXJU        LTAXJ
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C   35LTAXJ         CHAIN     FMTAXF                             90
     C   35
     CAN 90              SETON                                        40
     C   40              GOTO      RSTRT
      *
     C     LTAXJ         IFNE      OTAXJ
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LTAXJ         OTAXJ             3
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LCOPY         IFNE      OCOPY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LCOPY         OCOPY             2 0
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        53
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LJOBQ         IFNE      OJOBQ
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LJOBQ         OJOBQ             1
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     VOUT          IFNE      OOUT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VOUT          OOUT              1 0
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
     C     CNT           IFGT      0
     C                   SETON                                        98
     C   98              GOTO      RSTRT
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   SETOFF                                       98
     C                   Z-ADD     0             LMONTH
     C                   Z-ADD     0             LYEAR
     C                   Z-ADD     1             VOUT
     C                   ENDSR
      *
