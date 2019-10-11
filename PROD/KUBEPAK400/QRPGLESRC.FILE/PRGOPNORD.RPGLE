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
      *PROGRAM NAME-------- PRGOPNORD
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- PURGE DELETED RECORDS FROM OPNORD
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFOPNORD   UF   E           K DISK
     FFHORDR    IF   E           K DISK
      *
      *
      *****************
      ** READ OPNORD **
      *****************
     C     NXT           TAG
     C                   READ      FOPNORD                                90
     C   90              GOTO      END
      *
     C     OOORD#        CHAIN     FHORDR                             91
     C  N91              DO
     C     OHSTAT        IFEQ      'D'
     C                   SETON                                        91
     C                   END
     C                   ENDDO                                                  N91  DO
      * DELETE OPNORD REC IF NO HEADER OR HEADER DELETED
      *
     C   91              DELETE    ROPNORD
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
