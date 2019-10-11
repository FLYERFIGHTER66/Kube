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
     FFARHST    UF A E           K DISK
     FFCALEN    IF   E           K DISK
     FFCALENCY  IF   E           K DISK
     F                                     RENAME(RCALEN:CALENI)
     FFAROPNSD  IF   E           K DISK
     FFARHISTS  IF   E           K DISK
     FFARHIS7S  IF   E           K DISK
     F                                     RENAME(RARHIS:ARHIS)
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
     C     *IN92         IFEQ      '1'
     C                   CLEAR                   RARHST
     C                   MOVEL     'A'           HSSTAT                         STATUS
     C                   Z-ADD     CMCUST        HSCUST                         CUST #
     C                   WRITE     RARHST
     C     CMCUST        CHAIN     FARHST                             92
     C                   END
     C     HSDTFS        IFGT      0
     C     HSDTFS        CHAIN     FCALEN                             91
     C  N91              Z-ADD     CLCYMD        TSTFST            7 0
     C                   END
     C     HSDTLS        IFGT      0
     C     HSDTLS        CHAIN     FCALEN                             91
     C  N91              Z-ADD     CLCYMD        TSTLST            7 0
     C                   END
     C     TSTLST        IFLE      1020323
     C     TSTLST        ANDGT     0
     C                   GOTO      NXTCST
     C                   END
     C                   Z-ADD     0             TSTLST
      * NOW I HAVE BOTH RECORDS
     C                   EXSR      GETHI7
     C                   EXSR      GETHIS
     C                   EXSR      GETARO
      *UPDATE THE FILES
     C     TSTFST        CHAIN     FCALENCY                           91
     C  N91              Z-ADD     CLDATE        HSDTFS
     C     TSTLST        CHAIN     FCALENCY                           91
     C  N91              Z-ADD     CLDATE        HSDTLS
     C  N91              Z-ADD     CLDATE        CMDTLS
     C   91              Z-ADD     0             HSDTLS
     C   91              Z-ADD     0             CMDTLS
     C                   UPDATE    RMCUST
     C                   UPDATE    RARHST
     C                   GOTO      NXTCST
      *
     C     END           TAG
     C                   SETON                                        LR
      *********************
      * GET OLD HISTORY   *
      *********************
     C     GETHI7        BEGSR
     C     CMCUST        SETLL     FARHIS7S
     C     NXTHI7        TAG
     C     CMCUST        READE     FARHIS7S                               90
     C   90              GOTO      ENDHI7
     C     AHTTYP        IFEQ      01
     C     AHTDAT        IFLT      TSTFST
     C                   Z-ADD     AHTDAT        TSTFST
     C                   END
     C     TSTFST        IFLE      0
     C                   Z-ADD     AHTDAT        TSTFST
     C                   END
     C     AHTDAT        IFGT      TSTLST
     C                   Z-ADD     AHTDAT        TSTLST
     C                   END
     C                   END                                                    AHTTYP=01
     C                   GOTO      NXTHI7
     C     ENDHI7        ENDSR
      *********************
      * GET CURR HISTORY  *
      *********************
     C     GETHIS        BEGSR
     C     CMCUST        SETLL     FARHISTS
     C     NXTHIS        TAG
     C     CMCUST        READE     FARHISTS                               90
     C   90              GOTO      ENDHIS
     C     AHTTYP        IFEQ      01
     C     AHTDAT        IFLT      TSTFST
     C                   Z-ADD     AHTDAT        TSTFST
     C                   END
     C     TSTFST        IFLE      0
     C                   Z-ADD     AHTDAT        TSTFST
     C                   END
     C     AHTDAT        IFGT      TSTLST
     C                   Z-ADD     AHTDAT        TSTLST
     C                   END
     C                   END                                                    AHTTYP=01
     C                   GOTO      NXTHIS
     C     ENDHIS        ENDSR
      *********************
      * GET AROPEN        *
      *********************
     C     GETARO        BEGSR
     C     CMCUST        SETLL     FAROPNSD
     C     NXTARO        TAG
     C     CMCUST        READE     FAROPNSD                               90
     C   90              GOTO      ENDARO
     C     ARTTYP        IFEQ      01
     C     ARTDAT        IFLT      TSTFST
     C                   Z-ADD     ARTDAT        TSTFST
     C                   END
     C     TSTFST        IFLE      0
     C                   Z-ADD     ARTDAT        TSTFST
     C                   END
     C     ARTDAT        IFGT      TSTLST
     C                   Z-ADD     ARTDAT        TSTLST
     C                   END
     C                   END                                                    AHTTYP=01
     C                   GOTO      NXTARO
     C     ENDARO        ENDSR
