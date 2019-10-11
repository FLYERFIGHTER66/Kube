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
      *PROGRAM NAME-------- BIC315
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- PRE INVOICE REGISTER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMWHSE    IF   E           K DISK
     FFMROUT    IF   E           K DISK
     FBIC315FM  CF   E             WORKSTN
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
     D  LBSHFR                43     45
     D  LESHFR                46     48
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
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101520
     C                   SETOFF                                       255051
     C                   SETOFF                                       525354
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
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
     C     LBSHFR        IFEQ      *BLANKS
     C                   GOTO      NOSHFR
     C                   ENDIF
      *
     C     LBSHFR        CHAIN(N)  FMWHSE                             90
     C   90              SETON                                        10                    K
     C   10              GOTO      RSTRTA
      *
     C     LBSHFR        IFGT      *BLANKS
     C     LESHFR        ANDEQ     *BLANKS
     C                   MOVEL     LBSHFR        LESHFR
     C                   ENDIF
      *
     C     LESHFR        CHAIN     FMWHSE                             90
     C   90              SETON                                        15                    K
     C   15              GOTO      RSTRTA
      *
     C     LBSHFR        IFGT      LESHFR
     C                   SETON                                        10                    K
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     NOSHFR        TAG
      *
     C     LBRTE         IFEQ      *BLANKS
     C                   GOTO      NORTE
     C                   ENDIF
      *
     C     LBRTE         CHAIN     FMROUT                             90
     C   90              SETON                                        20                    K
     C   20              GOTO      RSTRTA
      *
     C     LBRTE         IFGT      *BLANKS
     C     LERTE         ANDEQ     *BLANKS
     C                   MOVEL     LBRTE         LERTE
     C                   ENDIF
      *
     C     LERTE         CHAIN     FMROUT                             90
     C   90              SETON                                        25                    K
     C   25              GOTO      RSTRTA
      *
     C     LBRTE         IFGT      LERTE
     C                   SETON                                        20
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
     C                   ENDSR
      *
