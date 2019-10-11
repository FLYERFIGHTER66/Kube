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
      *PROGRAM NAME-------- GLC410
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- DAILY GENERAL JOURNAL
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FGLC410FM  CF   E             WORKSTN
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
     D                UDS
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LSRCE                  9     11
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
     C                   Z-ADD     TDATE         LDATE
     C                   Z-ADD     1             VOUT
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101314
     C                   SETOFF                                       155253
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
     C   KD              GOTO      RSTRTB
      *
     C                   Z-ADD     LDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        53
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      RSTRT
     C                   ENDIF
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
     C                   GOTO      ENDP
      *
     C     RSTRTB        TAG
     C                   Z-ADD     0             VLINE
     C                   WRITE     SCRNB
     C                   SETOFF                                       10
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
     C   KF              GOTO      RSTRT
      *
     C     VLINE         IFEQ      0
     C     VLINE         ORGT      10
     C                   SETON                                        10
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     VLINE         IFEQ      01
     C                   MOVEL     'ADJ'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      02
     C                   MOVEL     'A/L'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      03
     C                   MOVEL     'A/P'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      04
     C                   MOVEL     'CAS'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      05
     C                   MOVEL     'DIS'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      06
     C                   MOVEL     'INV'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      07
     C                   MOVEL     'J/E'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      08
     C                   MOVEL     'L/C'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      09
     C                   MOVEL     'NAR'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      10
     C                   MOVEL     'P/R'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      11
     C                   MOVEL     'SLS'         LSRCE
     C                   ENDIF
      *
     C                   GOTO      RSTRT
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *
