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
      **PROGRAM NAME-------- ALITO
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- GET FALITEM ALLOCATIONS INTO FIORDR
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFALITEMO  IF   E           K DISK
     FFIORDR    UF   E           K DISK
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
      ** MAIN LINE CODE    **
      ***********************
     C                   SETON                                        55
     C     NXTALI        TAG
     C                   READ      FALITEMO                               90
     C   90              GOTO      END
     C     AIORD#        IFNE      OORDER
     C     AIOSEQ        ORNE      OSEQ
     C     OIQTAL        IFEQ      OIQORD
     C                   MOVEL     'Y'           OILOTC
     C                   END
     C  N55              UPDATE    RIORDR
     C     IORKEY        KLIST
     C                   KFLD                    AIORD#
     C                   KFLD                    AIOSEQ
     C     IORKEY        CHAIN     FIORDR                             55
     C                   Z-ADD     0             OIQTAL
     C                   Z-ADD     AIORD#        OORDER            6 0
     C                   Z-ADD     AIOSEQ        OSEQ              3 0
     C                   ENDIF
     C                   ADD       AIQTOA        OIQTAL
     C                   GOTO      NXTALI
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
      ******************
