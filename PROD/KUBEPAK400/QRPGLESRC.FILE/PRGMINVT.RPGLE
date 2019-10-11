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
      **PROGRAM NAME-------- PRGMINVT
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- GINNY
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  8/18/00 EFD USE STATUS P TO DELETE NOT D
      *
     FFMINVT    UF   E           K DISK
     FFMITSES   UF   E           K DISK
     FFMAVDTE   UF   E           K DISK
     FFIADD     UF   E           K DISK
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
     D  LDAPTO                 1      1  0                                      ARC380
      ***********************
      ** READ FMINVT       **
      ***********************
     C     NXT           TAG
     C                   READ      FMINVT                                 90
     C   90              GOTO      ENDINV
     C     IMSTAT        IFEQ      'P'
      ** DELETE FMINVT REC
     C                   DELETE    RMINVT
     C     AVKEY         KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C     AVKEY         CHAIN     FMAVDTE                            51
     C  N51              DELETE    RMAVDTE
     C                   GOTO      NXT
     C                   END
     C     ENDINV        TAG
      ** GET FIADD RECORD
     C     NXTADD        TAG
     C                   READ      FIADD                                  90
     C   90              GOTO      ENDADD
     C     ADDKEY        KLIST
     C                   KFLD                    IAITEM
     C     ADDKEY        CHAIN     FMINVT                             71
     C   71              DELETE    RIADD
     C                   GOTO      NXTADD
     C     ENDADD        TAG
      ** GET FIADD RECORD
     C     NXTSES        TAG
     C                   READ      FMITSES                                90
     C   90              GOTO      ENDSES
     C     SESKEY        KLIST
     C                   KFLD                    ISITEM
     C                   KFLD                    ISSIZE
     C     SESKEY        CHAIN     FMINVT                             71
     C   71              DELETE    RMITSES
     C                   GOTO      NXTSES
     C     ENDSES        TAG
      ** END JOB
     C     END           TAG
     C                   SETON                                        LR
