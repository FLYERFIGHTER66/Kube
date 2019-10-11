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
      *PROGRAM NAME-------- BIC600
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- OPEN ORDERS BY ROUTE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMWHSE    IF   E           K DISK
     FFMROUT    IF   E           K DISK
     FBIC600FM  CF   E             WORKSTN
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
     D  LBRTE                  3      4
     D  LERTE                  5      6
     D  LDOS                   7      7
     D  LICFS                  8      8
     D  LIADDR                 9      9
     D  LIDIR                 10     10
     D  LBEGDT                33     37  0
     D  LBSHFR                43     45
     D  LESHFR                46     48
     D  LBDATE                49     54  0
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
     C                   MOVEL     'N'           LICFS
     C                   MOVEL     'N'           LIADDR
     C                   MOVEL     'N'           LIDIR
     C                   Z-ADD     0             LBDATE
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101520
     C                   SETOFF                                       3035
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
      *
     C     1             SUBST     LBRTE:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LBRTE         RTCODE            2
     C                   CALL      'LKRTE'
     C                   PARM                    RTCODE
     C                   PARM                    RTDESC           30
     C                   MOVEL     *BLANKS       LBRTE
     C                   MOVEL     RTCODE        LBRTE
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     1             SUBST     LERTE:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LERTE         RTCODE            2
     C                   CALL      'LKRTE'
     C                   PARM                    RTCODE
     C                   PARM                    RTDESC           30
     C                   MOVEL     *BLANKS       LERTE
     C                   MOVEL     RTCODE        LERTE
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBRTE         IFEQ      *BLANKS
     C     LERTE         ANDEQ     *BLANKS
     C                   GOTO      NORTE
     C                   ENDIF
      *
     C     LBRTE         IFGT      *BLANKS
     C     LERTE         ANDEQ     *BLANKS
     C                   MOVEL     LBRTE         LERTE
     C                   ENDIF
      *
     C     LBRTE         CHAIN     FMROUT                             90
     C   90              SETON                                        10                    K
     C   10              GOTO      RSTRTA
      *
     C     LERTE         CHAIN     FMROUT                             90
     C   90              SETON                                        15                    K
     C   15              GOTO      RSTRTA
      *
     C     LBRTE         IFGT      LERTE
     C                   SETON                                        10
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBRTE         IFNE      OBRTE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBRTE         OBRTE             2
      *
     C     LERTE         IFNE      OERTE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LERTE         OERTE             2
      *
     C     NORTE         TAG
      *
     C     LDOS          IFNE      'S'
     C     LDOS          ANDNE     'D'
     C                   SETON                                        20
     C                   GOTO      RSTRTA
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
     C                   Z-ADD     BDATE         LBEGDT
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
     C                   SETOFF                                       98
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
     C   KB              GOTO      RSTRTA
      *
     C     LICFS         IFNE      'Y'
     C     LICFS         ANDNE     'N'
     C                   SETON                                        10
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LICFS         IFNE      OICFS
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LICFS         OICFS             1
      *
     C     LIADDR        IFNE      'Y'
     C     LIADDR        ANDNE     'N'
     C                   SETON                                        20
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LIADDR        IFNE      OIADDR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LIADDR        OIADDR            1
      *
     C     LIDIR         IFNE      'Y'
     C     LIDIR         ANDNE     'N'
     C                   SETON                                        30
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LIDIR         IFNE      OIDIR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LIDIR         OIDIR             1
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTB
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
     C                   ENDSR
      *
