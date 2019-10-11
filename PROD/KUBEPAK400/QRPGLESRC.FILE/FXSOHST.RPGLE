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
     FFSOHST    UF   E           K DISK
     FFMINVT    IF   E           K DISK
      *
     C     NXT           TAG
     C                   READ      FSOHST                                 90
     C   90              GOTO      END
     C     SOQSHP        IFGT      0
     C                   GOTO      NXT
     C                   END
     C     MINKEY        KLIST
     C                   KFLD                    SOITEM
     C                   KFLD                    SOSIZE
     C                   KFLD                    SOWHSE
     C     MINKEY        CHAIN     FMINVT                             91
     C   91              GOTO      NXT
     C                   MOVEL     IMDES1        SODES1
     C                   UPDATE    RSOHST
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
