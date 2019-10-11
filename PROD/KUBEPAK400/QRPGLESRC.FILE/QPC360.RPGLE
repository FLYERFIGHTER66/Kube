      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      *PROGRAM NAME-------- QPC360
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- SALES ANALYSIS BY TOP RANKED CUSTOMER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMPRCL    IF   E           K DISK
     FQPK360FM  CF   E             WORKSTN
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
     D  BEGPER                 3      4  0
     D  ENDPER                 5      6  0
     D  NUMCUS                 7     10  0
     D  BEGPC                 11     12
     D  ENDPC                 13     14
     D  RANK                  15     15  0
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
      *
     C                   Z-ADD     0             BEGPER
     C                   Z-ADD     0             ENDPER
     C                   MOVE      *BLANKS       BEGPC
     C                   MOVE      *BLANKS       ENDPC
     C                   Z-ADD     25            NUMCUS
     C                   Z-ADD     1             RANK
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101112
     C                   SETOFF                                       1320
     C                   SETOFF                                       212225
     C                   SETOFF                                       304045
     C                   SETOFF                                       505152
     C                   SETOFF                                       53
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              DO
     C                   MOVE      'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
      *
     C     BEGPER        IFEQ      0                                                        K
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     ENDPER        IFEQ      0                                                        K
     C                   Z-ADD     BEGPER        ENDPER
     C                   ENDIF
      *
     C     ENDPER        IFGT      12                                                       K
     C                   SETON                                        11
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     BEGPER        IFGT      ENDPER                                                   K
     C                   SETON                                        1013
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     1             SUBST     BEGPC:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     BEGPC         VPRCL             2
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         BEGPC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     1             SUBST     ENDPC:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     ENDPC         VPRCL
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         ENDPC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     BEGPC         IFEQ      *BLANKS
     C     ENDPC         ANDEQ     *BLANKS
     C                   GOTO      NOPC
     C                   ENDIF
      *
     C     BEGPC         CHAIN     FMPRCL                             91
     C   91              SETON                                        2022
     C   22              GOTO      NXTA
      *
     C     BEGPC         IFGT      *BLANKS
     C     ENDPC         ANDEQ     *BLANKS
     C                   MOVEL     BEGPC         ENDPC
     C                   ENDIF
      *
     C     ENDPC         CHAIN     FMPRCL                             91
     C   91              SETON                                        25
     C   25              GOTO      NXTA
      *
     C     BEGPC         IFGT      ENDPC
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   ENDIF
     C     NOPC          TAG
      *
     C     NUMCUS        IFEQ      0
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     RANK          IFEQ      0
     C     RANK          ORGT      2
     C                   SETON                                        45
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     BEGPER        IFNE      OBEGP
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     BEGPER        OBEGP             2 0
     C     ENDPER        IFNE      OENDP
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     ENDPER        OENDP             2 0
     C     BEGPC         IFNE      OBEGPC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     BEGPC         OBEGPC            2
     C     ENDPC         IFNE      OENDPC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     ENDPC         OENDPC            2
     C     NUMCUS        IFNE      OCUS
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     NUMCUS        OCUS              4 0
     C     RANK          IFNE      ORANK
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     RANK          ORANK             1 0
     C     CNT           IFGT      0
     C                   SETON                                        98
     C   98              GOTO      NXTA
     C                   ENDIF
      *
     C     END           TAG
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C                   SETON                                        LR
      *
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
