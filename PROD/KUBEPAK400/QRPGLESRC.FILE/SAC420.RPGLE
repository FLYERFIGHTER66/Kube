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
      *PROGRAM NAME-------- SAC420
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- SALES ANALYSIS BY ITEM TOP RANKED
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMAPER    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FSAC420FM  CF   E             WORKSTN
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
     D  LRANK                  6     11  0
     D  LBPC                  12     13
     D  LEPC                  14     15
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
     C                   Z-ADD     0             VRANK
     C                   Z-ADD     1             VDOLUN
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101112
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
     C     VDOLUN        IFLT      1                                                        K
     C     VDOLUN        ORGT      2                                                        K
     C                   SETON                                        16
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VBPC          IFEQ      *BLANKS
     C                   GOTO      NOPC
     C                   ENDIF
      *
     C     1             SUBST     VBPC:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VBPC          VPRCL             2
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         VBPC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     1             SUBST     VEPC:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VEPC          VPRCL
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         VEPC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VBPC          CHAIN     FMPRCL                             90
     C   90              SETON                                        50
     C   50              GOTO      NXTA
      *
     C     VBPC          IFGT      *BLANKS                                                  K
     C     VEPC          ANDEQ     *BLANKS                                                  K
     C                   MOVEL     VBPC          VEPC
     C                   ENDIF
      *
     C     VEPC          CHAIN     FMPRCL                             90
     C   90              SETON                                        51
     C   51              GOTO      NXTA
      *
     C     VBPC          IFGT      VEPC
     C                   SETON                                        50
     C   50              GOTO      NXTA
     C                   ENDIF
      *
     C     NOPC          TAG
      *
     C                   Z-ADD     VACTP         LMONTH
     C                   Z-ADD     VRANK         LRANK
     C                   Z-ADD     VACTP         LMONTH
     C                   Z-ADD     VDOLUN        LDOLUN
     C                   MOVEL     VBPC          LBPC
     C                   MOVEL     VEPC          LEPC
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      *********
      * PCSR
      *********
     C     PCSR          BEGSR
     C                   MOVEL     VPRCL         PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VPRCL
     C                   MOVEL     PCPRCL        VPRCL
     C                   MOVEL     PCDESC        VDESC            30
     C                   SETON                                        99
     C                   ENDSR
