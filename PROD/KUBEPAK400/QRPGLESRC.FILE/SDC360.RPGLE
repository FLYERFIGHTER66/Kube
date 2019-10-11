      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      **PROGRAM NAME-------- SDC360
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- ITEM COST/PRICE REPORT PROMPT
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FSDR360FM  CF   E             WORKSTN
     FFMSIZE    IF   E           K DISK
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *    LDA       *
      ****************
     D                UDS
     D  LCO                    1      2  0
     D  ALPHA                  3     17
     D  SIZE                  18     20
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133

     D  ClearCMD       S            255A   Inz('CLRPFM COSTVPRICE')
     D  ClearLEN       S             15P 5 Inz(17)

      ****************
      *   START HERE *
      ****************
     C     RSTART        TAG
     C                   MOVE      *BLANKS       ALPHA
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      *BLANKS       LCANCL
     C                   MOVEL     'XERPRT01'    LPRTR
      *
     C                   MOVEL     '*NAR'        LFORM
     C                   MOVEL     'N'           LJOBQ
     C                   Z-ADD     01            LCOPY
     C                   Z-ADD     1             VOUT
     C                   SETOFF                                       1011
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
     C     NXTA          TAG                                                                   ARC38
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C                   If        *In11
     C                   Call      'QCMDEXC'
     C                   Parm                    ClearCmd
     C                   Parm                    ClearLen
     C                   GoTo      RSTART
     C                   EndIf
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       1011
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
      ** CHECK SIZE CODE
     C     1             SUBST     SIZE:1        VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVE      *BLANKS       SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       SIZE
     C                   MOVEL     SZCODE        SIZE
     C                   GOTO      NXTA
     C                   ENDIF
     C     SIZE          IFGT      *BLANKS
     C     SIZE          CHAIN     FMSIZE                             10
     C   10              GOTO      NXTA
     C                   END
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
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
