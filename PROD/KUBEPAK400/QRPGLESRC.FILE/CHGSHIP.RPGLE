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
      *PROGRAM NAME-------- CHGSHIP
      *SYSTEM-------------- ORDER PROCESSING
      *DESCRIPTION--------- CHANGE IORDR FOR NEW SHIP VIA OR ROUTE/STOP
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFHORDR    IF   E           K DISK
     FFIORDR    UF   E           K DISK
     FFIORAST   UF   E           K DISK
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    OHORD#
      ** GET ORDER HEADER
     C     OHORD#        CHAIN     FHORDR                             91
     C   91              GOTO      END
      ** READ IORDR RECS AND UPDATE
     C     OHORD#        SETLL     FIORDR
     C     NXTIOR        TAG
     C     OHORD#        READE     FIORDR                                 90
     C   90              GOTO      ENDIO
     C                   MOVEL     OHSHPC        OISHPC
     C                   MOVEL     OHROUT        OIROUT
     C                   Z-ADD     OHSTOP        OISTOP
     C                   UPDATE    RIORDR
     C                   GOTO      NXTIOR
     C     ENDIO         TAG
      ** READ IORAST RECORDS AND UPDATE
     C     OHORD#        SETLL     FIORAST
     C     NXTAST        TAG
     C     OHORD#        READE     FIORAST                                90
     C   90              GOTO      END
     C                   MOVEL     OHSHPC        IASHPC
     C                   MOVEL     OHROUT        IAROUT
     C                   Z-ADD     OHSTOP        IASTOP
     C                   UPDATE    RIORAST
     C                   GOTO      NXTAST
      ** END JOB
     C     END           TAG
     C                   SETON                                        LR
      **
