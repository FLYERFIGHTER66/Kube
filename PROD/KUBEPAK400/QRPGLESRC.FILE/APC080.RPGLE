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
      *PROGRAM NAME-------- APC080
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- VENDOR LABELS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FAPC080FM  CF   E             WORKSTN
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
     D  LSIZE                  3      3  0
     D  LORDER                 4      4  0
     D  LBTYPE                 5      5
     D  LETYPE                 6      6
     D  LBZIP                  7     11
     D  LEZIP                 12     16
     D  L1099                 17     17
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
     C                   Z-ADD     1             LSIZE
     C                   Z-ADD     1             LORD
     C                   Z-ADD     1             VOUT
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102050
     C                   SETOFF                                       515253
     C                   SETOFF                                       54
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C     LSIZE         IFEQ      *ZEROS                                                   K
     C     LSIZE         ORGT      2                                                        K
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LORD          IFEQ      *ZEROS                                                   K
     C     LORD          ORGT      3                                                        K
     C                   SETON                                        20
     C                   GOTO      RSTRT
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
     C   KE              GOTO      RSTRTB
      *
     C                   GOTO      END
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   SETOFF                                       102030
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C     LETYPE        IFNE      *BLANKS                                                  Q
     C     LBTYPE        ANDEQ     *BLANKS                                                  Q
     C                   SETON                                        10
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LBTYPE        IFGT      *BLANKS                                                  Q
     C     LETYPE        ANDEQ     *BLANKS                                                  Q
     C                   MOVEL     LBTYPE        LETYPE
     C                   ENDIF
      *
     C     LEZIP         IFNE      *BLANKS                                                  Q
     C     LBZIP         ANDEQ     *BLANKS                                                  Q
     C                   SETON                                        20
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LBZIP         IFGT      *BLANKS                                                  Q
     C     LEZIP         ANDEQ     *BLANKS                                                  Q
     C                   MOVEL     LBZIP         LEZIP
     C                   ENDIF
      *
     C     L1099         IFGT      *BLANKS                                                  Q
     C     L1099         ANDNE     'Y'                                                      Q
     C     L1099         ANDNE     'N'
     C                   SETON                                        30
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C   KB              GOTO      RSTRT
      *
     C     END           TAG
     C                   SETON                                        LR
      **
