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
      **PROGRAM NAME-------- DALOC
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS DISTRIBUTION.
      **PROGRAMMER---------- EFD
      **APPLICATION--------- DELETE ALLOCATION IN MINVT AND LKITEM
      *                      (THIS IS A CALLED PROGRAM)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMINVT    UF   E           K DISK
     FFLKITM    UF   E           K DISK
      *
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    QTY              11 1
      ** GET MINVT FIRST
     C     MINKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
     C     MINKEY        CHAIN     FMINVT                             90
     C  N90              DO
     C                   SUB       QTY           IMQTAL
     C     IMQTAL        IFLT      0
     C                   Z-ADD     0             IMQTAL
     C                   END
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C                   UPDATE    RMINVT
     C                   ENDDO
     C     MINKEY        CHAIN     FLKITM                             90
     C  N90              DO
     C                   SUB       QTY           LKPAL
     C     LKPAL         IFLT      0
     C                   Z-ADD     0             LKPAL
     C                   END
     C                   UPDATE    RLKITM
     C                   ENDDO
      ** END JOB
     C     END           TAG
     C                   SETON                                        LR
