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
      **PROGRAM NAME-------- SDR010
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SERIES MASTER MAINTAINENCE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFSERIES   UF A E           K DISK
     FFSERINF   UF A E           K DISK
     FFMVEND    IF   E           K DISK
     FXATABL    IF   E           K DISK
     FSDR010FM  CF   E             WORKSTN
      *
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     I**                                      1   20LCO                   ARC380
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C                   MOVEA     '0'           *IN
     C                   UNLOCK    FSERIES
     C                   CLEAR                   RSERIES
     C                   MOVE      *BLANKS       LVNAME
     C                   MOVE      *BLANKS       HVNAME
     C                   MOVE      *BLANKS       ACTION
     C                   MOVE      *BLANKS       SERIES
     C                   MOVE      *BLANKS       ODESC            30
     C                   MOVE      *BLANKS       OTYPE             5
     C                   Z-ADD     0             OFORM             1 0
     C                   Z-ADD     0             OLFORM            1 0
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK FKEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   SETOFF                                       1020
     C                   SETOFF                                       212223
      ** CHECK ACTION
     C     ACTION        IFNE      'A'
     C     ACTION        ANDNE     'C'
     C     ACTION        ANDNE     'D'
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
      ** CHECK SERIES
     C     SERIES        IFLE      *BLANK
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   END
     C                   MOVEL     SERIES        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C     9             SUBST     SERIES:2      SEDESC
     C                   CALL      'LKSERI'
     C                   PARM                    SEDESC
     C                   PARM                    SECODE
     C                   MOVE      *BLANKS       SERIES
     C                   MOVEL     SECODE        SERIES
     C                   GOTO      NXTA
     C                   END
     C     SERIES        CHAIN     FSERIES                            91
     C   91ACTION        IFEQ      'C'
     C                   SETON                                        2022
     C                   GOTO      NXTA
     C                   END
     C   91ACTION        IFEQ      'D'
     C                   SETON                                        2023
     C                   GOTO      NXTA
     C                   END
     C  N91ACTION        IFEQ      'A'
     C                   SETON                                        2021
     C                   CLEAR                   RSERIES
     C                   GOTO      NXTA
     C                   END
      ** IF HERE I HAVE A GOOD RECORD OR NO RECORD ON AN ADD
     C     ACTION        IFEQ      'D'
     C     NXTBD         TAG
     C                   WRITE     SCRNBD
     C                   READ      SCRNBD                                 90
     C   KF              GOTO      RSTART
     C  NKJ
     CANNKX              GOTO      NXTBD
     C                   DELETE    RSERIES
     C                   GOTO      RSTART
     C                   END
     C  N91              DO
     C     SELVND        CHAIN     FMVEND                             77
     C  N77              MOVEL     VMNAME        LVNAME
     C     SEHVND        CHAIN     FMVEND                             77
     C  N77              MOVEL     VMNAME        HVNAME
     C                   Z-ADD     SEFORM        OLFORM
     C                   ENDDO
     C   91              DO
     C                   CLEAR                   RSERIES
     C                   MOVEL     SERIES        SECODE
     C                   ENDDO
     C                   SETOFF                                       98
      *   Get Series Information File
     C                   CLEAR                   RSERINF
     C     SERIES        CHAIN     FSERINF                            92
      *** SCREEN B
     C     NXTB          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
      ** CHECK FKEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
      ** CHECK FORM TYPES
     C   KK              DO
     C                   Move      *Blanks       TableKey          8
     C                   CALL      'XATABLE'
     C                   PARM      'SF'          TABLE             2
     C                   PARM      *Blanks       TableCd           2
     C                   PARM      *Blanks       TableElem         6
     C                   Eval      TBSHRT = *Blanks
     C                   Eval      TableKey = Table + TableElem
     C     TableKey      Chain     XATABL
     C                   If        %Found(XATABL)
     C                   Select
     C                   When      CSRFLD = 'SISFM2'
     C                   Eval      SISFM2 = TBSHRT
     C                   When      CSRFLD = 'SISFM3'
i    C                   Eval      SISFM3 = TBSHRT
     C                   Other
     C                   Eval      SISFM1 = TBSHRT
     C                   ENDSL
     C                   EndIf
     C                   GOTO      NXTB
     C                   EndDo
     C                   SETOFF                                       102030
     C                   SETOFF                                           99
      ** CHECK DESCRIPTION
     C     SEDESC        IFLE      *BLANKS
     C                   SETON                                        1099
     C                   GOTO      NXTB
     C                   END
      ** CHECK SELECTED SEED FORM
     C     SEFORM        IFLT      1
     C     SEFORM        ORGT      3
     C                   SETON                                        2099
     C                   GOTO      NXTB
     C                   END
      ** CHECK TYPE
     C                   MOVEL     SETYPE        TST1              1
     C     TST1          IFEQ      '?'
     C                   EXFMT     SCRNBHELP
     C                   GOTO      NXTB
     C                   END
     C     TST1          IFNE      'A'
     C     TST1          ANDNE     'C'
     C     TST1          ANDNE     'P'
     C     TST1          ANDNE     'R'
     C     TST1          ANDNE     'H'
     C     TST1          ANDNE     'V'
     C                   SETON                                        3099
     C                   GOTO      NXTB
     C                   END
      ** SEE IF CHANGED
     C     SEDESC        IFNE      ODESC
     C     SEFORM        ORNE      OFORM
     C     SETYPE        ORNE      OTYPE
     C                   SETOFF                                       98
     C                   MOVEL     SEDESC        ODESC            30
     C                   MOVEL     SETYPE        OTYPE
     C                   Z-ADD     SEFORM        OFORM             1 0
     C                   END
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTB
     C                   END
      ** UPDATE FILE
     C   91              WRITE     RSERIES
     C  N91              UPDATE    RSERIES
     C   92              Eval      SICODE = SECODE
     C   92              WRITE     RSERINF
     C  N92              UPDATE    RSERINF
      ** SEE IF WE NEED TO RECALC HIGH/LOW
     C     SEFORM        IFNE      OLFORM
     C     OLFORM        ANDGT     0
     C                   CALL      'SDR700'
     C                   PARM                    SECODE
     C                   END
     C                   GOTO      RSTART
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
