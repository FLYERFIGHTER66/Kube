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
      *PROGRAM NAME-------- BIC990
      *SYSTEM-------------- DISTRIBUTION
      *DESCRIPTION--------- MONTH END
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMAPER    IF   E           K DISK
     FFARCTL    IF   E           K DISK
     FBIC990FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
     D                UDS
     D  LCO                    1      2  0
     D  LACTP                  3      4  0
     D  LTRANS                 5      5
     D  LDABEG                 6     11  0
     D  LDAEND                12     17  0
     D  LPURGE                18     18
     D  LMTRAN                19     27
     D  LMSALE                28     36
     D  LHORDW                37     45
     D  LIORDW                46     54
     D  LTINVT                55     63
     D  LLIBR                 64     73
     D  LTAXDS                75     83
     D  LBU                   84     84
     D  LHORDR                85     93
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
     D  LIORDR               172    180
     D  WTDTCY               181    187  0
     D  RTDTCY               188    194  0
      *
     C                   Z-ADD     0             LACTP
     C                   MOVEL     'Y'           LTRANS
     C                   MOVEL     'N'           LBU
     C                   MOVEL     'Y'           LPURGE
     C                   Z-ADD     1             VOUT
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101520
     C                   SETOFF                                       3040
     C                   SETOFF                                       505152
     C                   SETOFF                                       5254
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C   KB              DO
     C                   Z-ADD     LCO           ACCOMP            2 0
     C                   Z-ADD     0             VACTP             2 0
     C                   CALL      'LKACTP'
     C                   PARM                    ACCOMP
     C                   PARM                    VACTP
     C                   Z-ADD     VACTP         LACTP
     C                   GOTO      RSTRTA
     C                   ENDDO
      *
     C     LCO           CHAIN     FMAPER                             98
     C     ACMPCN        IFEQ      'M'
     C                   SETON                                        15
     C                   ENDIF
      *
     C   15LACTP         IFEQ      *ZEROS                                                   K
     C     LACTP         ORGT      12                                                       K
     C                   SETON                                        10
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C  N15LACTP         IFEQ      *ZEROS                                                   K
     C     LACTP         ORGT      13                                                       K
     C                   SETON                                        10
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C                   Z-ADD     LCO           CONO
     C                   Z-ADD     LACTP         ACTPER
     C                   CALL      'GETPDAT'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     BEGDAT        LDABEG
     C                   Z-ADD     ENDDAT        LDAEND
      *
     C     LTRANS        IFNE      'Y'                                                      Q
     C     LTRANS        ANDNE     'N'
     C                   SETON                                        20
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBU           IFNE      'Y'                                                      Q
     C     LBU           ANDNE     'N'
     C                   SETON                                        30
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LPURGE        IFNE      'Y'                                                      Q
     C     LPURGE        ANDNE     'N'
     C                   SETON                                        40
     C                   GOTO      RSTRTA
     C                   ENDIF
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
     C     LCOPY         IFEQ      0                                                        OS
     C                   SETON                                        52
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LCOPY         IFNE      OCOPY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LCOPY         OCOPY             2 0
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
     C     LPURGE        IFNE      'Y'
     C                   GOTO      NOPRG
     C                   END
      ** GET DATES
     C                   Z-ADD     ENDDAT        ##MDYI
     C                   Z-ADD     ACMTSP        ##MTHS
     C     ##MTHS        IFLE      0
     C                   Z-ADD     12            ##MTHS
     C                   END
     C                   CALL      '@DTBACK'
     C                   PARM                    ##MDYI            6 0
     C                   PARM                    ##MTHS            3 0
     C                   PARM                    ##NMDY            6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##NMDY        SHPORD
     C                   Z-ADD     ENDDAT        ##MDYI
     C                   Z-ADD     ACMTIV        ##MTHS
     C     ##MTHS        IFLE      0
     C                   Z-ADD     12            ##MTHS
     C                   END
     C                   CALL      '@DTBACK'
     C                   PARM                    ##MDYI            6 0
     C                   PARM                    ##MTHS            3 0
     C                   PARM                    ##NMDY            6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##NMDY        INVPRT
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       1020
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C   KB              GOTO      RSTRTA
      *
      ** CHECK B SCREEN FIELDS
     C     SHPORD        IFGT      0
     C                   Z-ADD     SHPORD        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      NXTB
     C                   END
     C                   Z-ADD     ##CYMD        RTDTCY
     C                   ELSE
     C                   Z-ADD     0             RTDTCY
     C                   END
     C     INVPRT        IFGT      0
     C                   Z-ADD     INVPRT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        20
     C                   GOTO      NXTB
     C                   END
     C                   Z-ADD     ##CYMD        WTDTCY
     C                   ELSE
     C                   Z-ADD     0             WTDTCY
     C                   END
      * BUILD LAST MONTH FILE NAMES
      *
     C     NOPRG         TAG
     C                   MOVE      LDABEG        YR                2 0
     C                   MOVEL     YR            WRK1              4 0
     C                   MOVE      LACTP         WRK1
     C                   MOVEL     'MTRAN'       LMTRAN
     C                   MOVE      WRK1          LMTRAN
     C                   MOVEL     'MSALE'       LMSALE
     C                   MOVE      WRK1          LMSALE
     C                   MOVEL     'HORDW'       LHORDW
     C                   MOVE      WRK1          LHORDW
     C                   MOVEL     'IORDW'       LIORDW
     C                   MOVE      WRK1          LIORDW
     C                   MOVEL     'HORDR'       LHORDR
     C                   MOVE      WRK1          LHORDR
     C                   MOVEL     'IORDR'       LIORDR
     C                   MOVE      WRK1          LIORDR
     C                   MOVEL     'TINVT'       LTINVT
     C                   MOVE      WRK1          LTINVT
     C                   MOVEL     'TAXDS'       LTAXDS
     C                   MOVE      WRK1          LTAXDS
     C                   MOVEL     'LSTMTH'      LLIBR
     C                   MOVE      WRK1          LLIBR
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     LCO           CHAIN     FARCTL                             55
     C                   ENDSR
