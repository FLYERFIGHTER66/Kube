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
      *PROGRAM NAME-------- SAC410
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- SALES ANALYSIS BY PRODUCT CLASS SUMMARY
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMAPER    IF   E           K DISK
     FSAC410FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
     D                UDS
     D  LCO                    1      2  0
     D  LMONTH                 3      4  0
     D  LDOLUN                 5      5  0
     D  LDORP                  6      6
     D  LGROSS                 7      7
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
     C                   Z-ADD     3             VDOLUN
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       1020
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C                   MOVEL     *BLANKS       LCANCL
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
     C                   MOVEL     VDOLUN        LDOLUN
      *
     C     VACTP         IFLE      0                                                        K
     C     VACTP         ORGT      13                                                       K
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C     ACST13        IFEQ      0                                                        K
     C     VACTP         ANDEQ     13                                                       K
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VDOLUN        IFLT      1                                                        K
     C     VDOLUN        ORGT      3                                                        K
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      *
