      *--------------------------------------------------------------
      **PROGRAM NAME-------- SCR422R
      **PROGRAMMER---------- Rich Piasecki
      **APPLICATION--------- PRINT UN-PRINTED ITEMS
      *
      *
     FFIORDRL6  IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FSCR422P   O    E             PRINTER OFLIND(*IN11)
      *
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
     D                 DS
     D  OIRVDT                 1      7  0                                      ARC380
     D  YYMMDD                 2      7  0                                      ARC380
     C     LOCKEY        SETLL     FIORDRL6
     C     NXT           TAG
     C     LOCKEY        READE     FIORDRL6                               90
     C   90              DO
     C                   GOTO      END
     C                   ENDDO
     C     OIPRTD        IFEQ      'Y'
     C*          PDRDYB    OREQ 'Y'
     C                   GOTO      NXT
     C                   END
     C     OIQORD        IFGT      0
     C                   MOVE      *BLANKS       CUSNAM
     C     CUSKEY        CHAIN     FMCUST                             91
     C     *IN91         IFEQ      *OFF
     C                   MOVEL     CMNAME        CUSNAM           25
     C                   ENDIF
     C                   Z-ADD     OIQORD        QTYORD            9 0
     C     OIQORD        SUB       OIQSHP        QTYNED            9 0
     C     YYMMDD        MULT      100.0001      RQDATE            6 0
     C                   WRITE     DETAIL
     C                   ADD       OIQORD        TOTORD            9 0
     C                   ADD       QTYNED        TOTNED            9 0
     C                   ENDIF
     C     *IN11         IFEQ      *ON
     C                   WRITE     HEADER
     C                   MOVE      *OFF          *IN11
     C                   END
     C                   GOTO      NXT
      ** END PROG
     C     END           TAG
     C                   SETON                                        LR
     CLR   TOTORD        IFGT      0
     CLR                 WRITE     TOTAL
     CLR                 END
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    STDATE            8
     C                   PARM                    ITEM#            12
     C                   PARM                    SIZE#             3
     C                   MOVE      STDATE        CLDATE
     C                   MOVEL     ITEM#         ITEM              6
     C                   MOVEL     SIZE#         SIZE              3
     C     CLDATE        MULT      100.0001      CLDATE            6 0
     C                   MOVE      STDATE        STRDAT            7 0
     C                   MOVEL     1             STRDAT
     C                   Z-ADD     CLDATE        PLDATE            6 0
     C     ITMKEY        KLIST
     C                   KFLD                    ITEM#
     C                   KFLD                    SIZE#
     C     CUSKEY        KLIST
     C                   KFLD                    OICUST
     C     LOCKEY        KLIST
     C                   KFLD                    STRDAT
     C                   KFLD                    ITEM#
     C                   KFLD                    SIZE
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     ITMKEY        CHAIN     FMINVT                             91
     C                   WRITE     HEADER
     C                   MOVE      *ON           *IN50
     C                   ENDSR
