      *--------------------------------------------------------------     GLR010
      *                                                                   GLR010
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999                          GLR010
      *                                                                   GLR010
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO         GLR010
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE         GLR010
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED      GLR010
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR         GLR010
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT      GLR010
      *       BY EXPRESS WRITTEN PERMISSION OF                            GLR010
      *            EFD ENTERPRISES, INC.     215-643-5352                 GLR010
      *                                                                   GLR010
      *--------------------------------------------------------------     GLR010
      *PROGRAM NAME-------- GLR230                                        GLR010
      *SYSTEM-------------- GENERAL LEDGER                                GLR010
      *APPLICATION--------- G/L BUDGET ENTRY                              GLR010
      **                                                                  GLR010
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FGLR230FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMGLCH    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFGLBUD    UF A E           K DISK                                         GLR010
      *                                                                   GLR010
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
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     LCO           VCO               2 0
     C                   Z-ADD     0             VGL
     C                   Z-ADD     0             VDEPT
      *
     C     RSTRTA        TAG
     C                   EXSR      CLRFLD
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102021
     C                   SETOFF                                       2223
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              GOTO      END
      *
     C     VALPHA        IFGT      *BLANKS
     C     VGL           ANDEQ     0
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
     C                   GOTO      NXTA
     C     VACTOK        TAG
      *
     C     VGL           IFLE      0                                                        K
     C     VALPHA        ANDEQ     *BLANKS                                                  K
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VGL           IFEQ      0                                                        K
     C     VDEPT         ANDGT     *ZEROS                                                   K
     C                   SETON                                        2021
     C   21              GOTO      NXTA
     C                   ENDIF
      *                                                                   GLR010
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
      * CHECK TO SEE IF GLBUD EXISTS
      *
     C                   MOVEL     VGL           VGLNO             8 0
     C                   MOVE      VDEPT         VGLNO
     C     BKEY          KLIST
     C                   KFLD                    LCO
     C                   KFLD                    VGLNO
      *
     C     BKEY          CHAIN     FGLBUD                             94                       GLR01
      *
     C  N94VACT          IFEQ      'A'
     C                   SETON                                        2022                  NCEGLR01
     C   22              GOTO      NXTA
     C                   ENDIF
      *
     C   94VACT          IFEQ      'C'
     C     VACT          OREQ      'D'
     C                   SETON                                        2023                  NCEGLR01
     C   23              GOTO      NXTA
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
     C                   SETOFF                                       4041
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRTA
      *
     C                   EXSR      GETBAL
      *
     C     GBC01         IFNE      OBC01
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBC01         OBC01            11 2
     C     GBC02         IFNE      OBC02
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBC02         OBC02            11 2
     C     GBC03         IFNE      OBC03
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBC03         OBC03            11 2
     C     GBC04         IFNE      OBC04
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBC04         OBC04            11 2
     C     GBC05         IFNE      OBC05
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBC05         OBC05            11 2
     C     GBC06         IFNE      OBC06
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBC06         OBC06            11 2
     C     GBC07         IFNE      OBC07
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBC07         OBC07            11 2
     C     GBC08         IFNE      OBC08
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBC08         OBC08            11 2
     C     GBC09         IFNE      OBC09
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBC09         OBC09            11 2
     C     GBC10         IFNE      OBC10
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBC10         OBC10            11 2
     C     GBC11         IFNE      OBC11
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBC11         OBC11            11 2
     C     GBC12         IFNE      OBC12
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBC12         OBC12            11 2
     C     GBC13         IFNE      OBC13
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBC13         OBC13            11 2
      *
     C     GBN01         IFNE      OBN01
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBN01         OBN01            11 2
     C     GBN02         IFNE      OBN02
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBN02         OBN02            11 2
     C     GBN03         IFNE      OBN03
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBN03         OBN03            11 2
     C     GBN04         IFNE      OBN04
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBN04         OBN04            11 2
     C     GBN05         IFNE      OBN05
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBN05         OBN05            11 2
     C     GBN06         IFNE      OBN06
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBN06         OBN06            11 2
     C     GBN07         IFNE      OBN07
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBN07         OBN07            11 2
     C     GBN08         IFNE      OBN08
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBN08         OBN08            11 2
     C     GBN09         IFNE      OBN09
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBN09         OBN09            11 2
     C     GBN10         IFNE      OBN10
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBN10         OBN10            11 2
     C     GBN11         IFNE      OBN11
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBN11         OBN11            11 2
     C     GBN12         IFNE      OBN12
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBN12         OBN12            11 2
     C     GBN13         IFNE      OBN13
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GBN13         OBN13            11 2
      *
     C     CNT           IFGT      1
     C                   SETON                                        98
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   Z-ADD     LCO           GBCOMP
     C                   Z-ADD     VGLNO         GBGLNO
     C                   Z-ADD     TDATE         GBDTLA
     C                   Z-ADD     TIMOD         GBTIME
     C                   MOVEL     USERID        GBUSER
     C     VACT          IFEQ      'A'
     C                   MOVEL     'A'           GBSTAT
     C                   WRITE     RGLBUD
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   MOVEL     'A'           GBSTAT
     C                   UPDATE    RGLBUD
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RGLBUD
     C                   ENDIF
      *
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C                   SETON                                        LR
      *********
      * CLRFLD
      *********
     C     CLRFLD        BEGSR
     C                   Z-ADD     0             CNT               2 0
     C                   Z-ADD     0             VGL
     C                   Z-ADD     0             VDEPT
     C                   MOVEL     *BLANKS       GCDESC
     C                   MOVEL     *BLANKS       GCLOOK
     C                   Z-ADD     0             GBGLNO
     C                   Z-ADD     0             GBC01
     C                   Z-ADD     0             GBC02
     C                   Z-ADD     0             GBC03
     C                   Z-ADD     0             GBC04
     C                   Z-ADD     0             GBC05
     C                   Z-ADD     0             GBC06
     C                   Z-ADD     0             GBC07
     C                   Z-ADD     0             GBC08
     C                   Z-ADD     0             GBC09
     C                   Z-ADD     0             GBC10
     C                   Z-ADD     0             GBC11
     C                   Z-ADD     0             GBC12
     C                   Z-ADD     0             GBC13
     C                   Z-ADD     0             GBN01
     C                   Z-ADD     0             GBN02
     C                   Z-ADD     0             GBN03
     C                   Z-ADD     0             GBN04
     C                   Z-ADD     0             GBN05
     C                   Z-ADD     0             GBN06
     C                   Z-ADD     0             GBN07
     C                   Z-ADD     0             GBN08
     C                   Z-ADD     0             GBN09
     C                   Z-ADD     0             GBN10
     C                   Z-ADD     0             GBN11
     C                   Z-ADD     0             GBN12
     C                   Z-ADD     0             GBN13
     C                   ENDSR
      *********
      * GETBAL
      *********
     C     GETBAL        BEGSR
     C                   Z-ADD     0             CBAL
     C                   Z-ADD     0             PBAL
     C                   ADD       GBC01         CBAL             11 2
     C                   ADD       GBC02         CBAL
     C                   ADD       GBC03         CBAL
     C                   ADD       GBC04         CBAL
     C                   ADD       GBC05         CBAL
     C                   ADD       GBC06         CBAL
     C                   ADD       GBC07         CBAL
     C                   ADD       GBC08         CBAL
     C                   ADD       GBC09         CBAL
     C                   ADD       GBC10         CBAL
     C                   ADD       GBC11         CBAL
     C                   ADD       GBC12         CBAL
     C                   ADD       GBC13         CBAL
     C                   ADD       GBN01         PBAL             11 2
     C                   ADD       GBN02         PBAL
     C                   ADD       GBN03         PBAL
     C                   ADD       GBN04         PBAL
     C                   ADD       GBN05         PBAL
     C                   ADD       GBN06         PBAL
     C                   ADD       GBN07         PBAL
     C                   ADD       GBN08         PBAL
     C                   ADD       GBN09         PBAL
     C                   ADD       GBN10         PBAL
     C                   ADD       GBN11         PBAL
     C                   ADD       GBN12         PBAL
     C                   ADD       GBN13         PBAL
     C                   ENDSR
