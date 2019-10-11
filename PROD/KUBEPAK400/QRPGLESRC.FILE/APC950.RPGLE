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
      *PROGRAM NAME-------- APC950
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- PURGE APOPN RECORDS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FAPC950FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMVEND    IF   E           K DISK
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
     D                UDS
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LVEND                  9     14  0
     D  LPRINT                15     15
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
     C                   Z-ADD     TDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        CDATE             7 0
      *
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     0             LVEND
     C                   Z-ADD     0             CNT               2 0
     C                   Z-ADD     0             LDATE
     C                   MOVEL     *BLANKS       LPRINT
      *
     C     NXT           TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       202122
     C                   SETOFF                                       253040
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
     C     LDATE         IFEQ      0
     C                   GOTO      NODTE
     C                   ENDIF
      *
     C                   Z-ADD     LDATE         ##MDY             6 0
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
     C                   Z-ADD     ##CYMD        RDATE             7 0
      *
     C                   ADD       1             FIRST             2 0
     C     FIRST         IFEQ      1
     C     RDATE         ANDGT     CDATE
     C                   SETON                                        25
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LDATE         IFNE      ODATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LDATE         ODATE             6 0
      *
     C     NODTE         TAG
      *
     C     LDATE         IFGT      0
     C                   GOTO      NOVEND
     C                   ENDIF
      *
     C     LVEND         IFEQ      0
     C     VALPHA        ANDGT     *BLANKS
     C                   Z-ADD     LCO           VMCOMP            2 0
     C                   MOVEL     VALPHA        VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       VMLOOK
     C                   Z-ADD     VMVEND        LVEND
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LDATE         IFEQ      0
     C     LVEND         ANDEQ     0
     C                   SETON                                        2022
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LVEND         CHAIN     FMVEND                             90
     C   90              SETON                                        40
     C   40              GOTO      NXT
      *
     C     LVEND         IFNE      OVEND
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LVEND         OVEND             6 0
      *
     C     NOVEND        TAG
      *
     C     LDATE         IFGT      0
     C     LVEND         ANDGT     0
     C                   SETON                                        2022
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LPRINT        IFNE      'Y'                                                      Q
     C     LPRINT        ANDNE     'N'
     C                   SETON                                        30
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LPRINT        IFNE      OPRINT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRINT        OPRINT            1
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   Z-ADD     0             CNT
     C   98              GOTO      NXT
     C                   ENDIF
      *
     C     LPRINT        IFEQ      'N'                                                      Q
     C                   GOTO      ENDP
     C                   ENDIF
      *
     C                   SETOFF                                       98
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM             4
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      NXTB
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
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      NXTB
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
     C   98              GOTO      NXTB
     C                   ENDIF
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      **
