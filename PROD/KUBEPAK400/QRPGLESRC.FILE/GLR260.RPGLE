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
      *PROGRAM NAME-------- GLR260
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- G/L START UP ENTRY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FGLR260FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMGLCH    IF   E           K DISK
     FFGLBAL    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFGLENT    UF A E           K DISK
      *
     D MSG             S              9    DIM(4) CTDATA PERRCD(1)
      *
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
     D                UDS
     D  LCO                    1      2  0
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     LCO           VCO               2 0
      *
     C     RSTRTA        TAG
     C                   EXSR      CLRFLD
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       202122
     C                   SETOFF                                       232498
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
      *
     C     VALPHA        IFGT      *BLANKS
     C     VGL           ANDEQ     *ZEROS
     C                   MOVEL     VALPHA        GCLOOK
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    VCO
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     GCGLNO        VGL
     C                   MOVE      GCGLNO        VDEPT
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C   10              GOTO      NXTA
     C     VACTOK        TAG
      *
     C     VGL           IFLE      0                                                        K
     C     VALPHA        ANDEQ     *BLANKS                                                  K
     C                   SETON                                        2021
     C   21              GOTO      NXTA
     C                   ENDIF
      *
     C     VGL           IFEQ      0                                                        K
     C     VDEPT         ANDGT     *ZEROS                                                   K
     C                   SETON                                        2021
     C   21              GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     LCO           GCCOMP
     C                   MOVE      VDEPT         GCGLNO
     C                   MOVEL     VGL           GCGLNO
     C     GKEY          KLIST
     C                   KFLD                    GCCOMP
     C                   KFLD                    GCGLNO
     C     GKEY          CHAIN     FMGLCH                             90
     C   90              SETON                                        2021
     C   21              GOTO      NXTA
      *
     C     GCATYP        IFEQ      1
     C                   MOVEL     MSG(1)        TYPE              9
     C                   ENDIF
     C     GCATYP        IFEQ      2
     C                   MOVEL     MSG(2)        TYPE
     C                   ENDIF
     C     GCATYP        IFEQ      3
     C                   MOVEL     MSG(3)        TYPE
     C                   ENDIF
     C     GCATYP        IFEQ      4
     C                   MOVEL     MSG(4)        TYPE
     C                   ENDIF
      *
      * CHECK TO SEE IF GLENT EXISTS
      *
     C                   MOVEL     VGL           VGLNO             8 0
     C                   MOVE      VDEPT         VGLNO
     C     BKEY          KLIST
     C                   KFLD                    LCO
     C                   KFLD                    VGLNO
     C     BKEY          CHAIN     FGLENT                             94
     C  N94              EXSR      GETBAL
      *
     C  N94VACT          IFEQ      'A'
     C                   SETON                                        2022                  NCE
     C   22              GOTO      NXTA
     C                   ENDIF
      *
     C   94VACT          IFEQ      'C'
     C     VACT          OREQ      'D'
     C                   SETON                                        2023                  NCE
     C   23              GOTO      NXTA
     C                   ENDIF
      *
      * CHECK TO SEE IF GLBAL EXISTS
      *
     C     VACT          IFEQ      'A'
     C     BKEY          CHAIN     FGLBAL                             95
     C  N95              SETON                                        2024                  NCE
     C   24              GOTO      NXTA                                                     LAN
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C     ACMPCN        IFEQ      'M'
     C                   SETON                                        31
     C                   ENDIF
     C   31              MOVEL     'Month '      PERMO
     C  N31              MOVEL     'Period'      PERMO
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     1             CNT               2 0
     C                   SETOFF                                       404142
     C                   SETOFF                                       43
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRTA
      *
     C     GCATYP        IFGT      2
     C     GLBALT        ANDNE     0
     C                   SETON                                        4042
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     GCATYP        IFGT      2
     C     GLBALL        ANDNE     0
     C                   SETON                                        41
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   EXSR      GETBAL
     C     GCATYP        IFLE      2
     C     GLBALT        ANDNE     PBAL
     C                   SETON                                        404398
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     GLBALT        IFNE      OBALT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLBALT        OBALT            11 2
     C     GLT01         IFNE      OLT01
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLT01         OLT01            11 2
     C     GLT02         IFNE      OLT02
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLT02         OLT02            11 2
     C     GLT03         IFNE      OLT03
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLT03         OLT03            11 2
     C     GLT04         IFNE      OLT04
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLT04         OLT04            11 2
     C     GLT05         IFNE      OLT05
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLT05         OLT05            11 2
     C     GLT06         IFNE      OLT06
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLT06         OLT06            11 2
     C     GLT07         IFNE      OLT07
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLT07         OLT07            11 2
     C     GLT08         IFNE      OLT08
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLT08         OLT08            11 2
     C     GLT09         IFNE      OLT09
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLT09         OLT09            11 2
     C     GLT10         IFNE      OLT10
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLT10         OLT10            11 2
     C     GLT11         IFNE      OLT11
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLT11         OLT11            11 2
     C     GLT12         IFNE      OLT12
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLT12         OLT12            11 2
     C  N31GLT13         IFNE      OLT13
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLT13         OLT13            11 2
     C     GLBALL        IFNE      OBALL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLBALL        OBALL            11 2
     C     GLL01         IFNE      OLL01
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLL01         OLL01            11 2
     C     GLL02         IFNE      OLL02
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLL02         OLL02            11 2
     C     GLL03         IFNE      OLL03
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLL03         OLL03            11 2
     C     GLL04         IFNE      OLL04
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLL04         OLL04            11 2
     C     GLL05         IFNE      OLL05
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLL05         OLL05            11 2
     C     GLL06         IFNE      OLL06
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLL06         OLL06            11 2
     C     GLL07         IFNE      OLL07
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLL07         OLL07            11 2
     C     GLL08         IFNE      OLL08
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLL08         OLL08            11 2
     C     GLL09         IFNE      OLL09
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLL09         OLL09            11 2
     C     GLL10         IFNE      OLL10
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLL10         OLL10            11 2
     C     GLL11         IFNE      OLL11
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLL11         OLL11            11 2
     C     GLL12         IFNE      OLL12
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLL12         OLL12            11 2
     C  N31GLL13         IFNE      OLL13
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GLL13         OLL13            11 2
      *
     C     CNT           IFGT      1
     C                   SETON                                        98
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   Z-ADD     LCO           GLCOMP
     C                   Z-ADD     VGLNO         GLGLNO
     C                   Z-ADD     TDATE         GLDTLA
     C                   Z-ADD     TIMOD         GLTIME
     C                   MOVEL     USERID        GLUSER
     C     VACT          IFEQ      'A'
     C                   MOVEL     'A'           GLSTAT
     C                   WRITE     RGLENT
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RGLENT
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RGLENT
     C                   ENDIF
      *
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      *********
      * GETBAL
      *********
     C     GETBAL        BEGSR
     C                   Z-ADD     0             CBAL
     C                   Z-ADD     0             PBAL
     C                   ADD       GLBALT        CBAL             11 2
     C                   ADD       GLT01         CBAL
     C                   ADD       GLT02         CBAL
     C                   ADD       GLT03         CBAL
     C                   ADD       GLT04         CBAL
     C                   ADD       GLT05         CBAL
     C                   ADD       GLT06         CBAL
     C                   ADD       GLT07         CBAL
     C                   ADD       GLT08         CBAL
     C                   ADD       GLT09         CBAL
     C                   ADD       GLT10         CBAL
     C                   ADD       GLT11         CBAL
     C                   ADD       GLT12         CBAL
     C                   ADD       GLT13         CBAL
     C                   ADD       GLBALL        PBAL             11 2
     C                   ADD       GLL01         PBAL
     C                   ADD       GLL02         PBAL
     C                   ADD       GLL03         PBAL
     C                   ADD       GLL04         PBAL
     C                   ADD       GLL05         PBAL
     C                   ADD       GLL06         PBAL
     C                   ADD       GLL07         PBAL
     C                   ADD       GLL08         PBAL
     C                   ADD       GLL09         PBAL
     C                   ADD       GLL10         PBAL
     C                   ADD       GLL11         PBAL
     C                   ADD       GLL12         PBAL
     C                   ADD       GLL13         PBAL
     C                   ENDSR
      *********
      * CLRFLD
      *********
     C     CLRFLD        BEGSR
     C                   Z-ADD     1             CNT               2 0
     C                   Z-ADD     0             VGL
     C                   Z-ADD     0             VDEPT
     C                   Z-ADD     0             CBAL
     C                   Z-ADD     0             PBAL
     C                   MOVEL     *BLANKS       GCDESC
     C                   MOVEL     *BLANKS       GCLOOK
     C                   MOVEL     *BLANKS       TYPE
     C                   Z-ADD     0             GCGLNO
     C                   Z-ADD     0             GCCOMP
     C                   Z-ADD     0             GCATYP
     C                   Z-ADD     0             GLT01
     C                   Z-ADD     0             GLT02
     C                   Z-ADD     0             GLT03
     C                   Z-ADD     0             GLT04
     C                   Z-ADD     0             GLT05
     C                   Z-ADD     0             GLT06
     C                   Z-ADD     0             GLT07
     C                   Z-ADD     0             GLT08
     C                   Z-ADD     0             GLT09
     C                   Z-ADD     0             GLT10
     C                   Z-ADD     0             GLT11
     C                   Z-ADD     0             GLT12
     C                   Z-ADD     0             GLT13
     C                   Z-ADD     0             GLL01
     C                   Z-ADD     0             GLL02
     C                   Z-ADD     0             GLL03
     C                   Z-ADD     0             GLL04
     C                   Z-ADD     0             GLL05
     C                   Z-ADD     0             GLL06
     C                   Z-ADD     0             GLL07
     C                   Z-ADD     0             GLL08
     C                   Z-ADD     0             GLL09
     C                   Z-ADD     0             GLL10
     C                   Z-ADD     0             GLL11
     C                   Z-ADD     0             GLL12
     C                   Z-ADD     0             GLL13
     C                   Z-ADD     0             GLBALT
     C                   Z-ADD     0             GLBALL
     C                   ENDSR
**
Asset
Liability
Revenue
Expense
