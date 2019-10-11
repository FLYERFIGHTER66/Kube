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
      *PROGRAM NAME-------- FXSOWSCH
      *SYSTEM-------------- INVENTORY
      *APPLICATION--------- FIX SOWSCH - CHANGE FOR EACH FIX
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFSOWSCH   UF   E           K DISK
     FFTRAYJD   IF   E           K DISK
      *
      ** GET NEXT RECORD
     C     NXT           TAG
     C                   READ      FSOWSCH                                90
     C   90              GOTO      END
     C     SOSOWT        SUB       SOSOWL        TEST              5 0
     C     TEST          IFLT      0
     C                   EXSR      GETCNT
     C                   Z-ADD     TRYCNT        SOSOWL
     C                   Z-ADD     TRYCNT        SOSOWQ
     C                   UPDATE    RSOWSCH
     C                   END
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** GET TRAY COUNT    **
      ***********************
     C     GETCNT        BEGSR
     C     TRYKEY        KLIST
     C                   KFLD                    SOSOWD
     C                   KFLD                    SOJOB#
      ** GET NEW COUNT FOR SOWSCH
     C     TRYKEY        SETLL     FTRAYJD
     C                   Z-ADD     0             TRYCNT            9 0
     C     NXCTRY        TAG
     C     TRYKEY        READE(N)  FTRAYJD                                91
     C   91              GOTO      ENCTRY
     C     TRSTAT        IFEQ      'A'
     C                   ADD       1             TRYCNT
     C                   END
     C                   GOTO      NXCTRY
     C     ENCTRY        TAG
     C                   ENDSR
