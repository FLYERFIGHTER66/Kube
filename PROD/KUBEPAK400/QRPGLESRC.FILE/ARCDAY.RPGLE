      *****************************************************************
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
      *PROGRAM NAME-------- ARCDAY
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- DAYS TO PAY REPORT PROMPT
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
      *
     FFMCUST    IF   E           K DISK
     FARCDAYFM  CF   E             WORKSTN
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      *  PROGRAM NAME
     D  PROGID                 1     10
      *  RUN LIBRARY
     D  RLIBR                 81     90
      *  USER I.D.
     D  USERID               254    263
      *  SOURCE LIBRARY
     D  SLIBR                314    323
     D                UDS
     D  LCO                    1      2  0
     D  LCUST                  3      8  0
     D  BDATE                  9     14  0
     D  EDATE                 15     20  0
     D  BDCYMD                21     27  0
     D  EDCYMD                28     34  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
      *
     C     RSTART        TAG
     C                   SETOFF                                       101112
     C                   SETOFF                                       203031
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
     C                   Z-ADD     0             BDATE
     C                   Z-ADD     TDATE         EDATE
     C                   Z-ADD     0             BDCYMD
     C                   Z-ADD     0             EDCYMD
     C                   MOVEL     *BLANKS       LCANCL
     C                   MOVEL     *BLANKS       CMNAME
     C                   MOVEL     *BLANKS       CANAME
     C                   Z-ADD     0             VACUST
     C                   MOVEL     'XERPRT01'    LPRTR
     C                   MOVEL     '*NAR'        LFORM
     C                   Z-ADD     1             LCOPY
     C                   MOVEL     'N'           LJOBQ
     C                   Z-ADD     1             VOUT
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       101112
     C                   SETOFF                                       203031
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
      *
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      ENDP
     C                   ENDDO
     C   KF              GOTO      RSTART
     C                   Z-ADD     0             CNT               2 0
      *
     C     VACUST        IFEQ      0
     C     VALPHA        ANDGT     *BLANKS
     C                   MOVEL     VALPHA        CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   Z-ADD     CMCUST        VACUST
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TELEPHONE # SEARCH
      *
     C     VACUST        IFEQ      0
     C     VALPHA        ANDEQ     *BLANKS
     C     VATELE        ANDGT     *BLANKS
     C                   MOVEL     VATELE        CMPHON           10 0
     C                   CALL      'LKTELE'
     C                   PARM                    CMPHON
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     *BLANKS       VATELE
     C                   Z-ADD     CMCUST        VACUST
     C                   MOVEL     CMNAME        CANAME
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACUST        IFEQ      0
     C     VALPHA        ANDEQ     *BLANKS
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACUST        CHAIN     FMCUST                             31
     C   31              SETON                                        1114
     C   11              GOTO      NXTA
     C     CMSTAT        IFEQ      'D'
     C                   SETON                                        1114
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     CMCUST        LCUST
      *
      * VALIDATE FROM DATE
      *
     C     BDATE         IFNE      0
     C                   Z-ADD     BDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     ##CYMD        BDCYMD            7 0
     C                   ELSE
     C                   Z-ADD     0             BDCYMD            7 0
     C                   END                                                    BDATE><0
      *
      * VALIDATE TO DATE
      *
     C     EDATE         IFEQ      0
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     EDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     ##CYMD        EDCYMD            7 0
      ** END DATE EQUAL OR GREATER THAN START DATE
     C     EDCYMD        IFLT      BDCYMD
     C                   SETON                                        3031
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      NXTA
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
     C                   GOTO      NXTA
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
     C                   GOTO      NXTA
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
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   ENDSR
      *
