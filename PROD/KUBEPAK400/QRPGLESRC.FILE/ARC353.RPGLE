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
      *PROGRAM NAME-------- ARC353
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- DAILY CASH RECEIPTS REGISTER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  7/05/01 EFD ALLOW SELECTION BY USER I.D.
      *
     FARC353FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMUSER    IF   E           K DISK
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
     D  LDATE                  3      9  0
     D  USER                  10     19
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
     D  ToDate7              172    178  0
      *
     C                   Z-ADD     1             VOUT
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     TDATE         VDATE
     C                   Z-ADD     TDATE         ToDATE
     C                   MOVE      *BLANKS       USER
     C                   MOVE      *BLANKS       LCANCL
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       20
     C                   SETOFF                                       105051
     C                   SETOFF                                       525354
     C                   Z-ADD     0             CNT               1 0
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
     C                   Z-ADD     VDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
     C                   Z-ADD     ##CYMD        LDATE
      *
     C     VDATE         IFNE      ODATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VDATE         ODATE             6 0
      *
     C                   Z-ADD     ToDate        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        11
     C                   GOTO      RSTRT
     C                   ENDIF
     C                   Z-ADD     ##CYMD        ToDate7           7 0
      *
     C     ToDate        IFNE      ODATEto
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     ToDate        ODATEto           6 0
      * CHECK USER
     C     USER          IFGT      *BLANKS
      ** SEE IF SEARCH NEEDED
     C     1             SUBST     USER:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     USER          USUSER
     C                   CALL      'LKUSER'
     C                   PARM                    USUSER           10
     C                   PARM                    USNAME           30
     C                   PARM                    USDEPT            3
     C                   MOVEL     *BLANKS       USER
     C                   MOVEL     USUSER        USER
     C                   GOTO      RSTRT
     C                   ENDIF
     C     USER          CHAIN     FMUSER                             20
     C   20              GOTO      RSTRT
      *
     C     USER          IFNE      OUSER
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     USER          OUSER            10
     C                   END                                                    USER>"  "
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LCOPY         IFNE      OCOPY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LCOPY         OCOPY             2 0
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        53
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LJOBQ         IFNE      OJOBQ
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LJOBQ         OJOBQ             1
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     VOUT          IFNE      OOUT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VOUT          OOUT              1 0
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
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   Z-ADD     0             CNT
     C   98              GOTO      RSTRT
     C                   ENDIF
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      **
