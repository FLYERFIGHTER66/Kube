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
      **PROGRAM NAME-------- SDR700
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- GET HIGH/LOW PRICE    (CALLED)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFSERIES   UF   E           K DISK
     FFSERPRCS  IF   E           K DISK
      *
     D PRC             S              9  4 DIM(3)                               PRICES
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
      *
     IRSERPRC
     I              SPPRC1                      PRC(1)
     I              SPPRC2                      PRC(2)
     I              SPPRC3                      PRC(3)
     I**                                      1   20LCO                   ARC380
     C     *ENTRY        PLIST
     C                   PARM                    SECODE
     C     SECODE        CHAIN     FSERIES                            91
     C   91              GOTO      END
     C                   Z-ADD     0             SEHPRC
     C                   Z-ADD     0             SEHVND
     C                   Z-ADD     0             SELPRC
     C                   Z-ADD     0             SELVND
     C                   Z-ADD     SEFORM        FORM              1 0
     C     SECODE        SETLL     FSERPRCS
     C     NXTPRC        TAG
     C     SECODE        READE     FSERPRCS                               92
     C   92              GOTO      ENDPRC
     C     PRC(FORM)     IFLE      0
     C                   GOTO      NXTPRC
     C                   END
     C     SELPRC        IFLE      0
     C                   Z-ADD     9999          TESTLO            9 4
     C                   ELSE
     C                   Z-ADD     SELPRC        TESTLO            9 4
     C                   END
     C     PRC(FORM)     IFLT      TESTLO
     C                   Z-ADD     PRC(FORM)     SELPRC
     C                   Z-ADD     SPVEND        SELVND
     C                   END
     C     PRC(FORM)     IFGT      SEHPRC
     C                   Z-ADD     PRC(FORM)     SEHPRC
     C                   Z-ADD     SPVEND        SEHVND
     C                   END
     C     SPVEND        IFEQ      SEVND
     C                   Z-ADD     PRC(FORM)     SEPRC
     C                   END
     C                   GOTO      NXTPRC
     C     ENDPRC        TAG
     C                   Z-ADD     TDATE         SEDTLA
     C                   UPDATE    RSERIES
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
