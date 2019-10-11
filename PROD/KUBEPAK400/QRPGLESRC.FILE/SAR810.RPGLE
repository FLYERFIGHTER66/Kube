      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1996
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- SAR810
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **APPLICATION--------- MONTHLY PURGE OF TAX JURISDICTION FILE
      **DESCRIPTION--------- ZERO OUT TOTALS IN THE TAX JURISDICTION
      **                     FILE (FMTAXF).
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMTAXF    UF   E           K DISK
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
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     NXT           TAG
     C                   READ      FMTAXF                                 90
     C   90              GOTO      END
      *
     C     TXSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     *ZEROS        TXDGRS
     C                   Z-ADD     *ZEROS        TXDRES
     C                   Z-ADD     *ZEROS        TXTAX1
     C                   Z-ADD     *ZEROS        TXAMT1
     C                   Z-ADD     *ZEROS        TXTAX2
     C                   Z-ADD     *ZEROS        TXAMT2
     C                   Z-ADD     *ZEROS        TXTAX3
     C                   Z-ADD     *ZEROS        TXAMT3
     C                   Z-ADD     *ZEROS        TXMGRS
     C                   Z-ADD     *ZEROS        TXMRES
     C                   Z-ADD     *ZEROS        TXMTX1
     C                   Z-ADD     *ZEROS        TXMMT1
     C                   Z-ADD     *ZEROS        TXMTX2
     C                   Z-ADD     *ZEROS        TXMMT2
     C                   Z-ADD     *ZEROS        TXMTX3
     C                   Z-ADD     *ZEROS        TXMMT3
     C                   Z-ADD     TDATE         TXTDLA
     C                   Z-ADD     TIMOD         TXTIME
     C                   MOVEL     USERID        TXUSER
      *
     C                   UPDATE    RMTAXF
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
