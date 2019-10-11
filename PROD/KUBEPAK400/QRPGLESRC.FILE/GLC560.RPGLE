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
      *PROGRAM NAME-------- GLC560
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- DEPARTMENTAL INCOME STATEMENT
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMAPER    IF   E           K DISK
     FFGLREF    IF   E           K DISK
     FGLC560FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     D  LACTP                  3      4  0
     D  LREF                   5     12
     D  LBEGDT                13     18  0
     D  LENDDT                19     24  0
     D  LPRI                  25     25
     D  LPCT                  26     26
     D  LDOL                  27     27
     D  LPYP                  28     28
     D  LCYW                  29     29
     D  LCYR                  30     30
     D  LCYT                  31     31
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
     C                   SETOFF                                       98
     C                   Z-ADD     1             VOUT
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102050
     C                   SETOFF                                       515253
     C                   SETOFF                                       54
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C                   MOVEL     *BLANKS       LCANCL
      *
     C   KB              DO
     C                   Z-ADD     LCO           ACCOMP            2 0
     C                   CALL      'LKACTP'
     C                   PARM                    ACCOMP
     C                   PARM                    VACTP
     C                   GOTO      RSTRT
     C                   ENDDO
      *
     C                   Z-ADD     VACTP         LACTP
     C                   MOVEL     VREF          LREF
      *
     C     VACTP         IFLE      *ZEROS                                                   K
     C     VACTP         ORGT      13                                                       K
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C     ACST13        IFEQ      *ZEROS                                                   K
     C     VACTP         ANDEQ     13                                                       K
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
      *
      * GET PERIOD DATES
      *
     C                   Z-ADD     VACTP         ACTPER
     C                   Z-ADD     LCO           CONO
     C                   CALL      'GETPDAT'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     BEGDAT        LBEGDT
     C                   Z-ADD     ENDDAT        LENDDT
      *
     C                   MOVEL     VREF          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       GXLOOK           15
     C                   CALL      'LKGLRF'
     C                   PARM                    GXLOOK           15
     C                   PARM                    GXRPRT            8
     C                   MOVEL     *BLANKS       VREF
     C                   MOVEL     GXRPRT        VREF
     C                   MOVEL     GXLOOK        VDESC
     C                   SETON                                        99
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     VREF          IFEQ      *BLANKS
     C                   SETON                                        20
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     VREF          IFGT      *BLANKS
     C                   MOVEL     *BLANKS       GXLOOK
     C     KEY23         KLIST
     C                   KFLD                    GXLOOK
     C                   KFLD                    LCO
     C                   KFLD                    VREF
     C     KEY23         CHAIN     FGLREF                             90
     C   90              SETON                                        20
     C   20              GOTO      RSTRT
     C                   ENDIF
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        53
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     VOUT          IFEQ      1
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*NO '        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      2
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      3
     C                   MOVEL     '*YES'        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      *
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             ERROR             1 0
     C                   SETOFF                                       707172
     C                   SETOFF                                       737475
     C                   SETOFF                                       767778
     C                   SETOFF                                       79
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C                   MOVEL     VPRIR         LPRI
     C                   MOVEL     VPRCNT        LPCT
     C                   MOVEL     VDOLL         LDOL
     C                   MOVEL     VPYPCT        LPYP
     C                   MOVEL     VCYWDL        LCYW
     C                   MOVEL     VCYWR         LCYR
     C                   MOVEL     VCYTDL        LCYT
      *
     C     VPRIR         IFGT      *BLANKS                                                  Q
     C     VPRIR         ANDNE     'Y'                                                      Q
     C                   SETON                                        7077
     C   70              GOTO      NXTB
     C                   ENDIF
      *
     C     VPRIR         IFEQ      'Y'                                                      Q
     C                   ADD       1             ERROR             1 0
     C                   ENDIF
      *
     C     VPRCNT        IFGT      *BLANKS                                                  Q
     C     VPRCNT        ANDNE     'Y'                                                      Q
     C                   SETON                                        71
     C   71              GOTO      NXTB
     C                   ENDIF
     C     VPRCNT        IFEQ      'Y'                                                      Q
     C                   ADD       1             ERROR             1 0
     C                   ENDIF
      *
     C     VDOLL         IFGT      *BLANKS                                                  Q
     C     VDOLL         ANDNE     'Y'                                                      Q
     C                   SETON                                        72
     C   72              GOTO      NXTB
     C                   ENDIF
     C     VDOLL         IFEQ      'Y'                                                      Q
     C                   ADD       1             ERROR             1 0
     C                   ENDIF
      *
     C     VPYPCT        IFGT      *BLANKS                                                  Q
     C     VPYPCT        ANDNE     'Y'                                                      Q
     C                   SETON                                        73
     C   73              GOTO      NXTB
     C                   ENDIF
     C     VPYPCT        IFEQ      'Y'                                                      Q
     C                   ADD       1             ERROR             1 0
     C                   ENDIF
      *
     C     VCYWDL        IFGT      *BLANKS                                                  Q
     C     VCYWDL        ANDNE     'Y'                                                      Q
     C                   SETON                                        74
     C   74              GOTO      NXTB
     C                   ENDIF
     C     VCYWDL        IFEQ      'Y'                                                      Q
     C                   ADD       1             ERROR             1 0
     C                   ENDIF
      *
     C     VCYWR         IFGT      *BLANKS                                                  Q
     C     VCYWR         ANDNE     'Y'                                                      Q
     C                   SETON                                        75
     C   75              GOTO      NXTB
     C                   ENDIF
     C     VCYWR         IFEQ      'Y'                                                      Q
     C                   ADD       1             ERROR             1 0
     C                   ENDIF
      *
     C     VCYTDL        IFGT      *BLANKS                                                  Q
     C     VCYTDL        ANDNE     'Y'                                                      Q
     C                   SETON                                        76
     C   76              GOTO      NXTB
     C                   ENDIF
     C     VCYTDL        IFEQ      'Y'                                                      Q
     C                   ADD       1             ERROR             1 0
     C                   ENDIF
      *
     C     ERROR         IFGT      1
     C                   SETON                                        7778
     C                   GOTO      NXTB
     C                   ENDIF
     C     ERROR         IFLT      1
     C                   SETON                                        7779
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      **
