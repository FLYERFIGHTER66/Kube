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
      **PROGRAM NAME-------- GETNXCST
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- KUBE PAK GET UNUSED CUSTOMER NUMBERS
      * PROGRAM ASSUMES FILE IS CLEARED BEFORE UPDATE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMCUST    IF   E           K DISK
     FFNXTCUST  O    E           K DISK
      *
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
      ***********************
      ** START HERE        **
      ***********************
     C                   Z-ADD     0             CMCUST
     C                   Z-ADD     1             NXCUST
     C     CMCUST        SETLL     FMCUST
     C     NXT           TAG
     C                   READ      FMCUST                                 90
     C   90              GOTO      END
     C     NXTNXC        TAG
     C     CMCUST        IFGT      NXCUST
     C                   WRITE     RNXTCUST
     C                   ADD       1             NXCUST
     C                   GOTO      NXTNXC
     C                   END
     C                   ADD       1             NXCUST
     C                   GOTO      NXT
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
