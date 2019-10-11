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
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- GLR000
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- CONTROL FILE MAINTENANCE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FGLR000FM  CF   E             WORKSTN
     FFMCORG    IF   E           K DISK
     FFGLCTL    UF A E           K DISK
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      *  PROGRAM NAME
     D  PROGID                 1     10
      *  RUN LIBRARY
     D  RLIBR                 81     90
      *  USER I.D.
     D  USERID               254    261
      *  SOURCE LIBRARY
     D  SLIBR                314    323
      *
     C                   MOVEL     *BLANKS       VCO
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131416
     C                   SETOFF                                       172023
     C                   SETOFF                                       2122
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              DO
     C                   SETON                                        LR
     C                   GOTO      END
     C                   ENDDO
      *
      * TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C   10              GOTO      RSTRTA
     C     VACTOK        TAG
      *
     C     VCO           CHAIN     FMCORG                             90
     C   90              SETON                                        2021
     C   20              GOTO      RSTRTA
      *
     C     VACT          IFEQ      'A'
     C     VCO           CHAIN     FGLCTL                             92                    K
     C  N92              SETON                                        2022
     C   22              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C     VCO           CHAIN     FGLCTL                             92                    K
     C   92              SETON                                        2023
     C   23              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VCO           IFGT      0
     C     VACT          ANDEQ     'A'
     C                   Z-ADD     1             GZCONS
     C                   ENDIF
      *
     C     VCO           IFGT      0
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
      * COMPANY 00
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   SETOFF                                       102090
     C                   READ      SCRNB                                  90
      *
     C   KF              GOTO      RSTRTA
     C   KC
     COR KG              GOTO      END
      *
     C     GZPRCO        IFEQ      0
     C                   SETON                                        10
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     GZPRCO        CHAIN     FMCORG                             90
     C   90              SETON                                        10
     C   10              GOTO      RSTRTB
      *
     C     GZNMCO        IFEQ      0
     C                   SETON                                        20
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   EXSR      CREC
     C                   GOTO      RSTRTA
      *
     C     RSTRTC        TAG
     C                   WRITE     SCRNC
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   SETOFF                                       40
      *
     C                   READ      SCRNC                                  90
      *
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRTA
      *
     C     GZPRTR        IFEQ      *BLANKS
     C                   SETON                                        10
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     GZCONS        IFEQ      0
     C                   SETON                                        20
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     GZDETL        IFEQ      0
     C                   SETON                                        30
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     GZBUDG        IFNE      'Y'
     C     GZBUDG        ANDNE     'N'
     C                   SETON                                        40
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C                   EXSR      CREC
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C                   SETON                                        LR
      ********
      * CREC *
      ********
     C     CREC          BEGSR
     C     VACT          IFEQ      'A'
     C                   Z-ADD     VCO           GZCOMP
     C                   WRITE     RGLCTL
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RGLCTL
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RGLCTL
     C                   ENDIF
     C                   ENDSR
      *
