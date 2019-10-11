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
      *PROGRAM NAME--------- APC110
      *APPLICATION---------- ACCOUNTS PAYABLE
      *DESCRIPTION---------- VENDOR MASTER LIST
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FAPC110FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     D  LSEQ                   3      3  0
     D  LBVEND                 4      9  0
     D  LEVEND                10     15  0
     D  LBALPH                16     30
     D  LEALPH                31     45
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
     C                   Z-ADD     0             LBVEND
     C                   Z-ADD     0             LEVEND
     C                   Z-ADD     1             LSEQ
     C                   Z-ADD     1             VOUT
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102021
     C                   SETOFF                                       223031
     C                   SETOFF                                       325051
     C                   SETOFF                                       525354
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C     LSEQ          IFLT      1                                                        K
     C     LSEQ          ORGT      2                                                        K
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LSEQ          IFEQ      1
     C     LBVEND        ANDGT     *ZEROS
     C                   SETON                                        2021
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LBVEND        IFGT      LEVEND                                                   K
     C                   SETON                                        2022
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LBVEND        IFEQ      0                                                        K
     C     LEVEND        ANDGT     0
     C                   SETON                                        2022
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LBVEND        IFGT      0
     C     LEVEND        ANDEQ     0
     C                   Z-ADD     LBVEND        LEVEND
     C                   ENDIF
      *
     C     LSEQ          IFEQ      2
     C     LBALPH        ANDGT     *BLANKS
     C                   SETON                                        3031
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LEALPH        IFGT      *BLANKS                                                  K
     C     LBALPH        ANDEQ     *BLANKS                                                  K
     C                   SETON                                        3032
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LBALPH        IFGT      LEALPH                                                   K
     C                   SETON                                        3032
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LBALPH        IFGT      *BLANKS
     C     LEALPH        ANDEQ     *BLANKS
     C                   MOVEL     LBALPH        LEALPH
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
     C     END           TAG
     C                   SETON                                        LR
      **
