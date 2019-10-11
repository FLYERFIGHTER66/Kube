      *
      *
      *
     FFIORDRSP  IF   E           K DISK
     FITEMSUM   UF A E           K DISK
     FFMINVT    IF   E           K DISK
     F*CALEN  IF  E           K        DISK
      *
      ************
      *  LDA     *
      ************
     D                UDS
     D  PLDATE                 3      8  0
     D  TODATE                 9     14  0
     D  LTOPC                 63     64
     D  SUMDET                65     65
     D  LQUERY                66     66
     D  LLABEL                67     67
     D  LCANCL               133    133
      ****************
      * START HERE   *
      ****************
     C     TOTEST        SETLL     FIORDRSP
     C     NXT           TAG
     C                   READ      FIORDRSP                               90
     C   90              GOTO      END
     C*          OISIZE    IFEQ '400'
     C*                    GOTO NXT
     C*                    END
     C     OISIZE        IFEQ      *BLANKS
     C                   GOTO      NXT
     C                   END
     C                   Z-ADD     OISOW         ##CYMD
     C     ##CYMD        IFLT      FRTEST
     C                   GOTO      NXT
     C                   END
      ** SEE IF WE NEED THIS RECORD
     C     OIITYP        IFNE      ' '
     C     OILOTC        OREQ      'Y'
     C     OISTA         OREQ      'Y'
     C                   GOTO      NXT
     C                   END
     C* CALCULATE TOTAL NEEDED FOR THIS LINE ITEM
     C                   CLEAR                   SEEDS
     C                   CLEAR                   SPCO
     C                   CLEAR                   SPCS
     C                   CLEAR                   QTY
     C                   MOVEL     OISIZE        SIZE              3 0
     C     ITEMKY        CHAIN     FMINVT                             99
     C     *IN99         IFEQ      *OFF
     C     OIQORD        MULT      IM#SED        SPCO             11 1
     C     OIQSHP        MULT      IM#SED        SPCS             11 1
     C     SPCO          MULT      SIZE          SEEDS            11 1
     C                   Z-ADD     SEEDS         OIQORD
     C     SPCS          MULT      SIZE          SEEDS
     C                   Z-ADD     SEEDS         OIQSHP
     C* UPDATE EACH ITEM
     C     ITMKEY        CHAIN     ITEMSUM                            90
     C     *IN90         IFEQ      *ON
     C                   SUB       OIQSHP        OIQORD
     C                   Z-ADD     OIQORD        QTY
     C                   MOVEL     OIITEM        WKITEM
     C                   MOVEL     OIDES1        WKDES1
     C                   MOVEL     OIITMA        WKITMA
     C                   WRITE     ORDSUMWK
     C                   ENDIF
     C     *IN90         IFEQ      *OFF
     C                   SUB       OIQSHP        OIQORD
     C                   ADD       OIQORD        QTY
     C                   UPDATE    ORDSUMWK
     C                   ENDIF
     C                   ENDIF
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
     C*
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     ITMKEY        KLIST
     C                   KFLD                    OIITEM
     C     ITEMKY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   Z-ADD     PLDATE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        FRTEST            7 0
     C                   Z-ADD     TODATE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        TOTEST            7 0
     C                   ENDSR
