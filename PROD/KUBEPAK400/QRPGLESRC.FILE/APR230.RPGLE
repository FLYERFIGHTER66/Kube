      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.     1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *****************************************************************
      *PROGRAM NAME-------- APR230
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- CASH REQUIREMENTS INQUIRY.
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FAPR230FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFAPOPNDN  IF   E           K DISK
     FFMVEND    IF   E           K DISK
      *
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
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         SDATE             5 0
     C                   Z-ADD     TDATE         VDATE
      *
     C                   MOVEL     'N'           VDATEO
     C                   MOVEL     'N'           VTOTAL
      *
      * PROGRAM MAINLINE
      *
     C     RSTRTA        TAG
     C                   Z-ADD     1             FCNT
     C                   Z-ADD     0             TOTAP
     C                   Z-ADD     0             TOTAD
     C                   Z-ADD     0             TOTDD
     C                   Z-ADD     0             TOTDS
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102030
     C                   SETOFF                                       405060
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              GOTO      ENDP
      *
     C                   Z-ADD     VDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         RDATE             5 0
      *
     C     VDATE         MULT      10000.01      RVDATE            6 0
     C                   MOVEL     RVDATE        YR                2 0
     C     YR            IFGT      70
     C                   MOVEL     19            CYR               2 0
     C                   ELSE
     C                   MOVEL     20            CYR
     C                   ENDIF
     C                   MOVEL     CYR           RVDU              8 0
     C                   MOVE      RVDATE        RVDU
      *
     C     VDATEO        IFNE      'Y'
     C     VDATEO        ANDNE     'N'
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VTOTAL        IFNE      'Y'
     C     VTOTAL        ANDNE     'N'
     C                   SETON                                        40
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * DISPLAY DATE TOTALS
      *
     C     VTOTAL        IFEQ      'Y'
     C                   SETON                                        60
     C                   ENDIF
      *
      * DISPLAY SPECIFIC DATE ONLY
      *
     C     VDATEO        IFEQ      'Y'
     C                   SETON                                        50
     C                   Z-ADD     RVDU          DDATE             8 0
     C                   ELSE
     C                   Z-ADD     0             DDATE
     C                   ENDIF
      *
     C     DDATE         SETLL     FAPOPNDN
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
      *
     C     RSTRTB        TAG
     C                   SETOFF                                       90
     C   KC
     COR KG              GOTO      ENDP
     C   KF              GOTO      RSTRTA
      *
     C                   Z-ADD     0             FTOTAD            9 2
     C                   Z-ADD     0             FTOTDD            9 2
     C     NXTI          TAG
     C                   SETOFF                                       77
     C                   READ      FAPOPNDN                               90
     C   90              GOTO      DSPL
      *
     C     APRVDU        IFGT      RVDU
     C                   GOTO      DSPL
     C                   ENDIF
      *
     C     APCOMP        IFNE      LCO
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     APCLCD        IFEQ      'Y'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     APSTAT        IFEQ      'D'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     APDUE$        IFEQ      0
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C  N60              GOTO      NXT
     C     FCNT          IFEQ      1
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     APRVDU        IFNE      ODATE
     C                   ADD       1             RECNO
     C                   Z-ADD     APVEND        OVEND             6 0
     C                   Z-ADD     0             APVEND
     C                   MOVEL     NAME          ONAME            21
     C                   MOVEL     *BLANKS       NAME
     C                   MOVEL     APINV#        OPINV#           10
     C                   MOVEL     *BLANKS       APINV#
     C                   MOVEL     APITYP        OPITYP            1
     C                   MOVEL     *BLANKS       APITYP
     C                   Z-ADD     APDUDT        ODUDT             6 0
     C                   Z-ADD     OLDTE         APDUDT
     C                   Z-ADD     APDCDT        ODCDT             6 0
     C                   Z-ADD     0             APDCDT
     C                   Z-ADD     DISC          ODISC             5 2
     C                   Z-ADD     0             DISC
     C                   Z-ADD     DUE           ODUE              9 2
     C                   Z-ADD     0             DUE
     C                   Z-ADD     TOTAD         DUE
     C                   Z-ADD     TOTDD         DISC
     C                   MOVEL     '* Totals'    DESC1            13
     C                   MOVE      ' For:'       DESC1
     C                   MOVE      DESC1         NAME
     C                   SETON                                        77
     C                   WRITE     RECSFL
     C                   SETOFF                                       77
     C                   ADD       1             FCNT              2 0
     C                   MOVEL     OPINV#        APINV#
     C                   MOVEL     ONAME         NAME
     C                   MOVEL     OPITYP        APITYP
     C                   Z-ADD     ODUDT         APDUDT
     C                   Z-ADD     ODCDT         APDCDT
     C                   Z-ADD     ODISC         DISC
     C                   Z-ADD     ODUE          DUE
     C                   Z-ADD     OVEND         APVEND
     C                   ADD       1             RECNO
     C                   ADD       TOTAD         FTOTAD
     C                   ADD       TOTDD         FTOTDD
     C                   Z-ADD     0             TOTAD
     C                   Z-ADD     0             TOTDD
     C                   ENDIF
      *
     C     NXT           TAG
     C     APDAVL        IFEQ      0
     C                   Z-ADD     0             APDCDT
     C                   ENDIF
      *
     C                   Z-ADD     APDUE$        DUE
     C                   Z-ADD     APDAVL        DISC
     C     APDCDT        IFGT      0
     C                   Z-ADD     APDCDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DSDTE             5 0
     C                   ENDIF
     C     DSDTE         IFLT      SDATE
     C                   Z-ADD     0             DISC
     C                   Z-ADD     0             APDCDT
     C                   ENDIF
      *
     C     APVEND        CHAIN     FMVEND                             90
     C                   MOVEL     VMNAME        NAME
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   ADD       1             FCNT              2 0
     C                   ADD       APDUE$        TOTAD            11 2          DATE
     C                   ADD       APDUE$        TOTAP            11 2
     C                   ADD       DISC          TOTDD            11 2          DATE
     C                   ADD       DISC          TOTDS            11 2
     C                   Z-ADD     APRVDU        ODATE             8 0
     C                   Z-ADD     APDUDT        OLDTE             6 0
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C                   ADD       1             RECNO
     C                   Z-ADD     0             APVEND
     C                   MOVEL     *BLANKS       NAME
     C                   MOVEL     *BLANKS       APITYP
     C                   MOVEL     *BLANKS       APINV#
     C                   Z-ADD     OLDTE         APDUDT
     C                   Z-ADD     0             APDCDT
     C                   Z-ADD     0             DISC
     C                   Z-ADD     0             DUE
     C                   Z-ADD     TOTAD         DUE
     C                   Z-ADD     TOTDD         DISC
     C     TOTAD         IFEQ      0
     C     FTOTAD        ANDEQ     0
     C                   MOVEL     'No Invoi'    DESC3            15
     C                   MOVE      'ces Due'     DESC3
     C                   MOVEL     ' By:'        DESC4             4
     C                   MOVEL     DESC3         DESC2            19
     C                   MOVE      DESC4         DESC2
     C                   MOVE      DESC2         NAME
     C                   Z-ADD     VDATE         APDUDT
     C                   WRITE     RECSFL
     C                   ELSE
     C   60              DO
     C                   MOVEL     '* Totals'    DESC1            13
     C                   MOVE      ' For:'       DESC1
     C                   MOVE      DESC1         NAME
     C                   SETON                                        77
     C                   WRITE     RECSFL
     C                   ADD       1             RECNO
     C                   ENDDO                                                  60  DO
     C                   ADD       1             FCNT              2 0
     C                   ADD       1             RECNO
     C                   ADD       TOTAD         FTOTAD
     C                   ADD       TOTDD         FTOTDD
     C                   MOVEL     '** Total'    DESCA            16
     C                   MOVE      ' Due By:'    DESCA
     C                   MOVE      DESCA         NAME
     C                   Z-ADD     VDATE         APDUDT
     C                   Z-ADD     0             DISC
     C                   Z-ADD     0             DUE
     C                   Z-ADD     FTOTAD        DUE
     C                   Z-ADD     FTOTDD        DISC
     C                   SETON                                        77
     C                   WRITE     RECSFL
     C                   ENDIF
     C                   EXFMT     RECCTL
     C   KC
     COR KG              GOTO      ENDP
     C   KF              GOTO      RSTRTA
      *
     C                   GOTO      RSTRTA
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *
