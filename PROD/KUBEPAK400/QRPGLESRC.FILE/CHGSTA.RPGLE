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
      **PROGRAM NAME-------- CHGSTA
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **DESCRIPTION--------- CHANGE STA STATUS OR ORDER DETAIL FILE
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFHORDR    IF   E           K DISK
     FFIORDR    UF   E           K DISK
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    OHORD#
      * GET ORDER HEADER
     C     OHORD#        CHAIN     FHORDR                             90
     C   90              GOTO      END
     C     OHORD#        SETLL     FIORDR
     C     NXTIOR        TAG
     C     OHORD#        READE     FIORDR                                 90
     C   90              GOTO      END
      ** MOVE HEADER STA
     C                   MOVEL     OHSTA         OISTA
     C                   UPDATE    RIORDR
     C                   GOTO      NXTIOR
      *
     C     END           TAG
     C                   SETON                                        LR
