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
      *PROGRAM NAME-------- BIR000
      *SYSTEM-------------- DISTRIBUTION
      *APPLICATION--------- CONTROL FILE MAINTENANCE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FBIR000FM  CF   E             WORKSTN
     FFMCORG    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFHORDW    IF   E           K DISK
     FFHORCW    IF   E           K DISK
     FFSYSCTL   IF   E           K DISK
     FFOECTL    UF A E           K DISK
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
     C     RSTRT         TAG
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
     C     VCO           CHAIN     FOECTL                             92                    K
     C  N92              SETON                                        2022
     C   22              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C     VCO           CHAIN     FOECTL                             92                    K
     C   92              SETON                                        2023
     C   23              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VCO           IFGT      0
     C                   SETOFF                                       98
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
      * COMPANY 00
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102090
     C                   SETOFF                                       303132
     C                   SETOFF                                       404142
     C                   SETOFF                                       505152
     C                   READ      SCRNB                                  90
      *
     C   KF              GOTO      RSTRT
     C   KC
     COR KG              GOTO      END
      *
     C     OCPRCO        IFEQ      0
     C                   SETON                                        10
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     OCPRCO        CHAIN     FMCORG                             90
     C   90              SETON                                        10
     C   10              GOTO      RSTRTB
      *
     C     OCPRCO        IFNE      OPRCO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     OCPRCO        OPRCO             1 0
      *
     C     OCNMCO        IFEQ      0
     C                   SETON                                        20
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     OCNMCO        IFNE      ONMCO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     OCNMCO        ONMCO             1 0
      *
     C     OCNORD        IFEQ      0
     C                   SETON                                        3031
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     OCNORD        CHAIN     FHORDR                             90
     C  N90              SETON                                        3032
     C   32              GOTO      RSTRTB
      *
     C     OCNORD        IFNE      ONORD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     OCNORD        ONORD             6 0
      *
     C     OCNINV        IFEQ      0
     C                   SETON                                        4041
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     OCNINV        CHAIN     FHORDW                             90
     C  N90              SETON                                        4042
     C   42              GOTO      RSTRTB
      *
     C     OCNINV        IFNE      ONINV
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     OCNINV        ONINV             6 0
      *
     C     OCNCMN        IFEQ      0
     C                   SETON                                        5051
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     OCNCMN        CHAIN     FHORCW                             90
     C  N90              SETON                                        5052
     C   52              GOTO      RSTRTB
      *
     C     OCNCMN        IFNE      ONCMN
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     OCNCMN        ONCMN             6 0
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   EXSR      CREC
     C                   GOTO      RSTRT
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
     C   KF              GOTO      RSTRT
      *
     C     OCGL          IFNE      'Y'
     C     OCGL          ANDNE     'N'
     C                   SETON                                        10
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     OCGL          IFNE      OGL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     OCGL          OGL               1
      *
     C     OCTXFR        IFNE      'Y'
     C     OCTXFR        ANDNE     'N'
     C                   SETON                                        20
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     OCTXFR        IFNE      OTXFR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     OCTXFR        OTXFR             1
      *
     C     OCTXSP        IFNE      'Y'
     C     OCTXSP        ANDNE     'N'
     C                   SETON                                        30
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     OCTXSP        IFNE      OTXSP
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     OCTXSP        OTXSP             1
      *
     C     OCRQDT        IFEQ      0
     C                   GOTO      NODTE
     C                   ENDIF
      *
     C                   Z-ADD     OCRQDT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        40
     C                   GOTO      RSTRTC
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         RDATE             5 0
      *
     C     RDATE         IFLT      DDATE
     C                   SETON                                        40
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     NODTE         TAG
      *
     C     OCRQDT        IFNE      ORQDT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     OCRQDT        ORQDT             6 0
      *
     C     OCDAYS        IFNE      ODAYS
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     OCDAYS        ODAYS             3 0
      *
     C     OCCOM1        IFNE      OCOM1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     OCCOM1        OCOM1            60
      *
     C     OCCOM2        IFNE      OCOM2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     OCCOM2        OCOM2            60
      *
     C     OCCOM3        IFNE      OCOM3
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     OCCOM3        OCOM3            60
      *
     C     OCCOM4        IFNE      OCOM4
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     OCCOM4        OCOM4            60
      *
     C     OCHDG1        IFNE      OHDG1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     OCHDG1        OHDG1             4
      *
     C     OCHDG2        IFNE      OHDG2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     OCHDG2        OHDG2             4
      *
     C     OCHDG3        IFNE      OHDG3
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     OCHDG3        OHDG3             4
      *
     C     OCHDG4        IFNE      OHDG4
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     OCHDG4        OHDG4             4
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C                   EXSR      CREC
     C                   GOTO      RSTRT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      ********
      * CREC *
      ********
     C     CREC          BEGSR
     C     VACT          IFEQ      'A'
     C                   MOVEL     'A'           OCSTAT
     C                   Z-ADD     VCO           OCCOMP
     C                   WRITE     ROECTL
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    ROECTL
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    ROECTL
     C                   ENDIF
     C                   ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     TDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DDATE             5 0
      *
     C                   READ      FSYSCTL                                90
     C     ZZTYPE        IFEQ      'G'
     C                   SETON                                        77
     C                   ENDIF
      *
     C                   ENDSR
