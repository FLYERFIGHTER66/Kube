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
      *PROGRAM NAME-------- FXSOHST
      *SYSTEM-------------- FIX FILE
      *APPLICATION--------- CHANGE FSOHST AS NEEDED
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMAVDTE   UF   E             DISK
     FFMINVT    IF   E           K DISK
      *
     C     NXT           TAG
     C                   READ      FMAVDTE                                90
     C   90              GOTO      END
     C     AVKEY         KLIST
     C                   KFLD                    AVITEM
     C                   KFLD                    AVSIZE
     C     AVKEY         CHAIN     FMINVT                             80
     C   80              DELETE    RMAVDTE
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
