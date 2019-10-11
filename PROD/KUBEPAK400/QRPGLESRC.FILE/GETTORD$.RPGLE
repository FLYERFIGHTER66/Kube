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
      *PROGRAM NAME-------- GETTORD$
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- GET TOTAL VALUE OF OPEN ORDERS FOR A CUST.
      *                     IF CHANGE NEEDED.   (CALLED PROGRAM)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCUST    UF   E           K DISK
     FFOPNORDC  IF   E           K DISK
     F                                     RENAME(ROPNORD:OPNORD)
     FFOPNORDA  IF   E           K DISK
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LDAPTO                 1      1  0
      **********
      * ENTRY  *
      **********
     C     *ENTRY        PLIST
     C                   PARM                    OHCUST            6 0
     C                   Z-ADD     0             TOTDOL            9 2
     C                   Z-ADD     0             TOTORD            5 0
      ** READ OPNORD FILE BY SHIP TO
     C     OHCUST        SETLL     FOPNORDC
     C     NXTOPR        TAG
     C     OHCUST        READE     FOPNORDC                               90
     C  N90              DO
     C                   ADD       OOEXT$        TOTDOL
     C                   ADD       1             TOTORD
     C                   GOTO      NXTOPR
     C                   ENDDO
      ** READ OPNORD FILE BY A/R CUST IF NEEDED
     C     OHCUST        SETLL     FOPNORDA
     C     NXTAPR        TAG
     C     OHCUST        READE     FOPNORDA                               90
     C  N90              DO
     C     OOCUST        IFNE      OOARCU
     C                   ADD       OOEXT$        TOTDOL
     C                   ADD       1             TOTORD
     C                   END                                                    OOCUST><ARCU
     C                   GOTO      NXTAPR
     C                   ENDDO
     C     OHCUST        CHAIN     FMCUST                             88
     C                   Z-ADD     TOTDOL        CMVOPO
     C                   Z-ADD     TOTORD        CMOCUR
     C  N88              UPDATE    RMCUST
      **** END OF PROGRAM
     C     END           TAG
     C                   UNLOCK    FMCUST
     C                   CLEAR                   *IN
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
