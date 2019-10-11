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
      **PROGRAM NAME-------- RBR700
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- DELETE WEEKS RECORDS FROM READY BAY FILES.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFDLOTDSI  UF   E           K DISK
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
      ** CLEAR FDLOT       **
      ***********************
     C                   Z-ADD     0             STRDAT            7 0
     C     STRDAT        SETLL     FDLOTDSI
     C     NXTWKD        TAG
     C                   READ      FDLOTDSI                               90
     C   90              GOTO      ENDWKD
     C     LRGLOC        IFEQ      'R  '
     C                   DELETE    RDLOTRD
     C                   END
     C                   GOTO      NXTWKD
     C     ENDWKD        TAG
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
