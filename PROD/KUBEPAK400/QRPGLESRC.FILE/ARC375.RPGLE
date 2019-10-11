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
      *PROGRAM NAME-------- ARC375
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- CREDIT CHECK PROMPT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMTERM    IF   E           K DISK
     FARC375FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     D                UDS
     D  LCO                    1      2  0
     D  LINCL                  4      4
     D  LBTERM                 5      6
     D  LETERM                 7      8
     D  BDATE                  9     13  0
     D  EDATE                 14     18  0
     D  LBCUST                19     24  0
     D  LECUST                25     30  0
     D  LBTYPE                31     32
     D  LETYPE                33     34
     D  LBDATE                35     40  0
     D  LEDATE                41     46  0
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
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   SETOFF                                       4045
     C                   SETOFF                                       5051
     C                   SETOFF                                       525354
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C     LBDATE        IFEQ      0
     C     LEDATE        ANDEQ     0
     C                   Z-ADD     0             BDATE
     C                   Z-ADD     0             EDATE
     C                   GOTO      CUST
     C                   ENDIF
      *
     C     LBDATE        IFGT      0
     C     LEDATE        ANDEQ     0
     C                   Z-ADD     LBDATE        LEDATE
     C                   ENDIF
      *
     C     LBDATE        IFEQ      0
     C     LEDATE        ANDGT     0
     C                   SETON                                        1011
     C   10              GOTO      RSTRT
     C                   ENDIF
      *
     C                   Z-ADD     LBDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1012
     C                   GOTO      RSTRT
     C                   ENDIF
     C                   Z-ADD     ##CYMD        DTEBEG            7 0
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         BDATE             5 0
      *
     C     LEDATE        IFEQ      0
     C                   Z-ADD     LBDATE        LEDATE
     C                   ENDIF
      *
     C                   Z-ADD     LEDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        18
     C                   GOTO      RSTRT
     C                   ENDIF
     C                   Z-ADD     ##CYMD        DTEEND            7 0
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EDATE             5 0
      *
     C     BDATE         IFGT      EDATE
     C                   SETON                                        1011
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LBDATE        IFNE      OBDATE
     C                   ADD       1             CNTB              2 0
     C                   ENDIF
     C                   Z-ADD     LBDATE        OBDATE            6 0
      *
     C     LEDATE        IFNE      OEDATE
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   Z-ADD     LEDATE        OEDATE            6 0
      *
     C     CUST          TAG
     C     LBCUST        IFEQ      0
     C     LECUST        ANDEQ     0
     C                   Z-ADD     0             LBCUST
     C                   Z-ADD     0             LECUST
     C                   GOTO      TERMS
     C                   ENDIF
      *
     C     LBCUST        IFGT      0
     C     LECUST        ANDEQ     0
     C                   Z-ADD     LBCUST        LECUST
     C                   ENDIF
      *
     C     LBCUST        IFGT      LECUST
     C                   SETON                                        20
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     TERMS         TAG
      *
     C     LBTERM        IFEQ      *BLANKS                                                  K
     C     LETERM        ANDEQ     *BLANKS                                                  K
     C                   GOTO      TYPE
     C                   ENDIF
      *
     C     1             SUBST     LBTERM:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LBTERM        TCTERM
     C                   CALL      'LKTERM'
     C                   PARM                    TCTERM
     C                   PARM                    TCDESC
     C                   MOVEL     *BLANKS       LBTERM
     C                   MOVEL     TCTERM        LBTERM
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     1             SUBST     LETERM:1      VTST1             1
     C     VTST1         IFEQ      '?'
     C     VTST1         OREQ      '/'
     C                   MOVEL     LETERM        TCTERM
     C                   CALL      'LKTERM'
     C                   PARM                    TCTERM
     C                   PARM                    TCDESC
     C                   MOVEL     *BLANKS       LETERM
     C                   MOVEL     TCTERM        LETERM
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LBTERM        IFEQ      *BLANKS                                                  K
     C     LETERM        ANDGT     *BLANKS                                                  K
     C                   SETON                                        30
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LBTERM        IFGT      *BLANKS                                                  K
     C     LETERM        ANDEQ     *BLANKS                                                  K
     C                   MOVEL     LBTERM        LETERM                                     K
     C                   ENDIF
      *
     C     LBTERM        IFGT      LETERM                                                   K
     C                   SETON                                        30
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LBTERM        CHAIN     FMTERM                             91
     C   91              SETON                                        30
     C   30              GOTO      RSTRT
      *
     C     LETERM        CHAIN     FMTERM                             92
     C   92              SETON                                        40
     C   40              GOTO      RSTRT
      *
     C     LBTERM        IFNE      OBTERM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBTERM        OBTERM            2
      *
     C     LETERM        IFNE      OETERM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LETERM        OETERM            2
      *
     C     TYPE          TAG
      *
     C     LBTYPE        IFEQ      *BLANKS
     C     LETYPE        ANDEQ     *BLANKS
     C                   GOTO      INCL
     C                   ENDIF
      *
     C     LBTYPE        IFGT      *BLANKS
     C     LETYPE        ANDEQ     *BLANKS
     C                   MOVEL     LBTYPE        LETYPE
     C                   ENDIF
      *
     C     LBTYPE        IFGT      LETYPE
     C                   SETON                                        40
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     INCL          TAG
      *
     C     LINCL         IFNE      'Y'
     C     LINCL         ANDNE     'N'
     C                   SETON                                        45
     C                   GOTO      RSTRT
     C                   ENDIF
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
     C                   MOVEL     LFORM         OFORM             4
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
     C   98              GOTO      RSTRT
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      **
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   MOVEL     'N'           LINCL
     C                   MOVEL     *BLANKS       LBTERM
     C                   MOVEL     *BLANKS       LETERM
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     0             LBDATE
     C                   Z-ADD     0             LEDATE
     C                   Z-ADD     0             LBCUST
     C                   Z-ADD     0             LECUST
      *
     C                   ENDSR
