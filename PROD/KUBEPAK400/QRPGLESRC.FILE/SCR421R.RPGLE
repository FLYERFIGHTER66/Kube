      *--------------------------------------------------------------
      **PROGRAM NAME-------- SCR421R
      **PROGRAMMER---------- Rich Piasecki
      **APPLICATION--------- PRINT UN-PRINTED ITEM LIST by location
      *                      customer/truck
      *
     FFIORDRL7  UF   E           K DISK
     FFIORDR    IF   E           K DISK    Prefix(Dtl)
WBDLTF*FMINVT  IF  E           K        DISK
     FSCR421P   O    E             PRINTER OFLIND(*IN11)
      *
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
     D  PROGID                 1     10                                         APROGRAM NAME
     D  RLIBR                 81     90                                         ARUN LIBRARY
     D  USERID               254    263                                         AUSER I.D.
     D  SLIBR                314    323                                         ASOURCE LIBRARY
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  RUNST                  1      1
     D  STRDAT                 4     10  0
     D  ITEM                  17     28
     D  SIZE                  29     31
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     C     LOCKEY        SETLL     FIORDRL7
     C     NXT           TAG
     C     LOCKEY        READE     FIORDRL7                               90
    ?C     DetailKey     SetLL     FIORDR
     C                   If        not %Equal(FIORDR)
    ?C                   Delete    RIORDRWK
    ?C     LOCKEY        ReadE     FIORDRL7
     C                   GoTo      NXT
     C                   EndIF

     C   90              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C     OIPRTD        IFEQ      'Y'
     C*          PDRDYB    OREQ 'Y'
     C                   GOTO      NXT
     C                   END
     C     *IN50         IFEQ      *ON
WBCHGC                   MOVEL     OIITEM        SVITEM
WBCHGC                   MOVEL     OISIZE        SVSIZE
WBCHGC                   MOVEL     OIDES1        SVDES1
     C                   MOVE      *OFF          *IN50
     C                   END
     C     OIITEM        IFNE      SVITEM
     C     OISIZE        ORNE      SVSIZE
WBMOVC     QTYORD        IFGT      0
     C                   If        OISIZE <> SVSIZE
     C                   Eval      *In30 = *On
     C                   Else
     C                   Eval      *In30 = *Off
     C                   EndIf
     C                   WRITE     DETAIL
WBMOVC                   ENDIF
     C     OISIZE        IFNE      SVSIZE
     C                   WRITE     SIZTOT
WBCHGC                   MOVEL     OISIZE        SVSIZE
     C                   Eval      TOTSIZ = *Zero
     C                   ENDIF
WBCHGC                   MOVEL     OIITEM        SVITEM
WBCHGC                   MOVEL     OIDES1        SVDES1
     C                   Z-ADD     0             QTYORD            6 0
     C                   ENDIF
     C     *IN11         IFEQ      *ON
     C                   WRITE     HEADER
     C                   MOVE      *OFF          *IN11
     C                   END
WBDLTC*          ITMKEY    CHAINFMINVT               91
     C                   ADD       OIQORD        QTYORD            6 0
     C                   ADD       OIQORD        TOTQTY            6 0
     C                   ADD       OIQORD        TOTSIZ            6 0
     C                   GOTO      NXT
      ** END PROG
     C     END           TAG
     C                   SETON                                        LR
     CLR   QTYORD        IFGT      0
     CLR                 Eval      *In30 = *On
     CLR                 WRITE     DETAIL
     CLR                 WRITE     SIZTOT
     CLR                 END
     CLR   TOTQTY        IFGT      0
     CLR                 WRITE     TOTAL
     CLR                 END
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    STDATE            8
     C                   MOVE      STDATE        CLDATE
     C     CLDATE        MULT      100.0001      CLDATE            6 0
     C                   MOVE      STDATE        STRDAT            7 0
     C                   MOVEL     1             STRDAT
     C                   Z-ADD     CLDATE        PLDATE            6 0
     C     ITMKEY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C     LOCKEY        KLIST
     C                   KFLD                    STRDAT
      * ?KLIST for file - FIORDR  Library - *LIBL     ?
     C     DetailKey     KLIST
     C                   KFLD                    OIORD#
     C                   KFLD                    OISEQ#

     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   WRITE     HEADER
     C                   MOVE      *ON           *IN50
     C                   ENDSR
