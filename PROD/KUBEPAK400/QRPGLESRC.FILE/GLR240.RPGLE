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
      *PROGRAM NAME-------- GLR240
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- INTERACTIVE BUDGET ENTRY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FGLR240FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMGLCH    IF   E           K DISK
     FFGLBAL    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFGLBUD    UF A E           K DISK
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
     C                   PARM                    LCO
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
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VGL           IFEQ      0                                                        K
     C     VDEPT         ANDGT     *ZEROS                                                   K
     C                   SETON                                        2021
     C                   GOTO      NXTA
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
      * CHECK TO SEE IF GLBUD EXISTS
      *
     C                   MOVEL     VGL           VGLNO             8 0
     C                   MOVE      VDEPT         VGLNO
     C     BKEY          KLIST
     C                   KFLD                    LCO
     C                   KFLD                    VGLNO
     C     BKEY          CHAIN     FGLBUD                             94
      *
     C  N94VACT          IFEQ      'A'
     C                   SETON                                        2022                  NCE
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C   94VACT          IFEQ      'C'
     C     VACT          OREQ      'D'
     C                   SETON                                        2023                  NCE
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * CHECK TO SEE IF GLBAL EXISTS
      *
     C     BKEY          CHAIN     FGLBAL                             95
      *
     C     LCO           CHAIN     FMAPER                             90
     C     ACMPCN        IFEQ      'M'
     C                   SETON                                        77
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     1             CNT               2 0
     C                   SETOFF                                       1011
     C                   SETOFF                                       1516
     C                   SETOFF                                       2021
     C                   SETOFF                                       2526
     C                   SETOFF                                       3031
     C                   SETOFF                                       3536
     C                   SETOFF                                       4041
     C                   SETOFF                                       4546
     C                   SETOFF                                       5051
     C                   SETOFF                                       5556
     C                   SETOFF                                       6061
     C                   SETOFF                                       6566
     C                   SETOFF                                       7071
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRTA
      *
     C     V$1           IFNE      0
     C     VA1           ANDNE     0
     C     V$1           ORNE      0
     C     VB1           ANDNE     0
     C     VA1           ORNE      0
     C     VB1           ANDNE     0
     C                   SETON                                        1011
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     V$2           IFNE      0
     C     VA2           ANDNE     0
     C     V$2           ORNE      0
     C     VB2           ANDNE     0
     C     VA2           ORNE      0
     C     VB2           ANDNE     0
     C                   SETON                                        1516
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     V$3           IFNE      0
     C     VA3           ANDNE     0
     C     V$3           ORNE      0
     C     VB3           ANDNE     0
     C     VA3           ORNE      0
     C     VB3           ANDNE     0
     C                   SETON                                        2021
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     V$4           IFNE      0
     C     VA4           ANDNE     0
     C     V$4           ORNE      0
     C     VB4           ANDNE     0
     C     VA4           ORNE      0
     C     VB4           ANDNE     0
     C                   SETON                                        2526
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     V$5           IFNE      0
     C     VA5           ANDNE     0
     C     V$5           ORNE      0
     C     VB5           ANDNE     0
     C     VA5           ORNE      0
     C     VB5           ANDNE     0
     C                   SETON                                        3031
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     V$6           IFNE      0
     C     VA6           ANDNE     0
     C     V$6           ORNE      0
     C     VB6           ANDNE     0
     C     VA6           ORNE      0
     C     VB6           ANDNE     0
     C                   SETON                                        3536
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     V$7           IFNE      0
     C     VA7           ANDNE     0
     C     V$7           ORNE      0
     C     VB7           ANDNE     0
     C     VA7           ORNE      0
     C     VB7           ANDNE     0
     C                   SETON                                        4041
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     V$8           IFNE      0
     C     VA8           ANDNE     0
     C     V$8           ORNE      0
     C     VB8           ANDNE     0
     C     VA8           ORNE      0
     C     VB8           ANDNE     0
     C                   SETON                                        4546
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     V$9           IFNE      0
     C     VA9           ANDNE     0
     C     V$9           ORNE      0
     C     VB9           ANDNE     0
     C     VA9           ORNE      0
     C     VB9           ANDNE     0
     C                   SETON                                        5051
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     V$10          IFNE      0
     C     VA10          ANDNE     0
     C     V$10          ORNE      0
     C     VB10          ANDNE     0
     C     VA10          ORNE      0
     C     VB10          ANDNE     0
     C                   SETON                                        5556
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     V$11          IFNE      0
     C     VA11          ANDNE     0
     C     V$11          ORNE      0
     C     VB11          ANDNE     0
     C     VA11          ORNE      0
     C     VB11          ANDNE     0
     C                   SETON                                        6061
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     V$12          IFNE      0
     C     VA12          ANDNE     0
     C     V$12          ORNE      0
     C     VB12          ANDNE     0
     C     VA12          ORNE      0
     C     VB12          ANDNE     0
     C                   SETON                                        6566
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C   77              GOTO      NOPER
     C     V$13          IFNE      0
     C     VA13          ANDNE     0
     C     V$13          ORNE      0
     C     VB13          ANDNE     0
     C     VA13          ORNE      0
     C     VB13          ANDNE     0
     C                   SETON                                        7071
     C                   GOTO      NXTB
     C                   ENDIF
     C     NOPER         TAG
      *
     C     V$1           IFNE      O$1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     V$1           O$1              11 2
     C     V$2           IFNE      O$2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     V$2           O$2              11 2
     C     V$3           IFNE      O$3
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     V$3           O$3              11 2
     C     V$4           IFNE      O$4
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     V$4           O$4              11 2
     C     V$5           IFNE      O$5
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     V$5           O$5              11 2
     C     V$6           IFNE      O$6
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     V$6           O$6              11 2
     C     V$7           IFNE      O$7
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     V$7           O$7              11 2
     C     V$8           IFNE      O$8
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     V$8           O$8              11 2
     C     V$9           IFNE      O$9
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     V$9           O$9              11 2
     C     V$10          IFNE      O$10
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     V$10          O$10             11 2
     C     V$11          IFNE      O$11
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     V$11          O$11             11 2
     C     V$12          IFNE      O$12
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     V$12          O$12             11 2
     C     V$13          IFNE      O$13
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     V$13          O$13             11 2
     C     VA1           IFNE      OA1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VA1           OA1              11 2
     C     VA2           IFNE      OA2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VA2           OA2              11 2
     C     VA3           IFNE      OA3
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VA3           OA3              11 2
     C     VA4           IFNE      OA4
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VA4           OA4              11 2
     C     VA5           IFNE      OA5
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VA5           OA5              11 2
     C     VA6           IFNE      OA6
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VA6           OA6              11 2
     C     VA7           IFNE      OA7
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VA7           OA7              11 2
     C     VA8           IFNE      OA8
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VA8           OA8              11 2
     C     VA9           IFNE      OA9
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VA9           OA9              11 2
     C     VA10          IFNE      OA10
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VA10          OA10             11 2
     C     VA11          IFNE      OA11
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VA11          OA11             11 2
     C     VA12          IFNE      OA12
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VA12          OA12             11 2
     C     VA13          IFNE      OA13
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VA13          OA13             11 2
     C     VB1           IFNE      OB1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VB1           OB1              11 2
     C     VB2           IFNE      OB2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VB2           OB2              11 2
     C     VB3           IFNE      OB3
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VB3           OB3              11 2
     C     VB4           IFNE      OB4
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VB4           OB4              11 2
     C     VB5           IFNE      OB5
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VB5           OB5              11 2
     C     VB6           IFNE      OB6
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VB6           OB6              11 2
     C     VB7           IFNE      OB7
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VB7           OB7              11 2
     C     VB8           IFNE      OB8
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VB8           OB8              11 2
     C     VB9           IFNE      OB9
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VB9           OB9              11 2
     C     VB10          IFNE      OB10
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VB10          OB10             11 2
     C     VB11          IFNE      OB11
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VB11          OB11             11 2
     C     VB12          IFNE      OB12
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VB12          OB12             11 2
     C     VB13          IFNE      OB13
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VB13          OB13             11 2
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
     C                   Z-ADD     VA1           GBN01
     C                   Z-ADD     VA2           GBN02
     C                   Z-ADD     VA3           GBN03
     C                   Z-ADD     VA4           GBN04
     C                   Z-ADD     VA5           GBN05
     C                   Z-ADD     VA6           GBN06
     C                   Z-ADD     VA7           GBN07
     C                   Z-ADD     VA8           GBN08
     C                   Z-ADD     VA9           GBN09
     C                   Z-ADD     VA10          GBN10
     C                   Z-ADD     VA11          GBN11
     C                   Z-ADD     VA12          GBN12
     C                   Z-ADD     VA13          GBN13
     C     VACT          IFEQ      'A'
     C                   MOVEL     'A'           GBSTAT
     C                   WRITE     RGLBUD
     C                   ENDIF
     C     VACT          IFEQ      'C'
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
      *
      *********
      * CLRFLD
      *********
     C     CLRFLD        BEGSR
     C                   Z-ADD     1             CNT               2 0
     C                   Z-ADD     0             VGL
     C                   Z-ADD     0             VDEPT
     C                   ENDSR
**
Asset
Liability
Revenue
Expense
