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
      *PROGRAM NAME-------- SAC440
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- SALES ANALYSIS BY TERRITORY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMAPER    IF   E           K DISK
     FFMTERR    IF   E           K DISK
     FSAC360FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     D                UDS
     D  LCO                    1      2  0
     D  LMONTH                 3      4  0
     D  LDOLUN                 5      5  0
     D  LBTER                  8      9
     D  LETER                 10     11
     D  LACTIV                12     12
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
     C                   SETOFF                                       98
     C                   Z-ADD     3             LDOLUN
     C                   MOVEL     'Y'           LACTIV
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101112
     C                   SETOFF                                       203035
     C                   SETOFF                                       40
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C   KB              DO
     C                   Z-ADD     LCO           ACCOMP            2 0
     C                   CALL      'LKACTP'
     C                   PARM                    ACCOMP
     C                   PARM                    VACTP
     C                   GOTO      NXTA
     C                   ENDDO
      *
     C     VACTP         IFLE      *ZEROS                                                   K
     C     VACTP         ORGT      13                                                       K
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C     ACST13        IFEQ      *ZEROS                                                   K
     C     VACTP         ANDEQ     13                                                       K
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LDOLUN        IFLT      1                                                        K
     C     LDOLUN        ORGT      3                                                        K
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LBTER         IFEQ      *BLANKS
     C     LETER         ANDEQ     *BLANKS
     C                   GOTO      NOTER
     C                   ENDIF
      *
     C     1             SUBST     LBTER:1       VFTST             1
     C     VFTST         IFEQ      '?'
     C     VFTST         OREQ      '/'
     C                   MOVEL     LBTER         VTER              2
     C                   EXSR      TERRLK
     C                   MOVEL     VTER          LBTER
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     1             SUBST     LETER:1       VTTST             1
     C     VTTST         IFEQ      '?'
     C     VTTST         OREQ      '/'
     C                   MOVEL     LETER         VTER              2
     C                   EXSR      TERRLK
     C                   MOVEL     VTER          LETER
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LBTER         IFGT      *BLANKS                                                  K
     C     LBTER         CHAIN     FMTERR                             90                    K
     C   90              SETON                                        30
     C   30              GOTO      NXTA
     C                   ENDIF
      *
     C     LBTER         IFGT      *BLANKS                                                  K
     C     LETER         ANDEQ     *BLANKS                                                  K
     C                   MOVEL     LBTER         LETER
     C                   ENDIF
      *
     C     LETER         IFGT      *BLANKS                                                  K
     C     LETER         CHAIN     FMTERR                             90                    K
     C   90              SETON                                        35
     C   35              GOTO      NXTA
     C                   ENDIF
      *
     C     LBTER         IFGT      LETER                                                    K
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     NOTER         TAG
      *
     C                   Z-ADD     VACTP         LMONTH
      *
     C     LACTIV        IFNE      'Y'                                                      K
     C     LACTIV        ANDNE     'N'                                                      K
     C                   SETON                                        40
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      *********
      * TERRLK
      *********
     C     TERRLK        BEGSR
     C                   CALL      'LKTERR'
     C                   PARM                    TETERR
     C                   PARM                    TEDESC           30
     C                   MOVEL     *BLANKS       VTER              2
     C                   MOVEL     TETERR        VTER
     C                   MOVEL     TEDESC        SNAME            30
     C                   ENDSR
      **
