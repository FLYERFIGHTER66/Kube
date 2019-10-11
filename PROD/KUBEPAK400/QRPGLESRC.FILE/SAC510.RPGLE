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
      *PROGRAM NAME-------- SAC510
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- SALES ANALYSIS BY ITEM - COMPARATIVE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMAPER    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FSAC510FM  CF   E             WORKSTN
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
     D  LBPC                   8      9
     D  LEPC                  10     11
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
     C                   MOVEL     'Y'           LACTIV
     C                   MOVEL     *BLANKS       LDORP
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
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LBPC          IFEQ      *BLANKS
     C     LEPC          ANDEQ     *BLANKS
     C                   GOTO      NOPC
     C                   ENDIF
      *
     C     1             SUBST     LBPC:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LBPC          VPRCL             2
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         LBPC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     1             SUBST     LEPC:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LEPC          VPRCL
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         LEPC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LBPC          CHAIN     FMPRCL                             90
     C   90              SETON                                        30
     C   30              GOTO      NXTA
      *
     C     LBPC          IFGT      *BLANKS
     C     LEPC          ANDEQ     *BLANKS
     C                   MOVEL     LBPC          LEPC
     C                   ENDIF
      *
     C     LEPC          CHAIN     FMPRCL                             90
     C   90              SETON                                        35
     C   35              GOTO      NXTA
      *
     C     LBPC          IFGT      LEPC                                                     K
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     NOPC          TAG
      *
     C     LACTIV        IFNE      'Y'                                                      K
     C     LACTIV        ANDNE     'N'                                                      K
     C                   SETON                                        40
     C   40              GOTO      NXTA
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      *********
      * PCSR
      *********
     C     PCSR          BEGSR
     C                   MOVEL     VPRCL         PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VPRCL
     C                   MOVEL     PCPRCL        VPRCL
     C                   MOVEL     PCDESC        VDESC            30
     C                   ENDSR
      *
