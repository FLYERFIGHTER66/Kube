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
      *PROGRAM NAME-------- BIC405
      *SYSTEM-------------- ORDER ENTRY
      *SYSTEM-------------- OPEN ORDERS BY SALESPERSON PROMPT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMSLSM    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FBIC405FM  CF   E             WORKSTN
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
     D  LBSLS                  3      4
     D  LESLS                  5      6
     D  LBDATE                 7     12  0
     D  LEDATE                13     18  0
     D  LBDAT                 19     23  0
     D  LEDAT                 24     28  0
     D  LBSHFR                29     31
     D  LESHFR                32     34
     D  LINCL                 37     37
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
     C                   Z-ADD     0             CNT               3 0
     C                   Z-ADD     0             LBDATE
     C                   Z-ADD     0             LEDATE
     C                   MOVEL     'Y'           LINCL
      *
     C     NXT           TAG
     C                   Z-ADD     0             CNT               3 0
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       152021
     C                   SETOFF                                       222530
     C                   SETOFF                                       313235
     C                   SETOFF                                       40
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C                   Z-ADD     LBDATE        LBDAT                                      K
     C                   Z-ADD     LEDATE        LEDAT                                      K
     C                   MOVE      ' '           LCANCL
      *
     C     LBSLS         IFEQ      *BLANKS
     C     LESLS         ANDEQ     *BLANKS
     C                   GOTO      NOSLS
     C                   ENDIF
      *
     C     1             SUBST     LBSLS:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LBSLS         VSLS              2
     C                   EXSR      SLSSR
     C                   MOVEL     VSLS          LBSLS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     1             SUBST     LESLS:1       VTST1             1
     C     VTST1         IFEQ      '?'
     C     VTST1         OREQ      '/'
     C                   MOVEL     LESLS         VSLS              2
     C                   EXSR      SLSSR
     C                   MOVEL     VSLS          LESLS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LBSLS         CHAIN     FMSLSM                             90
     C   90              SETON                                        1011
     C   11              GOTO      NXT
      *
     C     LBSLS         IFGT      *BLANKS
     C     LESLS         ANDEQ     *BLANKS
     C                   MOVEL     LBSLS         LESLS
     C                   ENDIF
      *
     C     LESLS         CHAIN     FMSLSM                             90
     C   90              SETON                                        15
     C   15              GOTO      NXT
      *
     C     LBSLS         IFGT      LESLS
     C                   SETON                                        1012                  K
     C   12              GOTO      NXT
     C                   ENDIF
      *
     C     LBSLS         IFNE      OBSLS
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBSLS         OBSLS             2
      *
     C     LESLS         IFNE      OESLS
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LESLS         OESLS             2
      *
     C     NOSLS         TAG
      *
     C     LBDATE        IFEQ      0                                                        K
     C     LEDATE        ANDEQ     0                                                        K
     C                   GOTO      NODTE
     C                   ENDIF
      *
     C                   Z-ADD     LBDATE        ##MDY             6 0                      K
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        2021
     C                   GOTO      NXT
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         BDATE             5 0
      *
     C     LBDATE        IFGT      0                                                        K
     C     LEDATE        ANDEQ     0                                                        K
     C                   Z-ADD     LBDATE        LEDATE
     C                   ENDIF
      *
     C                   Z-ADD     LEDATE        ##MDY             6 0                      K
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        25
     C                   GOTO      NXT
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EDATE             5 0
      *
     C     BDATE         IFGT      EDATE                                                    K
     C                   SETON                                        2022
     C   22              GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     BDATE         LBDAT
     C                   Z-ADD     EDATE         LEDAT
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
     C     1             SUBST     LBSHFR:1      VTST3             1
     C     VTST3         IFEQ      '?'
     C     VTST3         OREQ      '/'
     C                   MOVEL     LBSHFR        VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         LBSHFR
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     1             SUBST     LESHFR:1      VTST2             1
     C     VTST2         IFEQ      '?'
     C     VTST2         OREQ      '/'
     C                   MOVEL     LESHFR        VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         LESHFR
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LBSHFR        CHAIN     FMWHSE                             90
     C   90              SETON                                        3031                  K
     C   31              GOTO      NXT
      *
     C     LBSHFR        IFGT      *BLANKS
     C     LESHFR        ANDEQ     *BLANKS
     C                   MOVEL     LBSHFR        LESHFR
     C                   ENDIF
      *
     C     LESHFR        CHAIN     FMWHSE                             90
     C   90              SETON                                        35                    K
     C   35              GOTO      NXT
      *
     C     LBSHFR        IFGT      LESHFR
     C                   SETON                                        3032                  K
     C   32              GOTO      NXT
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
     C     LINCL         IFNE      'Y'
     C     LINCL         ANDNE     'N'
     C                   SETON                                        40
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      NXT
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
     C                   GOTO      NXT
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
     C                   GOTO      NXT
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
     C   98              GOTO      NXT
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      **
      *********
      * SLSSR
      *********
     C     SLSSR         BEGSR
     C                   MOVEL     VSLS          SMSLSM
     C                   CALL      'LKSALE'
     C                   PARM                    SMSLSM
     C                   PARM                    SMNAME           30
     C                   MOVEL     *BLANKS       VSLS
     C                   MOVEL     SMSLSM        VSLS
     C                   MOVEL     SMNAME        SNAME            30
     C                   ENDSR
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
