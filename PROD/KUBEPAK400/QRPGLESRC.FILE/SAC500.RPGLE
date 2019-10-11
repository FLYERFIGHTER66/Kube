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
      *PROGRAM NAME-------- SAC500
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- SALES ANALYSIS BY CUSTOMER - COMPARATIVE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMAPER    IF   E           K DISK
     FSAC500FM  CF   E             WORKSTN
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
     D  LGRPRO                 6      6
     D  LDORP                  7      7
     D  LBTYP                  8      9
     D  LETYP                 10     11
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
     C                   MOVEL     'N'           LGRPRO
     C                   MOVEL     'Y'           LACTIV
     C                   MOVEL     *BLANKS       LDORP
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101112
     C                   SETOFF                                       203031
     C                   SETOFF                                       324041
     C                   SETOFF                                       425060
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C                   MOVEL     *BLANKS       LCANCL
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
     C   10
     CAN 11              GOTO      NXTA
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C     ACST13        IFEQ      *ZEROS                                                   K
     C     VACTP         ANDEQ     13                                                       K
     C                   SETON                                        1012
     C   12              GOTO      NXTA
     C                   ENDIF
      *
     C     LDORP         IFNE      '$'                                                      K
     C     LDORP         ANDNE     '%'                                                      K
     C                   SETON                                        4041
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LBTYP         IFEQ      *BLANKS
     C     LETYP         ANDEQ     *BLANKS
     C                   GOTO      NOTYP
     C                   ENDIF
      *
     C     LETYP         IFEQ      *BLANKS
     C     LBTYP         ANDGT     *BLANKS
     C                   MOVEL     LBTYP         LETYP
     C                   ENDIF
      *
     C     LBTYP         IFGT      LETYP
     C                   SETON                                        50
     C   50              GOTO      NXTA
     C                   ENDIF
     C     NOTYP         TAG
      *
     C     LACTIV        IFNE      'Y'                                                      K
     C     LACTIV        ANDNE     'N'                                                      K
     C                   SETON                                        60
     C   60              GOTO      NXTA
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
