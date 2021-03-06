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
      *PROGRAM NAME-------- GLC800
      *SYSTEM-------------- GENERAL LEDGER
      *DESCRIPTION--------- BUDGET WORKSHEET
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FGLC800FM  CF   E             WORKSTN
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
     D  LBUDG                  3      3
     D  LALL                   4      4
     D  LREV                   5      5
     D  LEXP                   6      6
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
      * VALIDATE RESPONSES ON PROMPT SCREEN A
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102021
     C                   SETOFF                                       222330
     C                   SETOFF                                       405051
     C                   SETOFF                                       525354
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
     C     LBUDG         IFNE      'Y'
     C     LBUDG         ANDNE     'N'
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LALL          IFNE      'Y'
     C     LALL          ANDNE     'N'
     C                   SETON                                        2021
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LALL          IFEQ      'Y'
     C     LBUDG         ANDEQ     'Y'
     C                   SETON                                        2022
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LALL          IFEQ      'N'
     C     LBUDG         ANDEQ     'N'
     C                   SETON                                        2023
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LREV          IFNE      'Y'
     C     LREV          ANDNE     'N'
     C                   SETON                                        30
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LEXP          IFNE      'Y'
     C     LEXP          ANDNE     'N'
     C                   SETON                                        40
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      RSTRT
     C                   ENDIF
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
     C     ENDP          TAG
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
     C                   Z-ADD     1             VOUT
      *
     C                   MOVEL     'Y'           LBUDG
     C                   MOVEL     'N'           LALL
     C                   MOVEL     'Y'           LREV
     C                   MOVEL     'Y'           LEXP
      *
     C                   ENDSR
