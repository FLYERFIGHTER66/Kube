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
      *PROGRAM NAME-------- BIC620
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- OPEN ORDERS BY SHIP VIA
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMSVIA    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FBIC620FM  CF   E             WORKSTN
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
     D  LBSVIA                 3      4
     D  LESVIA                 5      6
     D  LDOS                   7      7
     D  LADDR                  8      8
     D  LCOMM                  9      9
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
     D  LX1521               172    172
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   MOVE      'Y'           LX1521
      *
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     0             LBDATE
     C                   MOVEL     'Y'           LADDR
     C                   MOVEL     'Y'           LCOMM
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       103035
     C                   SETOFF                                       404142
     C                   SETOFF                                       455051
     C                   SETOFF                                       525354
     C                   SETOFF                                       606162
     C                   SETOFF                                       707576
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
     C                   MOVEL     *BLANKS       LCANCL
      *
     C     1             SUBST     LBSVIA:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   EXSR      SVSR
     C                   MOVEL     SCODE         LBSVIA
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     1             SUBST     LESVIA:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   EXSR      SVSR
     C                   MOVEL     SCODE         LESVIA
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBSVIA        IFEQ      *BLANKS
     C     LESVIA        ANDEQ     *BLANKS
     C                   GOTO      NOSVIA
     C                   ENDIF
      *
     C     LBSVIA        IFGT      *BLANKS
     C     LESVIA        ANDEQ     *BLANKS
     C                   MOVEL     LBSVIA        LESVIA
     C                   ENDIF
      *
     C     LBSVIA        CHAIN     FMSVIA                             90
     C   90              SETON                                        60                    K
     C   60              GOTO      RSTRTA
      *
     C     LESVIA        CHAIN     FMSVIA                             90
     C   90              SETON                                        65                    K
     C   65              GOTO      RSTRTA
      *
     C     LBSVIA        IFGT      LESVIA
     C   90              SETON                                        60                    K
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBSVIA        IFNE      OBSVIA
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBSVIA        OBSVIA            2
      *
     C     LESVIA        IFNE      OESVIA
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LESVIA        OESVIA            2
      *
     C     NOSVIA        TAG
      *
     C     LADDR         IFNE      'Y'
     C     LADDR         ANDNE     'N'
     C                   SETON                                        70
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LADDR         IFNE      OADDR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LADDR         OADDR             1
      *
     C     LCOMM         IFNE      'Y'
     C     LCOMM         ANDNE     'N'
     C                   SETON                                        75
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
WJB  C     LX1521        IFNE      'Y'
WJB  C     LX1521        ANDNE     'N'
WJB  C                   SETON                                        76
WJB  C                   GOTO      RSTRTA
WJB  C                   ENDIF
      *
     C     LCOMM         IFNE      OCOMM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LCOMM         OCOMM             1
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
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
     C                   ENDSR
      *
      *********
      * SVSR
      *********
     C     SVSR          BEGSR
     C                   MOVEL     LBSVIA        SVCODE            2
     C                   CALL      'LKSVIA'
     C                   PARM                    SVCODE
     C                   PARM                    SVDESC           30
     C                   MOVEL     *BLANKS       SCODE             2
     C                   MOVEL     SVCODE        SCODE
     C                   ENDSR
      *
