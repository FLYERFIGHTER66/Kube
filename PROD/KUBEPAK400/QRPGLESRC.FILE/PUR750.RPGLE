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
      **PROGRAM NAME-------- PUR750
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PURGE TRUCK SCHEDULE FILES
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFPUHDRHR  UF   E           K DISK
     FFPUSCHDS  UF   E           K DISK
     FFPUUCKO   UF   E           K DISK
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
     D  LCO                    1      2  0                                      ARC380
     D  LDATE                  3      8  0                                      ARC380
     D  LDCYM                  9     15  0                                      ARC380
     D  CANCEL               133    133                                         ARC380
      ***********************
      ** GET TRUCK HEADER  **
      ***********************
     C                   Z-ADD     0             TSTCYM            7 0
     C     TSTCYM        SETLL     FPUHDRHR
     C     NXTHED        TAG
     C                   READ      FPUHDRHR                               90
     C   90              GOTO      ENDHED
     C     THSHDT        IFLE      LDCYM
     C                   DELETE    RPUHDRH
     C                   GOTO      NXTHED
     C                   END
     C     ENDHED        TAG
      ***********************
      ** GET TRUCK DETAIL  **
      ***********************
     C     TSTCYM        SETLL     FPUSCHDS
     C     NXTDET        TAG
     C                   READ      FPUSCHDS                               90
     C   90              GOTO      ENDDET
     C     TRSHDT        IFLE      LDCYM
     C                   DELETE    RPUSCHD
     C                   GOTO      NXTDET
     C                   END
     C     ENDDET        TAG
      ***********************
      ** GET TRUCK ORDERS  **
      ***********************
     C     TSTCYM        SETLL     FPUUCKO
     C     NXTORD        TAG
     C                   READ      FPUUCKO                                90
     C   90              GOTO      ENDORD
     C     TOSHPD        IFLE      LDCYM
     C                   DELETE    RPUUCKO
     C                   GOTO      NXTORD
     C                   END
     C     ENDORD        TAG
      ** END PROGRAM
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
