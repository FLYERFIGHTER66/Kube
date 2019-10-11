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
      *PROGRAM NAME-------- FXSHISTPC
      *SYSTEM-------------- FIX FILE
      *APPLICATION--------- CHANGE FSHIST IF PRODUCT CLASS CHANGES
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFSHIST    UF   E           K DISK
     FFMINVT    IF   E           K DISK
      *
     C     NXT           TAG
     C                   READ      FSHIST                                 90
     C                   SETOFF                                       50
     C   90              GOTO      END
     C     SIITEM        IFEQ      *BLANKS
     C                   GOTO      NXT
     C                   ENDIF
     C*          SHPCL1    IFGT *BLANKS
     C*                    GOTO NXT
     C*                    ENDIF
     C     KEY18         KLIST
     C                   KFLD                    SIITEM
     C                   KFLD                    SISIZE
     C     KEY18         CHAIN     FMINVT                             50
     C  N50              MOVEL     IMPCL1        SIPCL1
     C                   UPDATE    RSHIST
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
