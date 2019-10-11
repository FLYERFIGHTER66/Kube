      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1997
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
      **PROGRAM NAME-------- SED900
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- RECALC MINVT ONHAND FROM SEDLOT RECPRDS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMINVTSZ  UF   E           K DISK
     FFSEDLOT   IF   E           K DISK
      *
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LDAPTO                 1      1  0                                      ARC380
      ***********************
      ** START HERE        **
      ***********************
     C                   MOVEL     'SED'         WRKSIZ            3
     C     WRKSIZ        SETLL     FMINVTSZ
     C     NXTMIN        TAG
     C     WRKSIZ        READE     FMINVTSZ                               90
     C   90              GOTO      END
     C                   Z-ADD     0             IMQTOH
     C     IMITEM        SETLL     FSEDLOT
     C     NXTSED        TAG
     C     IMITEM        READE     FSEDLOT                                91
     C   91              GOTO      ENDSED
     C                   ADD       SLQTOH        IMQTOH
     C                   GOTO      NXTSED
      ** UPDATE MINVT RECORD
     C     ENDSED        TAG
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C     IMQTOH        MULT      IMUCST        IMCSOH
     C                   UPDATE    RMINVT
     C                   GOTO      NXTMIN
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
