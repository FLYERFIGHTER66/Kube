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
      *PROGRAM NAME-------- GLC520
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- INCOME STATEMENT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMAPER    IF   E           K DISK
     FFGLREF    IF   E           K DISK
     FGLC520FM  CF   E             WORKSTN
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
     D  OPTION                25     25  0
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
     C     RSTART        TAG
     C                   MOVEA     '0'           *IN
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     0             VACTP
     C                   MOVE      *BLANKS       LREF
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       102050
     C                   SETOFF                                       515253
     C                   SETOFF                                       54  21
     C   KC
     COR KG              DO
     C                   MOVE      'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C   KF              GOTO      RSTART
      *
      *
     C                   MOVEL     LREF          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       GXLOOK           15
     C                   Z-ADD     2             GXRTYP
     C                   CALL      'LKGLRF'
     C                   PARM                    GXLOOK
     C                   PARM                    GXRPRT
     C                   PARM                    GXRTYP
     C                   MOVEL     *BLANKS       LREF
     C                   MOVEL     GXRPRT        LREF
     C                   MOVEL     GXLOOK        VDESC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LREF          IFEQ      *BLANKS
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LREF          IFGT      *BLANKS
     C                   MOVEL     *BLANKS       GXLOOK
     C     KEY23         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    LREF
     C     KEY23         CHAIN     FGLREF                             90
     C   90              SETON                                        20
     C   20              GOTO      NXTA
     C                   ENDIF
     C     GXRTYP        IFNE      2
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   ENDIF
     C   KB              DO
     C                   Z-ADD     LCO           ACCOMP            2 0
     C                   CALL      'LKACTP'
     C                   PARM                    ACCOMP
     C                   PARM                    VACTP
     C                   GOTO      NXTA
     C                   ENDDO
      *
     C                   Z-ADD     VACTP         LACTP
      *
     C     VACTP         IFLE      *ZEROS                                                   K
     C     VACTP         ORGT      13                                                       K
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C     ACST13        IFEQ      *ZEROS                                                   K
     C     VACTP         ANDEQ     13                                                       K
     C                   SETON                                        10
     C                   GOTO      NXTA
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
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        53
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      NXTA
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
     C     RSTRTB        TAG
     C                   Z-ADD     0             OPTION
     C                   SETOFF                                       10
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
     C                   SETOFF                                       10
     C   KC
     COR KG              DO
     C                   MOVE      'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C   KB              GOTO      NXTA
     C   KF              GOTO      RSTRTB
      *
      *
     C     OPTION        IFLE      0
     C     OPTION        ORGT      8
     C                   SETON                                        10
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      **
