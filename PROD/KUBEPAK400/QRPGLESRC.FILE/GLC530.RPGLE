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
      *PROGRAM NAME-------- GLC530
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- FORMATTED TRIAL BALANCE PROMPT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFMAPER    IF   E           K DISK
     FFGLREF    IF   E           K DISK
     FGLC530FM  CF   E             WORKSTN
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
     D  LCO                    1      2  0                                      GLR360
     D  LACTP                  3      4  0                                      GLR360
     D  LBEGDT                 5     10  0                                      GLR360
     D  LENDDT                11     16  0                                      GLR360
     D  FORMAT                17     24                                         GLR360
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
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     0             LACTP
     C                   MOVE      *BLANKS       FORMAT
     C                   MOVEA     '0'           *IN
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       1011
     C                   SETOFF                                       205051
     C                   SETOFF                                       525354
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              DO
     C                   MOVE      'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C   KF              GOTO      RSTART
      * GET FORMAT
     C                   MOVEL     FORMAT        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       GXLOOK           15
     C                   Z-ADD     3             GXRTYP
     C                   CALL      'LKGLRF'
     C                   PARM                    GXLOOK
     C                   PARM                    GXRPRT
     C                   PARM                    GXRTYP
     C                   MOVEL     *BLANKS       FORMAT
     C                   MOVEL     GXRPRT        FORMAT
     C                   GOTO      NXTA
     C                   ENDIF
     C     REFKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    FORMAT
     C     REFKEY        CHAIN     FGLREF                             10
     C   10              GOTO      NXTA
     C  N10              DO
     C     GXRTYP        IFNE      3
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   END
     C                   ENDDO
      *
     C   KB              DO
     C                   Z-ADD     LCO           ACCOMP            2 0
     C                   Z-ADD     0             ACTP              2 0
     C                   CALL      'LKACTP'
     C                   PARM                    ACCOMP
     C                   PARM                    ACTP
     C                   Z-ADD     ACTP          LACTP
     C                   GOTO      NXTA
     C                   ENDDO
      *
      *
     C     LACTP         IFLE      *ZEROS                                                   K
     C     LACTP         ORGT      13                                                       K
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C     ACST13        IFEQ      *ZEROS                                                   K
     C     LACTP         ANDEQ     13                                                       K
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * GET PERIOD DATES
      *
     C                   Z-ADD     LCO           CONO
     C                   Z-ADD     LACTP         ACTPER
     C                   Z-ADD     0             BEGDAT            6 0
     C                   Z-ADD     0             ENDDAT            6 0
     C                   Z-ADD     0             BGCYMD            7 0
     C                   Z-ADD     0             ENCYMD            7 0
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
     C     END           TAG
     C                   SETON                                        LR
      **
