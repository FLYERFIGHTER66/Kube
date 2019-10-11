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
      *PROGRAM NAME-------- GLC350
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- POST G/L BALANCES
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMAPER    IF   E           K DISK
     FFGLDF     IF   E           K DISK
     FGLC350FM  CF   E             WORKSTN UsrOpn
     F                                     DEVID(WSID)
      *
     D                UDS
     D  LCO                    1      2  0
     D  LACTP                  3      4  0
     D  LBCYMD                 5     11  0
     D  LECYMD                12     18  0
     D  LBDATE                19     24  0
     D  LEDATE                25     30  0
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
     D  FirstPass      S               N   Inz(*On)
      *
     C                   SETOFF                                       98
     C                   Z-ADD     1             VOUT
      *
     C     RSTRT         TAG
     C                   If        LCANCL = 'B'                                 Batch Mode
     C                   Eval      VACTP = LACTP
     C                   If        FirstPass
     C                   Eval      FirstPass = *Off
     C                   Else
     C                   MOVE      'X'           LCANCL
     C                   GOTO      END
     C                   EndIf
     C                   Else
     C                   If        not %Open(GLC350FM)
     C                   Open      GLC350FM
     C                   EndIf
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101112
     C                   SETOFF                                       135051
     C                   SETOFF                                       525354
     C                   READ      SCRNA                                  90
     C                   EndIF
     C     EDITA         TAG
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
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
     C                   SETON                                        1011
     C   11              GOTO      RSTRT
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C   90              SETON                                        1012
     C   12              GOTO      RSTRT
      *
     C                   MOVEL     '01'          GDTYPE
     C     DEFKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GDTYPE
     C     DEFKEY        CHAIN     FGLDF                              91
     C   91              SETON                                        1013
     C   13              GOTO      RSTRT
      *
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
     C     END           TAG
     C                   If        %Open(GLC350FM)
     C                   Close     GLC350FM
     C                   EndIf
     C                   SETON                                        LR
      **
