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
      *PROGRAM NAME-------- ARC380
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- CUSTOMER LABELS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMSLSM    IF   E           K DISK
     FFMTERR    IF   E           K DISK
     FARC380FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     D                UDS
     D  LCO                    1      2  0
     D  LSIZE                  3      3  0
     D  LSEQ                   4      4  0
     D  LBTYPE                 5      6
     D  LETYPE                 7      8
     D  LBZIP                  9     13  0
     D  LEZIP                 14     18  0
     D  LSLSM                 19     20
     D  LTERR                 21     22
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
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     0             LSIZE
     C                   Z-ADD     0             LSEQ
     C                   Z-ADD     0             LBZIP
     C                   Z-ADD     0             LEZIP
     C                   MOVEL     '*LABL'       LFORM
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102050
     C                   SETOFF                                       515253
     C                   SETOFF                                       54
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C   KE              GOTO      RSTRTB
      *
     C     LSIZE         IFLT      1                                                        K
     C     LSIZE         ORGT      3                                                        K
     C                   SETON                                        10
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LSIZE         IFNE      OSIZE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LSIZE         OSIZE             1 0
      *
     C     LSEQ          IFLT      1                                                        K
     C     LSEQ          ORGT      3                                                        K
     C                   SETON                                        20
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LSEQ          IFNE      OSEQ
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LSEQ          OSEQ              1 0
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      0                                                        OS
     C                   SETON                                        52
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LCOPY         IFNE      OCOPY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LCOPY         OCOPY             2 0
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        53
     C                   GOTO      RSTRTA
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
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VOUT          IFNE      OOUT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VOUT          OOUT              1 0
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
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C                   GOTO      END
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   SETOFF                                       40
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C   KB              GOTO      RSTRTA
      *
     C     LBTYPE        IFGT      *BLANKS                                                  Q
     C     LETYPE        ANDEQ     *BLANKS                                                  Q
     C                   MOVEL     LBTYPE        LETYPE
     C                   ENDIF
      *
     C     LBTYPE        IFGT      *BLANKS                                                  Q
     C     LBTYPE        ANDGT     LETYPE                                                   Q
     C                   SETON                                        10
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LBTYPE        IFNE      OBTYPE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBTYPE        OBTYPE            2
      *
     C     LETYPE        IFNE      OETYPE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LETYPE        OETYPE            2
      *
     C     LBZIP         IFGT      0                                                        Q
     C     LEZIP         ANDEQ     0                                                        Q
     C                   Z-ADD     LBZIP         LEZIP
     C                   ENDIF
      *
     C     LBZIP         IFGT      0                                                        Q
     C     LBZIP         ANDGT     LEZIP                                                    Q
     C                   SETON                                        20
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     1             SUBST     LSLSM:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LSLSM         SMSLSM            2
     C                   CALL      'LKSALE'
     C                   PARM                    SMSLSM
     C                   PARM                    SMNAME           30
     C                   MOVEL     *BLANKS       LSLSM
     C                   MOVEL     SMSLSM        LSLSM
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LSLSM         IFGT      *BLANKS
     C     LSLSM         CHAIN     FMSLSM                             90
     C   90              SETON                                        30
     C   30              GOTO      RSTRTB
     C                   END
      *
     C     LSLSM         IFNE      OSLSM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LSLSM         OSLSM             2
      *
     C                   MOVEL     LTERR         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     LTERR         TETERR            2
     C                   CALL      'LKTERR'
     C                   PARM                    TETERR
     C                   PARM                    TEDESC           30
     C                   MOVEL     *BLANKS       LTERR
     C                   MOVEL     TETERR        LTERR
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LTERR         IFGT      *BLANKS
     C     LTERR         CHAIN     FMTERR                             96
     C   96              SETON                                        40
     C   40              GOTO      RSTRTB
     C                   END
      *
     C     LTERR         IFNE      OTERR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LTERR         OTERR             2
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      **
