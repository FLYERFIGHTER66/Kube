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
      *PROGRAM NAME-------- BIC610
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- OPEN ORDERS WITH CANCEL DATE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMWHSE    IF   E           K DISK
     FBIC610FM  CF   E             WORKSTN
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
     D  LBDATE                 3      8  0
     D  LEDATE                 9     14  0
     D  LBSHFR                19     21
     D  LESHFR                22     24
     D  LBEGDT                25     29  0
     D  LENDDT                30     34  0
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     0             LBDATE
     C                   Z-ADD     0             LEDATE
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101112
     C                   SETOFF                                       1530
     C                   SETOFF                                       313235
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
     C                   MOVEL     *BLANKS       LCANCL
      *
     C     LBDATE        IFEQ      0                                                        K
     C     LEDATE        ANDEQ     0                                                        K
     C                   Z-ADD     0             LBEGDT
     C                   Z-ADD     0             LENDDT
     C                   GOTO      NODTE
     C                   ENDIF
      *
     C     LBDATE        IFEQ      *ZEROS                                                   K
     C     LEDATE        ANDGT     *ZEROS                                                   K
     C                   SETON                                        1011
     C   10              GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBDATE        IFGT      *ZEROS                                                   K
     C     LEDATE        ANDEQ     *ZEROS                                                   K
     C                   Z-ADD     LBDATE        LEDATE
     C                   ENDIF
      *
     C                   Z-ADD     LBDATE        ##MDY             6 0                      K
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1011
     C                   GOTO      RSTRTA
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         BDATE             5 0
      *
     C                   Z-ADD     LEDATE        ##MDY             6 0                      K
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        15
     C                   GOTO      RSTRTA
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EDATE             5 0
      *
     C     BDATE         IFGT      EDATE                                                    K
     C                   SETON                                        1012
     C   12              GOTO      RSTRTA
     C                   ENDIF
      *
     C                   Z-ADD     BDATE         LBEGDT
     C                   Z-ADD     EDATE         LENDDT
      *
     C     LBDATE        IFNE      OBDATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LBDATE        OBDATE            6 0
      *
     C     LEDATE        IFNE      OEDATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LEDATE        OEDATE            6 0
      *
     C     NODTE         TAG
      *
     C     LBSHFR        IFEQ      *BLANKS
     C     LESHFR        ANDEQ     *BLANKS
     C                   GOTO      NOSHFR
     C                   ENDIF
      *
     C     1             SUBST     LBSHFR:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LBSHFR        VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         LBSHFR
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     1             SUBST     LESHFR:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LESHFR        VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         LESHFR
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBSHFR        IFGT      *BLANKS
     C     LESHFR        ANDEQ     *BLANKS
     C                   MOVEL     LBSHFR        LESHFR
     C                   ENDIF
      *
     C     LBSHFR        CHAIN     FMWHSE                             90
     C   90              SETON                                        3031                  K
     C   31              GOTO      RSTRTA
      *
     C     LESHFR        CHAIN     FMWHSE                             90
     C   90              SETON                                        35                    K
     C   35              GOTO      RSTRTA
      *
     C     LBSHFR        IFGT      LESHFR
     C                   SETON                                        3032                  K
     C   32              GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBSHFR        IFNE      OBSHFR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBSHFR        OBSHFR            3
      *
     C     LESHFR        IFNE      OESHFR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LESHFR        OESHFR            3
      *
     C     NOSHFR        TAG
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      RSTRTA
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
     C                   GOTO      RSTRTA
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
     C                   GOTO      RSTRTA
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
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *********
      * LOCSR
      *********
     C     LOCSR         BEGSR
     C                   MOVEL     VWHSE         WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       VWHSE
     C                   MOVEL     WHWHSE        VWHSE
     C                   MOVEL     WHDESC        VDESC            30
     C                   ENDSR
      *
