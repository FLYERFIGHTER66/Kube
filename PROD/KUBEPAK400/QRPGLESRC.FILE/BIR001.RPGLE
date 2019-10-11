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
      *PROGRAM NAME-------- BIR001
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- DISTRIBUTION CONTROL FILE MAINTENANCE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FBIR001FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMCOMP    UF A E           K DISK
     FFMCORG    IF   E           K DISK
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
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     RSTRTA        TAG
     C                   EXSR      CLRIT
     C                   UNLOCK    FMCOMP
     C                   WRITE     SCRNA
     C                   SETOFF                                       102021
     C                   SETOFF                                       222324
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              GOTO      END
      *
      * TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C                   GOTO      RSTRTA
     C     VACTOK        TAG
      *
     C                   MOVE      VCO           VCOR              2
     C     VCOR          IFEQ      *BLANKS
     C                   SETON                                        2021
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C                   MOVEL     VCO           COMP              2 0
     C     COMP          IFGT      0
     C     COMP          CHAIN     FMCORG                             91
     C   91              SETON                                        2024
     C   24              GOTO      RSTRTA
     C                   ENDIF
      *
     C     COMP          CHAIN     FMCOMP                             90
      *
     C  N90VACT          IFEQ      'A'
     C                   SETON                                        2022
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C   90VACT          IFNE      'A'
     C                   SETON                                        2023
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VCO           IFEQ      '00'
     C     VACT          ANDEQ     'A'
     C                   MOVEL     'N'           MCPCOV
     C                   ENDIF
      *
     C     VCO           IFEQ      '00'
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        16
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C                   MOVEL     'N'           MCTXFR
     C                   MOVEL     'N'           MCTXSP
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       203035
     C                   SETOFF                                       405052
     C                   SETOFF                                       545698
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRTA
      *
     C     MCMSG1        IFNE      OMSG1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     MCMSG1        OMSG1            30
      *
     C     MCMSG2        IFNE      OMSG2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     MCMSG2        OMSG2            30
      *
     C     MCMSG3        IFNE      OMSG3
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     MCMSG3        OMSG3            30
      *
     C     MCMSG4        IFNE      OMSG4
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     MCMSG4        OMSG4            30
      *
     C     MCTXFR        IFNE      'Y'
     C     MCTXFR        ANDNE     'N'
     C                   SETON                                        30
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     MCTXFR        IFNE      OTXFR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     MCTXFR        OTXFR             1
      *
     C     MCTXSP        IFNE      'Y'
     C     MCTXSP        ANDNE     'N'
     C                   SETON                                        35
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     MCTXSP        IFNE      OTXSP
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     MCTXSP        OTXSP             1
      *
     C     MCRQDT        IFEQ      0
     C                   GOTO      NODTE
     C                   ENDIF
     C                   Z-ADD     MCRQDT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        40
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     NODTE         TAG
      *
     C     MCRQDT        IFNE      ORQDT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     MCRQDT        ORQDT             6 0
      *
     C     MCNORD        IFEQ      0
     C                   SETON                                        50
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     MCNORD        IFNE      ONORD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     MCNORD        ONORD             6 0
      *
     C     MCNINV        IFEQ      0
     C                   SETON                                        52
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     MCNINV        IFNE      ONINV
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     MCNINV        ONINV             6 0
      *
     C     MCNCMN        IFEQ      0
     C                   SETON                                        54
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     MCNCMN        IFNE      ONCMN
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     MCNCMN        ONCMN             6 0
      *
     C     MCNPO#        IFEQ      0
     C                   SETON                                        56
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     MCNPO#        IFNE      ONPO#
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     MCNPO#        ONPO#             6 0
      *
     C     MCHDG1        IFNE      OHDG1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     MCHDG1        OHDG1             4
      *
     C     MCHDG2        IFNE      OHDG2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     MCHDG2        OHDG2             4
      *
     C     MCHDG3        IFNE      OHDG3
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     MCHDG3        OHDG3             4
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   Z-ADD     COMP          MCCOMP
     C                   EXSR      CREC
     C                   GOTO      RSTRTA
      *
     C     RSTRTC        TAG
     C                   WRITE     SCRNC
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       203040
     C                   SETOFF                                       5060
     C                   READ      SCRNC                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
      *
     C     MCNAME        IFEQ      *BLANKS
     C                   SETON                                        20
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     MCNAME        IFNE      ONAME
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     MCNAME        ONAME            30
      *
     C     MCNCUS        IFEQ      0
     C                   SETON                                        30
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     MCNCUS        IFNE      ONCUS
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     MCNCUS        ONCUS             6 0
      *
     C     MCPCOV        IFNE      'Y'
     C     MCPCOV        ANDNE     'N'
     C                   SETON                                        40
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     MCPCOV        IFNE      OPCOV
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     MCPCOV        OPCOV             1
      *
     C     MCPRCO        IFEQ      0
     C                   SETON                                        50
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     MCPRCO        IFNE      OPRCO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     MCPRCO        OPRCO             2 0
      *
     C     MCNMCO        IFEQ      0
     C                   SETON                                        60
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     MCNMCO        IFNE      ONMCO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     MCNMCO        ONMCO             2 0
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C                   EXSR      CREC
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      *******
      * CREC
      *******
     C     CREC          BEGSR
     C     VACT          IFEQ      'A'
     C                   WRITE     RMCOMP
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RMCOMP
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RMCOMP
     C                   ENDIF
     C                   ENDSR
      ********
      * CLRIT
      ********
      *
     C     CLRIT         BEGSR
     C                   MOVE      *ZEROS        VCO
     C     ECLRFL        ENDSR
      *
