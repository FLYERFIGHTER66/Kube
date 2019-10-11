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
      *PROGRAM NAME-------- SAC440
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- SALES ANALYSIS BY SLSPERSON, CUST, ITEM
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMAPER    IF   E           K DISK
     FFMSLSM    IF   E           K DISK
     FSAC440FM  CF   E             WORKSTN
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
      *
     D                UDS
     D  LCO                    1      2  0
     D  LMONTH                 3      4  0
     D  LDOLUN                 5      5  0
     D  LDORP                  6      6
     D  LGROSS                 7      7
     D  LFSLS                 11     12
     D  LTSLS                 13     14
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
     C                   Z-ADD     3             VDOLUN
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       161718
     C                   SETOFF                                       1921
     C                   SETOFF                                       222325
     C                   SETOFF                                       26
     C                   SETOFF                                       203040
     C                   SETOFF                                       909899
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
     C                   GOTO      NXTA
     C                   ENDDO
      *
     C     VACTP         IFLE      *ZEROS                                                   K
     C     VACTP         ORGT      13                                                       K
     C                   SETON                                        1011
     C   10
     CAN 11              GOTO      NXTA
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C     ACST13        IFEQ      *ZEROS                                                   K
     C     VACTP         ANDEQ     13                                                       K
     C                   SETON                                        1012
     C   12              GOTO      NXTA
     C                   ENDIF
      *
     C     VDOLUN        IFLT      1                                                        K
     C     VDOLUN        ORGT      3                                                        K
     C                   SETON                                        16
     C   16              GOTO      NXTA
     C                   ENDIF
      *
     C     VFSLS         IFEQ      '?'                                                      K
     C     VFSLS         OREQ      '/'                                                      K
     C                   MOVEL     VFSLS         SMSLSM            2
     C                   EXSR      SALELK
     C                   MOVEL     VSLS          VFSLS
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VFSLS         IFGT      *BLANKS                                                  K
     C     VFSLS         CHAIN     FMSLSM                             90                    K
     C   90              SETON                                        25
     C   25              GOTO      NXTA
     C                   ENDIF
      *
     C     VFSLS         IFGT      *BLANKS                                                  K
     C     VTSLS         ANDEQ     *BLANKS                                                  K
     C                   MOVEL     VFSLS         VTSLS
     C                   ENDIF
      *
     C     VTSLS         IFEQ      '?'                                                      K
     C     VTSLS         OREQ      '/'                                                      K
     C                   MOVEL     VTSLS         SMSLSM            2
     C                   EXSR      SALELK
     C                   MOVEL     VSLS          VTSLS
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VTSLS         IFGT      *BLANKS                                                  K
     C     VTSLS         CHAIN     FMSLSM                             90                    K
     C   90              SETON                                        26
     C   26              GOTO      NXTA
     C                   ENDIF
      *
     C     VFSLS         IFGT      *BLANKS                                                  K
     C     VTSLS         ANDEQ     *BLANKS                                                  K
     C                   SETON                                        26
     C   26              GOTO      NXTA
     C                   ENDIF
      *
     C     VFSLS         IFEQ      *BLANKS                                                  K
     C     VTSLS         ANDGT     *BLANKS                                                  K
     C                   SETON                                        25
     C   25              GOTO      NXTA
     C                   ENDIF
      *
     C     VFSLS         IFGT      *BLANKS                                                  K
     C     VFSLS         ANDGT     VTSLS                                                    K
     C                   SETON                                        25
     C   25              GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     VACTP         LMONTH
     C                   MOVEL     VFSLS         LFSLS
     C                   MOVEL     VTSLS         LTSLS
     C                   Z-ADD     VDOLUN        LDOLUN
      *
     C     END           TAG
     C                   SETON                                        LR
      *********
      * SALELK
      *********
     C     SALELK        BEGSR
     C                   CALL      'LKSALE'
     C                   PARM                    SMSLSM
     C                   PARM                    SMNAME           30
     C                   MOVEL     *BLANKS       VSLS              2
     C                   MOVEL     SMSLSM        VSLS
     C                   MOVEL     SMNAME        SNAME            30
     C                   ENDSR
      **
