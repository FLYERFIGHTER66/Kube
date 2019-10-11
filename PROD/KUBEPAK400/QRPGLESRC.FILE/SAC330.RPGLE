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
      *PROGRAM NAME-------- SAC330
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- SALES ANALYSIS BY ITEM
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMSIZE    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FSAC330FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
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
     D  LMONTH                 3      4  0
     D  LDOLUN                 5      5  0
     D  LGROSS                 6      6
     D  LDORP                  7      7
     D  LSSIZE                 8     10
     D  LESIZE                11     13
     D  LACTIV                14     14
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
     C                   MOVEL     'N'           VGROSS
     C                   MOVEL     'Y'           VACTIV
     C                   MOVEL     *BLANKS       VPERDO
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       161718
     C                   SETOFF                                       192145
     C                   SETOFF                                       222346
     C                   SETOFF                                       203040
     C                   SETOFF                                       909899
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C                   MOVEL     *BLANKS       LCANCL
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
     C     VDOLUN        IFLT      1                                                        K
     C     VDOLUN        ORGT      3                                                        K
     C                   SETON                                        16
     C   16              GOTO      NXTA
     C                   ENDIF
      *
     C     VSSIZE        IFEQ      *BLANKS
     C     VESIZE        ANDEQ     *BLANKS
     C                   GOTO      NOSIZE
     C                   ENDIF
      *
     C     1             SUBST     VSSIZE:1      VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     VSSIZE        VSIZE             3
     C                   EXSR      SIZELK
     C                   MOVEL     VSIZE         VSSIZE
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     1             SUBST     VESIZE:1      VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     VESIZE        VSIZE             3
     C                   EXSR      SIZELK
     C                   MOVEL     VSIZE         VESIZE
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VSSIZE        CHAIN     FMSIZE                             90
     C   90              SETON                                        45
     C   45              GOTO      NXTA
      *
     C     VSSIZE        IFGT      *BLANKS                                                  K
     C     VESIZE        ANDEQ     *BLANKS                                                  K
     C                   MOVEL     VSSIZE        VESIZE
     C                   ENDIF
      *
     C     VESIZE        CHAIN     FMSIZE                             90
     C   90              SETON                                        46
     C   46              GOTO      NXTA
      *
     C     VSSIZE        IFGT      VESIZE
     C                   SETON                                        45
     C                   GOTO      NXTA
     C                   ENDIF
     C     NOSIZE        TAG
      *
     C     VDOLUN        IFNE      1                                                        K
     C     VGROSS        ANDEQ     'Y'                                                      K
     C                   SETON                                        2217
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VGROSS        IFNE      'Y'                                                      K
     C     VGROSS        ANDNE     'N'                                                      K
     C                   SETON                                        1723
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VGROSS        IFEQ      'Y'                                                      K
     C     VPERDO        ANDNE     '$'                                                      K
     C     VPERDO        ANDNE     '%'                                                      K
     C                   SETON                                        1821
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VGROSS        IFEQ      'N'                                                      K
     C     VPERDO        ANDGT     *BLANKS                                                  K
     C                   SETON                                        1819
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C     ACST13        IFEQ      *ZEROS                                                   K
     C     VACTP         ANDEQ     13                                                       K
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACTIV        IFNE      'Y'                                                      K
     C     VACTIV        ANDNE     'N'                                                      K
     C                   SETON                                        77
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     VACTP         LMONTH
     C                   Z-ADD     LCO           LCO
     C                   MOVEL     VSSIZE        LSSIZE
     C                   MOVEL     VESIZE        LESIZE
     C                   Z-ADD     VACTP         LMONTH
     C                   Z-ADD     VDOLUN        LDOLUN
     C                   MOVEL     VPERDO        LDORP
     C                   MOVEL     VGROSS        LGROSS
     C                   MOVEL     VACTIV        LACTIV
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      *********
      * SIZELK
      *********
     C     SIZELK        BEGSR
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       VSIZE             3
     C                   MOVEL     SZCODE        VSIZE
     C                   MOVEL     SZDESC        SNAME            10
     C                   ENDSR
