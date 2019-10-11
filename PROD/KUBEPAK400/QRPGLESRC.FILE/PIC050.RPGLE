      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- PIC050
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- BUILD POINTESTTIA INVENTORY FILE PROMPT
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FPIC050FM  CF   E             WORKSTN
     FFPOICTL   IF   E           K DISK
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LYEAR                  1      4  0                                      ARC380
     D  LCANCL               133    133                                         ARC380
      ****************
      * START HERE   *
      ****************
     C     RSTART        TAG
     C                   MOVE      *BLANKS       LCANCL
     C                   Z-ADD     0             LYEAR
     C                   SETOFF                                       102030
     C                   MOVE      TDATE         WK2               2 0                         ARC38
     C     2000          ADD       WK2           YEAR
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
     C                   SETOFF                                       1020
     C     YEAR          IFLE      0
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
      ** GET RECORD
     C     YEAR          CHAIN     FPOICTL                            20
     C   20              GOTO      NXTA
     C     YEAR          IFNE      LYEAR
     C                   Z-ADD     YEAR          LYEAR
     C                   GOTO      NXTA
     C                   END
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
