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
      *PROGRAM NAME-------- APC715
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- CALENDAR YEAR END - CREATE V1099
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FAPC715FM  CF   E             WORKSTN
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
     D  LSAVE                  1      1
     D  LYEAR                  2      5  0
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       1020
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
      * VALIDATE SAVE RESPONSES
      *
     C     LSAVE         IFNE      'Y'                                                      L
     C     LSAVE         ANDNE     'N'                                                      L
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LSAVE         IFNE      OSAVE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LSAVE         OSAVE             1
      *
      * VALIDATE YEAR
      *
     C     VYEAR         IFEQ      0                                                        L
     C                   SETON                                        2021
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     VYEAR         IFGT      2025                                                     L
     C     VYEAR         ORLT      1995                                                     L
     C                   SETON                                        2022
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C                   Z-ADD     VYEAR         LYEAR
      *
     C     VYEAR         IFNE      OYEAR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VYEAR         OYEAR             4 0
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C   98              GOTO      RSTRT
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      *
