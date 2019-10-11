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
      *PROGRAM NAME-------- APC710
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- FISCAL YEAR END PROMPT SCREEN
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FAPC710FM  CF   E             WORKSTN
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
     D  LSAVE                  3      3
     D  LCANCL               133    133
      *
      *  MAIN FLOW OF PROGRAM
      *
     C                   Z-ADD     1             CNT               2 0
     C                   Z-ADD     1             CNTB              2 0
     C                   MOVEL     *BLANKS       LSAVE
      *
     C                   SETOFF                                       50
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C     CNT           IFGT      1
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C                   ADD       1             CNT
     C                   SETON                                        50
     C                   GOTO      RSTRT
      *
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT
     C                   SETOFF                                       1020
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C                   MOVEL     *BLANKS       LCANCL
      *
     C     LSAVE         IFNE      'Y'                                                      Q
     C     LSAVE         ANDNE     'N'
     C                   SETON                                        20
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LSAVE         IFNE      OSAVE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LSAVE         OSAVE             1
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C   98              GOTO      NXTB
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      *
