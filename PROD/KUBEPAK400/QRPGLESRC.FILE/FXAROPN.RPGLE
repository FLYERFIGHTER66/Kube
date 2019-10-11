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
      *PROGRAM NAME-------- FXAROPN
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- FIX AROPN - CHANGE FOR EACH FIX
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAROPN    UF   E           K DISK
      ** GET NEXT RECORD
     C     NXT           TAG
     C                   READ      FAROPN                                 90
     C   90              GOTO      END
     C     ARSEQ#        IFEQ      000
     C                   Z-ADD     ARDUDT        DUDT              7 0
     C                   ELSE
     C                   Z-ADD     DUDT          ARDUDT
     C                   UPDATE    RAROPN
     C                   END
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
