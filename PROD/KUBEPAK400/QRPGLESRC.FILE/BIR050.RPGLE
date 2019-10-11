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
      *PROGRAM NAME-------- BIR050
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- MAINTAIN RECORDS IN THE G/L DEFAULT FILE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FBIR050FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMCORG    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFGLDF     UF A E           K DISK
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
     D                UDS
     D  LCO                    1      2  0
     D  LLIST                  3      3
     D  LCANCL               133    133
      *
     C     RSTRTA        TAG
     C                   MOVEL     'Y'           VDIST
     C                   MOVEL     'Y'           VFIN
     C                   Z-ADD     0             VCO
     C                   SETOFF                                       992425
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101190
     C                   SETOFF                                       242599
     C                   READ      SCRNA                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
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
     C                   GOTO      NXTA
     C     VACTOK        TAG
      *
     C     VCO           IFEQ      0                                                        K
     C                   SETON                                        1112
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCO           CHAIN     FMCORG                             90
     C   90              SETON                                        1112
     C   11              GOTO      NXTA
      *
     C                   MOVEL     VCO           GDCOMP
     C                   MOVEL     '01'          GDTYPE
     C     KEY4          KLIST
     C                   KFLD                    VCO
     C                   KFLD                    GDTYPE
     C     KEY4          CHAIN     FGLDF                              90
      *
     C  N90VACT          IFEQ      'A'
     C                   SETON                                        1312
     C   13              GOTO      NXTA
     C                   ENDIF
      *
     C   90VACT          IFNE      'A'
     C                   SETON                                        1214
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     VCO           LCO
      *
      * SCRNB
      *
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   SETOFF                                       2021
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
      *
     C   KF              GOTO      RSTRTA
      *
     C     VDIST         IFNE      'Y'
     C     VDIST         ANDNE     'N'
     C                   SETON                                        20
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VFIN          IFNE      'Y'
     C     VFIN          ANDNE     'N'
     C                   SETON                                        21
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VDIST         IFEQ      'N'
     C                   SETON                                        24
     C                   ENDIF
      *
     C     VFIN          IFEQ      'N'
     C                   SETON                                        25
     C                   ENDIF
      *
     C   24
     CANN25              GOTO      NXTD
     C   24
     CAN 25              GOTO      NXTA
      *
      * SCRNC
      *
     C     NXTC          TAG
     C                   Z-ADD     1             C                 1 0
     C                   WRITE     SCRNC
     C                   SETOFF                                       303132
     C                   SETOFF                                       333435
     C                   SETOFF                                       363738
     C                   SETOFF                                       394041
     C                   SETOFF                                       424344
     C                   SETOFF                                       454647
     C                   SETOFF                                       48
     C                   READ      SCRNC                                  90
      *
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      NXTA
      *
     C     GDSALE        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDSALE
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDSALE        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        30
     C   99              GOTO      NXTC
      *
     C     GDINVN        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDINVN
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDINVN        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        31
     C   99              GOTO      NXTC
      *
     C     GDCOGS        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDCOGS
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDCOGS        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        32
     C   99              GOTO      NXTC
      *
     C     GDARRC        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDARRC
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDARRC        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        33
     C   99              GOTO      NXTC
      *
     C     GDFRGT        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDFRGT
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDFRGT        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        34
     C   99              GOTO      NXTC
      *
     C     GDSCHG        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDSCHG
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDSCHG        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        35
     C   99              GOTO      NXTC
      *
     C     GDVDSC        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDVDSC
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDVDSC        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        36
     C   99              GOTO      NXTC
      *
     C     GDTDSC        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDTDSC
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDTDSC        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        37
     C   99              GOTO      NXTC
      *
     C     GDLCHG        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDLCHG
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDLCHG        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        38
     C   99              GOTO      NXTC
      *
     C     GDCASH        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDCASH
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDCASH        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        39
     C   99              GOTO      NXTC
      *
     C     GDCDSC        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDCDSC
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDCDSC        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        40
     C   99              GOTO      NXTC
      *
     C     GDINAJ        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDINAJ
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDINAJ        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        41
     C   99              GOTO      NXTC
      *
     C     GDSTTX        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDSTTX
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDSTTX        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        42
     C   99              GOTO      NXTC
      *
     C     GDCOTX        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDCOTX
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDCOTX        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        43
     C   99              GOTO      NXTC
      *
     C     GDCITX        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDCITX
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDCITX        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        44
     C   99              GOTO      NXTC
      *
     C     GDAPEX        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDAPEX
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDAPEX        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        46
     C   99              GOTO      NXTC
      *
     C     GDPUNS        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDPUNS
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDPUNS        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        47
     C   99              GOTO      NXTC
      *
     C     GDINC$        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDINC$
     C                   GOTO      NXTC
     C                   ENDIF
     C                   Z-ADD     GDINC$        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        48
     C   99              GOTO      NXTC
     C*                    Z-ADDGDINC$    OINC$   80
      *
     C   25              GOTO      NOD
      *
      * SCRND
      *
     C     NXTD          TAG
     C                   WRITE     SCRND
     C                   SETOFF                                       303132
     C                   SETOFF                                       333435
     C                   SETOFF                                       363738
     C                   SETOFF                                       394041
     C                   SETOFF                                       424344
     C                   SETOFF                                       454647
     C                   SETOFF                                       48
     C                   READ      SCRND                                  90
      *
     C   KC
     COR KG              GOTO      END
      *
     C   KF              GOTO      NXTA
      *
     C     GDPAYR        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDPAYR
     C                   GOTO      NXTD
     C                   ENDIF
     C                   Z-ADD     GDPAYR        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        30
     C   99              GOTO      NXTD
      *
     C     GDFICA        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDFICA
     C                   GOTO      NXTD
     C                   ENDIF
     C                   Z-ADD     GDFICA        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        31
     C   99              GOTO      NXTD
      *
     C     GDPRCS        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDPRCS
     C                   GOTO      NXTD
     C                   ENDIF
     C                   Z-ADD     GDPRCS        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        32
     C   99              GOTO      NXTD
      *
     C     GDAFIX        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDAFIX
     C                   GOTO      NXTD
     C                   ENDIF
     C                   Z-ADD     GDAFIX        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        33
     C   99              GOTO      NXTD
      *
     C     GDFIT         IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDFIT
     C                   GOTO      NXTD
     C                   ENDIF
     C                   Z-ADD     GDFIT         GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        34
     C   99              GOTO      NXTD
      *
     C     GDCOLA        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDCOLA
     C                   GOTO      NXTD
     C                   ENDIF
     C                   Z-ADD     GDCOLA        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        35
     C   99              GOTO      NXTD
      *
     C     GDOTAX        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDOTAX
     C                   GOTO      NXTD
     C                   ENDIF
     C                   Z-ADD     GDOTAX        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        36
     C   99              GOTO      NXTD
      *
     C     GDONTX        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDONTX
     C                   GOTO      NXTD
     C                   ENDIF
     C                   Z-ADD     GDONTX        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        37
     C   99              GOTO      NXTD
      *
     C     GDAPPY        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDAPPY
     C                   GOTO      NXTD
     C                   ENDIF
     C                   Z-ADD     GDAPPY        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        38
     C   99              GOTO      NXTD
      *
     C     GDFRTI        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDFRTI
     C                   GOTO      NXTD
     C                   ENDIF
     C                   Z-ADD     GDFRTI        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        39
     C   99              GOTO      NXTD
      *
     C     GDINVN        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDINVN
     C                   GOTO      NXTD
     C                   ENDIF
     C                   Z-ADD     GDINVN        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        40
     C   99              GOTO      NXTD
      *
     C     GDPUNS        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDPUNS
     C                   GOTO      NXTD
     C                   ENDIF
     C                   Z-ADD     GDPUNS        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        41
     C   99              GOTO      NXTD
      *
     C     GDAPDS        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDAPDS
     C                   GOTO      NXTD
     C                   ENDIF
     C                   Z-ADD     GDAPDS        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        42
     C   99              GOTO      NXTD
      *
     C     GDAPCH        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDAPCH
     C                   GOTO      NXTD
     C                   ENDIF
     C                   Z-ADD     GDAPCH        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        43
     C   99              GOTO      NXTD
      *
     C  N24GDINC$        IFEQ      -0
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          GDINC$
     C                   GOTO      NXTD
     C                   ENDIF
     C  N24              Z-ADD     GDINC$        GLNO              8 0
     C                   EXSR      CKGL
     C   99              SETON                                        44
     C   99              GOTO      NXTD
      *
     C     NOD           TAG
     C                   MOVEL     'A'           GDSTAT
     C                   MOVEL     '01'          GDTYPE
     C                   MOVEL     USERID        GDUSER
     C                   Z-ADD     TDATE         GDDTLA
     C                   Z-ADD     TIMOD         GDTIME
     C     VACT          IFEQ      'A'
     C                   WRITE     RGLDF
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RGLDF
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RGLDF
     C                   ENDIF
     C                   GOTO      NXTA
      *
     C     END           TAG
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C                   SETON                                        LR
      *
      *********
      * CKGL  *
      *********
      *
     C     CKGL          BEGSR
      *
     C                   SETOFF                                       99
     C                   Z-ADD     VCO           GCCOMP
     C                   Z-ADD     GLNO          GCGLNO
     C     GKEY          KLIST
     C                   KFLD                    GCCOMP
     C                   KFLD                    GCGLNO
     C     GKEY          CHAIN     FMGLCH                             90
     C   90              SETON                                        99
      *
     C                   ENDSR
      *
      *********
      * LOOK  *
      *********
     C     LOOK          BEGSR
     C                   Z-ADD     VCO           GCCOMP
     C                   MOVEL     *BLANKS       GCLOOK
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    GCCOMP
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   MOVEL     GCGLNO        GLNO
     C                   ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
      *
