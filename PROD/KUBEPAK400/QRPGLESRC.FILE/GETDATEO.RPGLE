      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      **PROGRAM NAME-------- GETARB
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- GET TOTAL A/R BALANCE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCUST    UF   E           K DISK
     FFARHST    UF   E           K DISK
     FFCALEN    IF   E           K DISK
     FFCALENCY  IF   E           K DISK
     F                                     RENAME(RCALEN:CALENI)
     FFARHST32  IF   E           K DISK
     F                                     RENAME(RARHST:ARHST)
      *
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
      *****************
      * READ CUSTOMER *
      *****************
      ** GET MCUST
     C     NXTCST        TAG
     C                   READ      FMCUST                                 90
     C   90              GOTO      END
     C                   Z-ADD     0             TSTLST            7 0
     C                   Z-ADD     0             TSTFST            7 0
     C     CMDTLS        IFGT      0
     C     CMDTLS        CHAIN     FCALEN                             91
     C  N91              Z-ADD     CLCYMD        TSTLST            7 0
     C                   END
     C     CMCUST        CHAIN     FARHST                             92
     C     HSDTLS        IFGT      0
     C     HSDTLS        CHAIN     FCALEN                             91
     C  N91              Z-ADD     CLCYMD        TSTLST            7 0
     C                   END
      * NOW I HAVE BOTH RECORDS
     C                   Z-ADD     0             OLDLST            7 0
     C     CMCUST        CHAIN     FARHST32                           93
     C  N93              DO
     C     HSDTLS        IFGT      0
     C     HSDTLS        CHAIN     FCALEN                             91
     C  N91              Z-ADD     CLCYMD        OLDLST            7 0
     C                   END
     C                   ENDDO                                                  N93  DO
     C     OLDLST        IFGT      TSTLST
     C                   Z-ADD     OLDLST        TSTLST
     C                   END
      *UPDATE THE FILES
     C     TSTLST        CHAIN     FCALENCY                           91
     C  N91              Z-ADD     CLDATE        HSDTLS
     C  N91              Z-ADD     CLDATE        CMDTLS
     C                   UPDATE    RMCUST
     C                   UPDATE    RARHST
     C                   GOTO      NXTCST
      *
     C     END           TAG
     C                   SETON                                        LR
