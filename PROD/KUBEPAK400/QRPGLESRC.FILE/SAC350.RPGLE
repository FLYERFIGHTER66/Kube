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
      *PROGRAM NAME-------- SAC350
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- SALES ANALYSIS BY SALESPERSON
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMAPER    IF   E           K DISK
     FSAC350FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
     D                UDS
     D  LCO                    1      2  0
     D  LMONTH                 3      4  0
     D  LDOLUN                 5      5  0
     D  LGRPRO                 6      6
     D  LDORP                  7      7
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
     C                   MOVEL     'N'           LGRPRO
     C                   MOVEL     *BLANKS       LDORP
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101112
     C                   SETOFF                                       203031
     C                   SETOFF                                       324041
     C                   SETOFF                                       42
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
     C                   Z-ADD     VACTP         LMONTH
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
     C   12              GOTO      NXTA
     C                   ENDIF
      *
     C     LDOLUN        IFLT      1                                                        K
     C     LDOLUN        ORGT      3                                                        K
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LDOLUN        IFNE      1                                                        K
     C     LGRPRO        ANDEQ     'Y'                                                      K
     C                   SETON                                        3032
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LGRPRO        IFNE      'Y'                                                      K
     C     LGRPRO        ANDNE     'N'                                                      K
     C                   SETON                                        3031
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LGRPRO        IFEQ      'Y'                                                      K
     C     LDORP         ANDNE     '$'                                                      K
     C     LDORP         ANDNE     '%'                                                      K
     C                   SETON                                        4041
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LGRPRO        IFEQ      'N'                                                      K
     C     LDORP         ANDGT     *BLANKS                                                  K
     C                   SETON                                        4042
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      *
