      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1998
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
      **PROGRAM NAME-------- SAC390
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS SALES ANALYSIS
      **PROGRAMMER---------- GD
      **APPLICATION--------- SALES ANALYSIS BY BILL TO CUSTOMER
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMAPER    IF   E           K DISK
     FFMCTYP    IF   E           K DISK
     FSAR390FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
     D                UDS
     D  LCO                    1      2  0
     D  LMONTH                 3      4  0
     D  LDOLUN                 5      5  0
     D  LDORP                  6      6
     D  LGROSS                 7      7
     D  LSTYP                  8      9
     D  LETYP                 10     11
     D  LACTIV                12     12
     D  LPROG                 29     36
     D  LNAME                 37     66
     D  LPRTR                100    109
     D  LFORM                110    113
     D  LCOPY                114    115  0
     D  LJOB                 116    116
     D  LHOLD                117    120
     D  LSAVE                121    124
     D  LCANCL               133    133
      *
      ****************************************************************
      ***  VALIDATE RESPONSES ON PROMPT SCREEN.
      *
     C                   SETOFF                                       98
     C                   Z-ADD     3             VDOLUN
     C                   MOVEL     'N'           VGROSS
     C                   MOVEL     *BLANKS       VPERDO
     C                   MOVEL     'Y'           VACTIV
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       161718
     C                   SETOFF                                       192150
     C                   SETOFF                                       222351
     C                   SETOFF                                       203040
     C                   SETOFF                                       909899
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C                   MOVEL     *BLANKS       LCANCL
     C   KB              Z-ADD     LCO           ACCOMP            2 0
     C   KB              CALL      'LKACTP'
     C                   PARM                    ACCOMP
     C                   PARM                    VACTP
     C   KB              GOTO      NXTA
      *
     C                   Z-ADD     VACTP         LMONTH
     C                   MOVEL     VSTYP         LSTYP
     C                   MOVEL     VETYP         LETYP
     C                   Z-ADD     VACTP         LMONTH
     C                   Z-ADD     VDOLUN        LDOLUN
     C                   MOVEL     VPERDO        LDORP
     C                   MOVEL     VGROSS        LGROSS
     C                   MOVEL     VACTIV        LACTIV
      *
     C     VACTP         IFLE      *ZEROS                                                   K
     C     VACTP         ORGT      13                                                       K
     C                   SETON                                        1011
     C   10
     CAN 11              GOTO      NXTA
     C                   ENDIF
      *
     C     VDOLUN        IFLT      1                                                        K
     C     VDOLUN        ORGT      3                                                        K
     C                   SETON                                        16
     C   16              GOTO      NXTA
     C                   ENDIF
      *
     C     VDOLUN        IFNE      1                                                        K
     C     VGROSS        ANDEQ     'Y'                                                      K
     C                   SETON                                        2217
     C   22
     CAN 17              GOTO      NXTA
     C                   ENDIF
      *
     C     VGROSS        IFNE      'Y'                                                      K
     C     VGROSS        ANDNE     'N'                                                      K
     C                   SETON                                        1723
     C   17
     CAN 23              GOTO      NXTA
     C                   ENDIF
      *
     C     VGROSS        IFEQ      'Y'                                                      K
     C     VPERDO        ANDNE     '$'                                                      K
     C     VPERDO        ANDNE     '%'                                                      K
     C                   SETON                                        1821
     C   21              GOTO      NXTA
     C                   ENDIF
      *
     C     VGROSS        IFEQ      'N'                                                      K
     C     VPERDO        ANDGT     *BLANKS                                                  K
     C                   SETON                                        1819
     C   19              GOTO      NXTA
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C     ACST13        IFEQ      *ZEROS                                                   K
     C     VACTP         ANDEQ     13                                                       K
     C                   SETON                                        1012
     C   12              GOTO      NXTA
     C                   ENDIF
      *
     C     VSTYP         IFEQ      *BLANKS
     C     VETYP         ANDEQ     *BLANKS
     C                   GOTO      NOTYP
     C                   ENDIF
      *
     C     VSTYP         IFEQ      '? '
     C                   MOVEL     VSTYP         VTYPE             2
     C                   EXSR      TYPELK
     C                   MOVEL     VTYPE         VSTYP
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VSTYP         CHAIN     FMCTYP                             90
     C   90              SETON                                        50
     C   50              GOTO      NXTA
      *
     C     VETYP         IFEQ      '? '
     C                   MOVEL     VETYP         VTYPE             2
     C                   EXSR      TYPELK
     C                   MOVEL     VTYPE         VETYP
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VETYP         CHAIN     FMCTYP                             90
     C   90              SETON                                        51
     C   51              GOTO      NXTA
      *
     C     VSTYP         IFGT      VETYP
     C   90              SETON                                        50
     C   50              GOTO      NXTA
     C                   ENDIF
     C     NOTYP         TAG
      *
     C     VACTIV        IFNE      'Y'                                                      K
     C     VACTIV        ANDNE     'N'                                                      K
     C                   SETON                                        77
     C   77              GOTO      NXTA
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      ************
      *  TYPELK
      ************
     C     TYPELK        BEGSR
     C                   MOVEL     VTYPE         CTTYPE            2
     C                   CALL      'LKTYPE'
     C                   PARM                    CTTYPE
     C                   PARM                    CTDESC           30
     C                   MOVEL     *BLANKS       VTYPE
     C                   MOVEL     CTTYPE        VTYPE
     C                   ENDSR
      *
