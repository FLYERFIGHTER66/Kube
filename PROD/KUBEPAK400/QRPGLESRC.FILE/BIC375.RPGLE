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
      *PROGRAM NAME-------- BIC375
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- OPEN ORDERS BY ITEM
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMINVT    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FBIC375FM  CF   E             WORKSTN
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
     D  LBITEM                 3     14
     D  LEITEM                15     26
     D  LBSIZE                27     29
     D  LESIZE                30     32
     D  LBEGDT                33     37  0
     D  LENDDT                38     42  0
     D  LBSHFR                43     45
     D  LESHFR                46     48
     D  LBDATE                49     54  0
     D  LEDATE                55     60  0
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
     C                   SETOFF                                       101520
     C                   SETOFF                                       253035
     C                   SETOFF                                       404142
     C                   SETOFF                                       455051
     C                   SETOFF                                       525354
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
     C                   MOVEL     *BLANKS       LCANCL
     C                   Z-ADD     BDATE         LBEGDT                                     K
     C                   Z-ADD     EDATE         LENDDT                                     K
      *
     C     LBITEM        IFEQ      *BLANKS
     C     LEITEM        ANDEQ     *BLANKS
     C                   GOTO      NITEM
     C                   ENDIF
      *
     C                   MOVEL     LBITEM        VITEM            12
     C     1             SUBST     LBITEM:1      VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   EXSR      ITMSRC
     C                   MOVEL     VITEM         LBITEM
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C                   MOVEL     LEITEM        VITEM            12
     C     1             SUBST     LEITEM:1      VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   EXSR      ITMSRC
     C                   MOVEL     VITEM         LEITEM
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBITEM        IFEQ      *BLANKS
     C                   SETON                                        10
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C                   MOVEL     LBITEM        VVITEM
     C     ITMKEY        KLIST
     C                   KFLD                    VVITEM           12
     C     ITMKEY        SETLL     FMINVT
     C                   READ      FMINVT                                 90
     C   90              SETON                                        10
     C   10              GOTO      RSTRTA
     C     LBITEM        IFNE      IMITEM
     C                   SETON                                        10
     C   10              GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBITEM        IFGT      *BLANKS
     C     LEITEM        ANDEQ     *BLANKS
     C                   MOVEL     LBITEM        LEITEM
     C                   ENDIF
      *
     C     LBITEM        IFGT      *BLANKS
     C     LEITEM        ANDEQ     *BLANKS
     C                   MOVEL     LBITEM        LEITEM
     C                   ENDIF
      *
     C                   MOVEL     LEITEM        VVITEM
     C     ITMKEY        SETLL     FMINVT
     C                   READ      FMINVT                                 90
     C   90              SETON                                        15
     C   15              GOTO      RSTRTA
     C     LEITEM        IFNE      IMITEM
     C                   SETON                                        15
     C   15              GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBITEM        IFGT      LEITEM
     C                   SETON                                        10
     C   10              GOTO      RSTRTA
     C                   ENDIF
      *
     C     NITEM         TAG
      *
     C     LBSIZE        IFEQ      *BLANKS
     C     LESIZE        ANDEQ     *BLANKS
     C                   GOTO      NSIZE
     C                   ENDIF
      *
     C     1             SUBST     LBSIZE:1      VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVE      *BLANKS       SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       LBSIZE
     C                   MOVEL     SZCODE        LBSIZE
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     1             SUBST     LESIZE:1      VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVE      *BLANKS       SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       LESIZE
     C                   MOVEL     SZCODE        LESIZE
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBSIZE        CHAIN     FMSIZE                             90
     C   90              SETON                                        20
     C   20              GOTO      RSTRTA
      *
     C     LBSIZE        IFGT      *BLANKS
     C     LESIZE        ANDEQ     *BLANKS
     C                   MOVEL     LBSIZE        LESIZE
     C                   ENDIF
      *
     C     LESIZE        CHAIN     FMSIZE                             90
     C   90              SETON                                        25
     C   25              GOTO      RSTRTA
      *
     C     LBSIZE        IFGT      LESIZE
     C                   SETON                                        20
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     NSIZE         TAG
      *
     C     LBDATE        IFEQ      0                                                        K
     C     LEDATE        ANDEQ     0                                                        K
     C                   Z-ADD     0             LBEGDT
     C                   Z-ADD     0             LENDDT
     C                   GOTO      NODTE
     C                   ENDIF
      *
     C     LBDATE        IFEQ      0                                                        K
     C     LEDATE        ANDGT     0                                                        K
     C                   SETON                                        30
     C   30              GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBDATE        IFGT      0                                                        K
     C     LEDATE        ANDEQ     0                                                        K
     C                   Z-ADD     LBDATE        LEDATE
     C                   ENDIF
      *
     C                   Z-ADD     LBDATE        ##MDY             6 0                      K
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        30
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
     C                   SETON                                        35
     C                   GOTO      RSTRTA
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EDATE             5 0
      *
     C     BDATE         IFGT      EDATE                                                    K
     C                   SETON                                        30
     C                   GOTO      RSTRTA
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
     C     1             SUBST     LBSHFR:1      VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     LBSHFR        VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         LBSHFR
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     1             SUBST     LESHFR:1      VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     LESHFR        VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         LESHFR
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBSHFR        CHAIN(N)  FMWHSE                             90
     C   90              SETON                                        4041                  K
     C   41              GOTO      RSTRTA
      *
     C     LBSHFR        IFGT      *BLANKS
     C     LESHFR        ANDEQ     *BLANKS
     C                   MOVEL     LBSHFR        LESHFR
     C                   ENDIF
      *
     C     LESHFR        CHAIN     FMWHSE                             90
     C   90              SETON                                        45                    K
     C   45              GOTO      RSTRTA
      *
     C     LBSHFR        IFGT      LESHFR
     C                   SETON                                        4042                  K
     C                   GOTO      RSTRTA
     C                   ENDIF
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
      *
      *********
      * ITMSRC
      *********
      *
     C     ITMSRC        BEGSR
     C                   MOVEL     *BLANKS       DESHFR            3
     C                   MOVEL     *BLANKS       IMLOOK
     C                   SUBST     VITEM:2       IMLOOK
     C                   CALL      'LKITEM'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    DESHFR
     C                   MOVEL     IMITEM        VITEM
     C                   ENDSR
      *
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
     C                   ENDSR
      *
