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
      *PROGRAM NAME-------- GLR930
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- COPY CHART OF ACCOUNTS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCORG    IF   E           K DISK
     FFMGLCH    UF A E           K DISK
     FGLR930FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       1020
     C                   SETOFF                                       909899
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
      *
     C     VFCO          IFEQ      *ZEROS                                                   K
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VFCO          CHAIN     FMCORG                             90                    K
     C   90              SETON                                        1011
     C   10
     CAN 11              GOTO      NXTA
      *
     C     VTCO          IFEQ      *ZEROS                                                   K
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VTCO          CHAIN     FMCORG                             90                    K
     C   90              SETON                                        20
     C   20              GOTO      NXTA
      *
     C                   Z-ADD     *ZEROS        VGL               8 0
     C                   Z-ADD     VTCO          VCO               2 0
     C     GLKEY         KLIST
     C                   KFLD                    VCO
     C                   KFLD                    VGL
     C     GLKEY         SETLL     FMGLCH
     C     NXTC          TAG
     C     VCO           READE     FMGLCH                                 90
     C   90              GOTO      NXTD
      *
     C     GCCOMP        IFEQ      VTCO
     C     GCSTAT        ANDNE     'D'
     C                   SETON                                        1012
     C   12              GOTO      NXTA
     C                   ENDIF
      *
     C     NXTD          TAG
     C                   Z-ADD     *ZEROS        VGL               8 0
     C                   Z-ADD     VFCO          VCO               2 0
     C     GLKEY         SETLL     FMGLCH
     C     NXTB          TAG
     C     VCO           READE     FMGLCH                                 90
     C   90              GOTO      END
     C     GCSTAT        IFEQ      'D'
     C                   GOTO      NXTB
     C                   ENDIF
     C                   Z-ADD     VTCO          GCCOMP
     C                   Z-ADD     TIMOD         GCTIME
     C                   Z-ADD     TDATE         GCDTLA
     C                   MOVEL     USERID        GCUSER
     C                   WRITE     RMGLCH
     C                   GOTO      NXTB
      *
     C     END           TAG
     C                   SETON                                        LR
      **
