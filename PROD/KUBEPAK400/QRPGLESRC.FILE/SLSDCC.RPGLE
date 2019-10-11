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
      *PROGRAM NAME-------- SLSDCC
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- CUSTOMER SALES/OPEN ORDERS PROMPT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMPRCL    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FSLSDECFM  CF   E             WORKSTN
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
     D  LBMTHY                 3      6  0
     D  LEMTHY                 7     10  0
     D  LBPC                  11     12
     D  LEPC                  13     14
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
     C                   Z-ADD     0             LBMTHY
     C                   Z-ADD     0             LEMTHY
      *
     C     LCO           CHAIN     FMAPER                             90
     C                   MOVEL     ACST01        BMM               2 0          040199 04   K
     C                   MOVE      ACST01        BYY               2 0          040199 99   K
     C     BYY           IFLT      70
     C     BYY           ADD       100           CBYY              3 0          100
     C                   ELSE
     C                   Z-ADD     BYY           CBYY                            99
     C                   ENDIF
     C     CBYY          SUB       1             CBLYY             3 0          PRIOR YR
     C                   MOVEL     CBLYY         BPYR                           BEG PR YR
     C                   MOVE      BMM           BPYR              5 0          9904
      *
     C                   MOVEL     ACST12        EMM               2 0          033100 03   K
     C                   MOVE      ACST12        EYY               2 0          033100 00   K
     C     EYY           IFLT      70
     C     EYY           ADD       100           CEYY              3 0          100
     C                   ELSE
     C                   Z-ADD     EYY           CEYY                            99
     C                   ENDIF
     C                   MOVEL     CEYY          ECYR                           END CUR UR
     C                   MOVE      EMM           ECYR              5 0
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101214
     C                   SETOFF                                       203040
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              GOTO      END
      *
     C     LBMTHY        IFEQ      0
     C                   SETON                                        10
     C   10              GOTO      NXTA
     C                   ENDIF
      *
     C                   MOVEL     LBMTHY        BMTH              2 0
     C                   MOVE      LBMTHY        BYR               2 0
     C     BYR           IFLT      70
     C     BYR           ADD       100           CBYR              3 0
     C                   ELSE
     C                   Z-ADD     BYR           CBYR
     C                   ENDIF
     C                   MOVEL     CBYR          BDTE                           9803
     C                   MOVE      BMTH          BDTE              5 0
      *
     C     BDTE          IFLT      BPYR                                         9804
     C     BDTE          ORGT      ECYR                                         10003
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LEMTHY        IFEQ      0
     C                   SETON                                        20
     C   20              GOTO      NXTA
     C                   ENDIF
      *
     C                   MOVEL     LEMTHY        EMTH              2 0
     C                   MOVE      LEMTHY        EYR               2 0
     C     EYR           IFLT      70
     C     EYR           ADD       100           CEYR              3 0
     C                   ELSE
     C                   Z-ADD     EYR           CEYR
     C                   ENDIF
     C                   MOVEL     CEYR          EDTE                           100
     C                   MOVE      EMTH          EDTE              5 0          10005
      *
     C     EDTE          IFLT      BPYR                                         9804
     C     EDTE          ORGT      ECYR                                         10003
     C                   SETON                                        20
     C   20              GOTO      NXTA
     C                   ENDIF
      *
     C     BDTE          IFGT      EDTE
     C                   SETON                                        1014
     C   14              GOTO      NXTA
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
     C     LBPC          IFGT      *BLANKS
     C     LEPC          ANDEQ     *BLANKS
     C                   MOVEL     LBPC          LEPC
     C                   ENDIF
      *
     C     LBPC          CHAIN     FMPRCL                             90
     C   90              SETON                                        30
     C   30              GOTO      NXTA
      *
     C     LEPC          CHAIN     FMPRCL                             90
     C   90              SETON                                        40
     C   40              GOTO      NXTA
      *
     C     LBPC          IFGT      LEPC
     C                   SETON                                        30
     C   30              GOTO      NXTA
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
