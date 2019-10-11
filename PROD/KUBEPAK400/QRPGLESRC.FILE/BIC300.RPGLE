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
      *PROGRAM NAME-------- BIC300
      *SYSTEM-------------- ORDER ENTRY
      *DESCRIPTION--------- ORDER PROOF LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMWHSE    IF   E           K DISK
     FBIC300FM  CF   E             WORKSTN
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
      *
     D                UDS
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LBSHFR                60     62
     D  LESHFR                63     65
     D  LBORD                 66     71  0
     D  LEORD                 72     77  0
     D  LCHG                  78     78
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
     C                   Z-ADD     TDATE         VDATE
     C                   Z-ADD     1             VOUT
     C                   MOVEL     *BLANKS       VCHG                                       Q
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101112
     C                   SETOFF                                       202122
     C                   SETOFF                                       2530
     C                   SETOFF                                       405051
     C                   SETOFF                                       525354
     C                   SETOFF                                       98
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
     C                   MOVEL     *BLANKS       LCANCL
     C                   Z-ADD     VDATE         LDATE
     C                   Z-ADD     VBORD         LBORD
     C                   Z-ADD     VEORD         LEORD
     C                   MOVE      VBSHFR        LBSHFR
     C                   MOVE      VESHFR        LESHFR
     C                   MOVE      VCHG          LCHG
      *
     C     VDATE         IFEQ      0
     C                   GOTO      NODTE
     C                   ENDIF
      *
     C                   Z-ADD     VDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1011
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VDATE         IFNE      ODATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VDATE         ODATE             6 0
      *
     C     NODTE         TAG
      *
     C     VDATE         IFGT      0
     C     VCHG          ANDNE     *BLANKS
     C                   SETON                                        1012
     C                   ENDIF
      *
     C     VDATE         IFGT      0
     C                   GOTO      NOCHG
     C                   ENDIF
      *
     C     VCHG          IFNE      'Y'                                                      Q
     C     VCHG          ANDNE     'N'
     C                   SETON                                        40
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VCHG          IFNE      OCHG
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VCHG          OCHG              1
      *
     C     NOCHG         TAG
      *
     C     VBSHFR        IFEQ      *BLANKS
     C     VESHFR        ANDEQ     *BLANKS
     C                   GOTO      NOSHFR
     C                   ENDIF
      *
     C     1             SUBST     VBSHFR:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VBSHFR        VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         VBSHFR
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     1             SUBST     VESHFR:1      VTST1             1
     C     VTST1         IFEQ      '?'
     C     VTST1         OREQ      '/'
     C                   MOVEL     VESHFR        VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         VESHFR
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VBSHFR        CHAIN     FMWHSE                             90
     C   90              SETON                                        2021                  K
     C   21              GOTO      RSTRTA
      *
     C     VESHFR        IFEQ      *BLANKS
     C                   MOVEL     VBSHFR        VESHFR
     C                   GOTO      NOSHFR
     C                   ENDIF
      *
     C     VESHFR        CHAIN     FMWHSE                             90
     C   90              SETON                                        25                    K
     C   25              GOTO      RSTRTA
      *
     C     VBSHFR        IFGT      VESHFR
     C                   SETON                                        2022                  K
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VBSHFR        IFNE      OBSHFR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VBSHFR        OBSHFR            3
      *
     C     VESHFR        IFNE      OESHFR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VESHFR        OESHFR            3
      *
     C     NOSHFR        TAG
      *
     C     VBORD         IFGT      0
     C     VEORD         ANDEQ     0
     C                   Z-ADD     VBORD         VEORD             6 0
     C                   ENDIF
      *
     C     VBORD         IFGT      VEORD
     C                   SETON                                        30
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VBORD         IFNE      OBORD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VBORD         OBORD             6 0
      *
     C     VEORD         IFNE      OEORD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VEORD         OEORD             6 0
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
