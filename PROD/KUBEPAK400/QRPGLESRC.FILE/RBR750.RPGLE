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
      **PROGRAM NAME-------- RBR750
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- REMOVE CLOSED RECORDS FROM READY BAY FILE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFRBORDR   UF   E           K DISK
     FFHORDR    IF   E           K DISK
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
      * START HERE   *
      ****************
     C     NXT           TAG
     C                   SETOFF                                       50
     C                   READ      FRBORDR                                90                   ARC38
     C   90              GOTO      END
     C     TOORD#        CHAIN     FHORDR                             50
     C  N50              DO
     C     OHSTAT        IFEQ      'D'
     C     OHCOFL        OREQ      'Y'
     C                   SETON                                        50
     C                   END                                                    OHSTAT=D
     C                   ENDDO                                                       N50 DO
     C   50              DELETE    RRBORDR
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
