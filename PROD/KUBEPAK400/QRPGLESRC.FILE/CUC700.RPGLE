      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2003
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
      **PROGRAM NAME-------- CUC700
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CLEAR LAST SEASONS CUT LOT FILES.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FCUC700FM  CF   E             WORKSTN
     FFCUTCTL   IF   E           K DISK
      *
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
     D  YEAR                   1      4  0                                      ARC380
     D  YEARYY                 3      4  0                                      ARC380
     D  FILEID                 5     14
     D  LCANCL               133    133                                         ARC380
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C                   MOVE      *BLANKS       LCANCL
     C                   SETOFF                                       1011
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** F KEYS
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
     C                   SETOFF                                       1011
     C     YEAR          IFLE      0
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
     C     YEAR          IFLE      CCLSYR
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   END
      ** IF HERE ALL OK
     C     END           TAG
      ** BUILD FILE NAME
     C                   MOVEL     'FCUTLOT1'    FILEID
     C                   MOVE      YEAR          YY                2 0
     C                   MOVE      YY            FILEID
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     0             YEAR
     C                   Z-ADD     1             LCO               2 0
     C     LCO           CHAIN     FCUTCTL                            90
     C   90              SETON                                        LR
     C                   ENDSR
