      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- PIR010
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- POINTSETTIA CONTROL FILE MAINTAINENCE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FPIR010FM  CF   E             WORKSTN
     FFPOICTL   UF A E           K DISK
     FFCALEN    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:CALENI)
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
      ****************
      * START HERS   *
      ****************
     C     RSTART        TAG
     C                   SETOFF                                       102030
     C                   MOVE      TDATE         WK2               2 0                         ARC38
     C     2000          ADD       WK2           YEAR
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              GOTO      END
     C                   SETOFF                                       10
     C     YEAR          IFLE      0
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
      ** GET RECORD
     C     YEAR          CHAIN     FPOICTL                            89
     C   89              CLEAR                   RPOICTL
     C   89              Z-ADD     YEAR          PCYEAR
     C   89              Z-ADD     0             OLDNUM
     C                   SETOFF                                       010203
     C                   SETOFF                                       040506
     C                   SETOFF                                       070809
     C                   SETOFF                                       101112
     C                   SETOFF                                       202122
     C                   SETOFF                                       2330
     C  N89              DO
     C                   EXSR      GETIND
     C                   Z-ADD     PCW1D         BEGDAT
     C                   Z-ADD     PCNUMW        OLDNUM            2 0
     C                   ENDDO
      *******************
      * SCREEN B
      *******************
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              GOTO      END
     C                   SETOFF                                       202122
     C                   SETOFF                                       2330
      ** CHECK DATE
     C     BEGDAT        IFLE      0
     C                   SETON                                        2021
     C                   GOTO      NXTB
     C                   END
     C     BEGDAT        CHAIN     FCALEN                             20
     C   20              DO
     C                   SETON                                        21
     C                   GOTO      NXTB
     C                   ENDDO
     C     CL#Y          IFNE      1
     C                   SETON                                        2022
     C                   GOTO      NXTB
     C                   END
      ** CHECK FOR SAME YEAR
     C                   MOVE      YEAR          YR2               2 0
     C                   MOVE      BEGDAT        DT2               2 0
     C     YR2           IFNE      DT2
     C                   SETON                                        2023
     C                   GOTO      NXTB
     C                   END
      ** CHECK NUMBER OF WEEKS
     C     PCNUMW        IFLE      0
     C     PCNUMW        ORGT      12
     C                   SETON                                        30
     C                   GOTO      NXTB
     C                   END
      ** IF HERE ALL OK.
     C     BEGDAT        IFNE      PCW1D
     C     OLDNUM        ORNE      PCNUMW
     C                   Z-ADD     PCNUMW        OLDNUM            2 0
     C                   EXSR      BLDDAT
     C                   EXSR      GETIND
     C                   GOTO      NXTB
     C                   END
      ** WRITE/UPDATE RECORD
     C   89              WRITE     RPOICTL
     C  N89              UPDATE    RPOICTL
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD DATES
      ***********************
     C     BLDDAT        BEGSR
     C                   Z-ADD     BEGDAT        PCW1D
     C     PCW1D         CHAIN     FCALEN                             30
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    CL#Y
     C     PCNUMW        IFGE      2
     C                   ADD       1             CLWEEK
     C     CALKEY        CHAIN     FCALEX                             30
     C                   Z-ADD     CLDATE        PCW2D
     C                   ELSE
     C                   Z-ADD     0             PCW2D
     C                   END
     C     PCNUMW        IFGE      3
     C                   ADD       1             CLWEEK
     C     CALKEY        CHAIN     FCALEX                             30
     C                   Z-ADD     CLDATE        PCW3D
     C                   ELSE
     C                   Z-ADD     0             PCW3D
     C                   END
     C     PCNUMW        IFGE      4
     C                   ADD       1             CLWEEK
     C     CALKEY        CHAIN     FCALEX                             30
     C                   Z-ADD     CLDATE        PCW4D
     C                   ELSE
     C                   Z-ADD     0             PCW4D
     C                   END
     C     PCNUMW        IFGE      5
     C                   ADD       1             CLWEEK
     C     CALKEY        CHAIN     FCALEX                             30
     C                   Z-ADD     CLDATE        PCW5D
     C                   ELSE
     C                   Z-ADD     0             PCW5D
     C                   END
     C     PCNUMW        IFGE      6
     C                   ADD       1             CLWEEK
     C     CALKEY        CHAIN     FCALEX                             30
     C                   Z-ADD     CLDATE        PCW6D
     C                   ELSE
     C                   Z-ADD     0             PCW6D
     C                   END
     C     PCNUMW        IFGE      7
     C                   ADD       1             CLWEEK
     C     CALKEY        CHAIN     FCALEX                             30
     C                   Z-ADD     CLDATE        PCW7D
     C                   ELSE
     C                   Z-ADD     0             PCW7D
     C                   END
     C     PCNUMW        IFGE      8
     C                   ADD       1             CLWEEK
     C     CALKEY        CHAIN     FCALEX                             30
     C                   Z-ADD     CLDATE        PCW8D
     C                   ELSE
     C                   Z-ADD     0             PCW8D
     C                   END
     C     PCNUMW        IFGE      9
     C                   ADD       1             CLWEEK
     C     CALKEY        CHAIN     FCALEX                             30
     C                   Z-ADD     CLDATE        PCW9D
     C                   ELSE
     C                   Z-ADD     0             PCW9D
     C                   END
     C     PCNUMW        IFGE      10
     C                   ADD       1             CLWEEK
     C     CALKEY        CHAIN     FCALEX                             30
     C                   Z-ADD     CLDATE        PCW10D
     C                   ELSE
     C                   Z-ADD     0             PCW10D
     C                   END
     C     PCNUMW        IFGE      11
     C                   ADD       1             CLWEEK
     C     CALKEY        CHAIN     FCALEX                             30
     C                   Z-ADD     CLDATE        PCW11D
     C                   ELSE
     C                   Z-ADD     0             PCW11D
     C                   END
     C     PCNUMW        IFGE      12
     C                   ADD       1             CLWEEK
     C     CALKEY        CHAIN     FCALEX                             30
     C                   Z-ADD     CLDATE        PCW12D
     C                   ELSE
     C                   Z-ADD     0             PCW12D
     C                   END
     C                   ENDSR
      ***********************
      ** GET SCREEN INDICATORS
      ***********************
     C     GETIND        BEGSR
     C                   SETOFF                                       010203
     C                   SETOFF                                       040506
     C                   SETOFF                                       070809
     C                   SETOFF                                       101112
     C     PCW1D         IFGT      0
     C                   SETON                                        01
     C                   END
     C     PCW2D         IFGT      0
     C                   SETON                                        02
     C                   END
     C     PCW3D         IFGT      0
     C                   SETON                                        03
     C                   END
     C     PCW4D         IFGT      0
     C                   SETON                                        04
     C                   END
     C     PCW5D         IFGT      0
     C                   SETON                                        05
     C                   END
     C     PCW6D         IFGT      0
     C                   SETON                                        06
     C                   END
     C     PCW7D         IFGT      0
     C                   SETON                                        07
     C                   END
     C     PCW8D         IFGT      0
     C                   SETON                                        08
     C                   END
     C     PCW9D         IFGT      0
     C                   SETON                                        09
     C                   END
     C     PCW10D        IFGT      0
     C                   SETON                                        10
     C                   END
     C     PCW11D        IFGT      0
     C                   SETON                                        11
     C                   END
     C     PCW12D        IFGT      0
     C                   SETON                                        12
     C                   END
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
