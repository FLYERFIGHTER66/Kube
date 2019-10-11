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
      *PROGRAM NAME-------- GLC360
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- GENERAL JOURNAL
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMAPER    IF   E           K DISK
     FGLC360FM  CF   E             WORKSTN
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
     D  LACTP                  3      4  0
     D  LBCYMD                 5     11  0
     D  LECYMD                12     18  0
     D  LBDATE                19     24  0
     D  LEDATE                25     30  0
     D  LSRCE                 31     33
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
      * VALIDATE RESPONSES ON PROMPT SCREEN.
      *
     C                   SETOFF                                       98
     C                   Z-ADD     1             VOUT
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       105051
     C                   SETOFF                                       525354
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
     C   KD              GOTO      RSTRTB
      *
     C   KB              DO
     C                   Z-ADD     LCO           ACCOMP            2 0
     C                   CALL      'LKACTP'
     C                   PARM                    ACCOMP
     C                   PARM                    VACTP
     C                   GOTO      RSTRT
     C                   ENDDO
      *
     C                   Z-ADD     VACTP         LACTP
      *
     C     VACTP         IFLE      *ZEROS                                                   K
     C     VACTP         ORGT      13                                                       K
     C                   SETON                                        10
     C   10              GOTO      RSTRT
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C     ACST13        IFEQ      *ZEROS                                                   K
     C     VACTP         ANDEQ     13                                                       K
     C                   SETON                                        10
     C   10              GOTO      RSTRT
     C                   ENDIF
      *
      * GET PERIOD DATES
      *
     C                   Z-ADD     LCO           CONO
     C                   Z-ADD     VACTP         ACTPER
     C                   CALL      'GETPDAT'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    ERR               1 0
      *
     C                   Z-ADD     BEGDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        LBCYMD
     C                   Z-ADD     BEGDAT        LBDATE
      *
     C                   Z-ADD     ENDDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        LECYMD
     C                   Z-ADD     ENDDAT        LEDATE
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
     C     ENDP          TAG
     C                   SETON                                        LR
      **
