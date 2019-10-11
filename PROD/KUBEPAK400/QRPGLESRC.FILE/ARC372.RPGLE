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
      *PROGRAM NAME-------- ARC370
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- EXCEEDED CREDIT LIMIT PROMPT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMTERM    IF   E           K DISK
     FARC372FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     D  LCRED                  3      3  0
     D  LINCL                  4      4  0
     D  LBTERM                 5      6
     D  LETERM                 7      8
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
     C                   SETOFF                                       405051
     C                   SETOFF                                       525354
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C     LCRED         IFLE      0                                                        Q
     C     LCRED         ORGT      2
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LCRED         IFNE      OCRED
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LCRED         OCRED             1 0
      *
     C     LINCL         IFLE      0                                                        Q
     C     LINCL         ORGT      2
     C                   SETON                                        20
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LINCL         IFNE      OINCL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LINCL         OINCL             1 0
      *
     C     LBTERM        IFEQ      *BLANKS                                                  K
     C     LETERM        ANDEQ     *BLANKS                                                  K
     C                   GOTO      NOTERM
     C                   ENDIF
      *
     C     1             SUBST     LBTERM:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LBTERM        TCTERM
     C                   CALL      'LKTERM'
     C                   PARM                    TCTERM
     C                   PARM                    TCDESC
     C                   MOVEL     *BLANKS       LBTERM
     C                   MOVEL     TCTERM        LBTERM
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     1             SUBST     LETERM:1      VTST1             1
     C     VTST1         IFEQ      '?'
     C     VTST1         OREQ      '/'
     C                   MOVEL     LETERM        TCTERM
     C                   CALL      'LKTERM'
     C                   PARM                    TCTERM
     C                   PARM                    TCDESC
     C                   MOVEL     *BLANKS       LETERM
     C                   MOVEL     TCTERM        LETERM
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LBTERM        IFEQ      *BLANKS                                                  K
     C     LETERM        ANDGT     *BLANKS                                                  K
     C                   SETON                                        30
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LBTERM        IFGT      *BLANKS                                                  K
     C     LETERM        ANDEQ     *BLANKS                                                  K
     C                   MOVEL     LBTERM        LETERM                                     K
     C                   ENDIF
      *
     C     LBTERM        IFGT      LETERM                                                   K
     C                   SETON                                        30
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LBTERM        CHAIN     FMTERM                             91
     C   91              SETON                                        30
     C   30              GOTO      RSTRT
      *
     C     LETERM        CHAIN     FMTERM                             92
     C   92              SETON                                        40
     C   40              GOTO      RSTRT
      *
     C     LBTERM        IFNE      OBTERM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBTERM        OBTERM            2
      *
     C     LETERM        IFNE      OETERM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LETERM        OETERM            2
      *
     C     NOTERM        TAG
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
     C                   MOVEL     LFORM         OFORM             4
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      RSTRT
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
     C                   GOTO      RSTRT
     C                   ENDIF
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
     C   98              GOTO      RSTRT
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      **
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     0             LCRED
     C                   Z-ADD     0             LINCL
     C                   MOVEL     *BLANKS       LBTERM
     C                   MOVEL     *BLANKS       LETERM
     C                   Z-ADD     1             VOUT
      *
     C                   ENDSR
