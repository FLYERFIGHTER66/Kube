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
      *PROGRAM NAME-------- BIR030
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- TAX JURISDICTION MASTER FILE MAINTENANCE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMTAXF    UF A E           K DISK
     FBIR030FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     D MSG             S             20    DIM(5) CTDATA PERRCD(1)
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
     D  LLIST                  1      1
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     RSTRTA        TAG
     C                   EXSR      CLRIT
EFD01C                   Z-ADD     0             FIRST             2 0
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101620
     C                   SETOFF                                       2122
     C                   READ      SCRNA                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
      *
      * TEST JURISDICTION CODE
      *
     C     1             SUBST     VTAX:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VTAX          TXTXJU            3
     C                   CALL      'LKTAXJ'
     C                   PARM                    TXTXJU
     C                   PARM                    TXJUNM           30
     C                   MOVEL     *BLANKS       VTAX
     C                   MOVEL     TXTXJU        VTAX
     C                   MOVEL     TXJUNM        VDESC
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C                   GOTO      RSTRTA
     C     VACTOK        TAG
      *
     C                   MOVEL     VTAX          TXTXJU
     C     TXTXJU        CHAIN     FMTAXF                             90
      *
     C     TXTXJU        IFEQ      *BLANKS
     C                   SETON                                        2023
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C  N90VACT          IFEQ      'A'
     C                   SETON                                        2021
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C   90VACT          IFNE      'A'
     C                   SETON                                        2022
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        16
     C                   ENDIF
      *
      * LOAD MODE FOR OUTPUT
      *
     C     VACT          IFEQ      'A'
     C                   MOVEL     MSG(1)        VMODE            10
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   MOVEL     MSG(2)        VMODE
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   MOVEL     MSG(3)        VMODE
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102098
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRTA
      *
     C     VACT          IFNE      'D'
     C                   GOTO      NODEL
     C                   ENDIF
      *
     C   KX              DELETE    RMTAXF
     C   KX              EXSR      CLRIT
     C                   GOTO      RSTRTA
      *
     C     NODEL         TAG
      * TEST JURISDICTION DESCRIPTION
      *
     C     TXJUNM        IFEQ      *BLANKS
     C                   SETON                                        10
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     TXJUNM        IFNE      ONAME
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     TXJUNM        ONAME            30
      *
      * WARNING IF NO PERCENT  ENTERED
      *
EFD01C                   ADD       1             FIRST             2 0
      *  Per Spiceworks ticket 923, the edit should not require a tax.
     C*    TXPCT1        IFEQ      0
     C*    TXPCT2        ANDEQ     0
     C*    TXPCT3        ANDEQ     0
EFD01C*    FIRST         ANDEQ     1
     C*                  SETON                                        20
     C*                  GOTO      RSTRTB
     C*                  ENDIF
      *
     C     TXPCT1        IFNE      OPCT1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     TXPCT1        OPCT1             7 4
     C     TXPCT2        IFNE      OPCT2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     TXPCT2        OPCT2             7 4
     C     TXPCT3        IFNE      OPCT3
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     TXPCT3        OPCT3             7 4
      *
     C  N16CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      * UPDATE TAX JURISDICTION MASTER FILE ON DISK
      *
     C                   Z-ADD     9999999.99    TXLIM1
     C                   Z-ADD     9999999.99    TXLIM2
     C                   Z-ADD     9999999.99    TXLIM3
     C                   Z-ADD     TDATE         TXDTLA
     C                   Z-ADD     TIMOD         TXTIME
     C                   MOVEL     USERID        TXUSER
     C                   MOVEL     'A'           TXSTAT
      *
     C     VACT          IFEQ      'A'
     C                   WRITE     RMTAXF
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RMTAXF
     C                   ENDIF
     C                   EXSR      CLRIT
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KM
     COR KG              SETON                                        LR
      *
      *  CLRIT - THIS SUBROUTINE PROCESSES RESTART AND UPDATE OPTIONS
      *
     C     CLRIT         BEGSR
     C                   MOVE      *BLANKS       TXTXJU
     C                   MOVE      *BLANKS       VTAX
     C                   MOVE      *BLANKS       VDESC
     C                   MOVE      *BLANKS       TXJUNM
     C                   MOVE      *ZEROS        TXPCT1
     C                   MOVE      *ZEROS        TXPCT2
     C                   MOVE      *ZEROS        TXPCT3
     C     ECLR          ENDSR
**
   Add
  Change
  Delete
