      *
     FFMINVT    UF   E           K DISK
     FFMINVTL3  IF   E           K DISK    RENAME(RMINVT:SEDINVT) PREFIX(SED)
     FFMINSER   IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFLISTCD   IF   E           K DISK
     FFTCOST    IF   E           K DISK
     FFOCOST    IF   E           K DISK
     FFSERIES   IF   E           K DISK
     FFSERPRC   IF   E           K DISK
      *
     D PRC             S              9  4 DIM(3)                               PRICES
     D  F#SED          S              2S 0                                      ?
     D  FIXCST         S              9S 4                                      ?
     D  FIXPLG         S              9S 4                                      ?
     D  HVNAME         S             30A                                        ?
     D  ITEM           S             12A                                        ?
     D  LIST           S              4A                                        ?
     D  LVNAME         S             30A                                        ?
     D  MARG           S              7S 2                                      ?
     D  MARGIN         S              7S 2                                      ?
     D  NETPRC         S              7S 2                                      ?
     D  NEWPRC         S              9S 4                                      ?
     D  NMRPCT         S              9S 4                                      ?
     D  NNTPRC         S              7S 2                                      ?
     D  NTRDSC         S              7S 4                                      ?
     D  PLGCEL         S              5S 0                                      ?
     D  PLGCST         S              9S 4                                      ?
     D  PLGGERM        S              9S 6                                      ?
     D  PLGOVRHD       S              9S 4                                      ?
     D  PLGWKOVRHD     S              9S 4                                      ?
     D  PLGWTG         S              4S 2                                      ?
     D  PLPRC          S             10S 6                                      ?
     D  SEDCEL         S              5S 0                                      ?
     D  SEDCST         S              9S 4                                      ?
     D  SELSPR         S              9S 4                                      ?
     D  SIZE           S              3A                                        ?
     D  SMMULT         S              6S 5                                      ?
     D  SSPRC          S             10S 6                                      ?
     D  SVNAME         S             30A                                        ?
     D  TOTCST         S              9S 4                                      ?
     D  TOTOVR         S              9S 4                                      ?
     D  TOTPLG         S              9S 4                                      ?
     D  TOTPLGCOST     S              9S 4                                      ?
     D  TRAOVRHD       S              9S 4                                      ?
     D  TRAWKOVRHD     S              9S 4                                      ?
     D  TRAWTG         S              4S 2                                      ?
     D  TRAYCOST       S              9S 4                                      ?
     D  TRDSC          S              7S 4                                      ?
     D  UPRICE         S              9S 4                                      ?
     D  WKS2GERM       S              4S 2                                      ?
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
     D  PROGID                 1     10                                         |PROGRAM NAME
     D  RLIBR                 81     90                                         |RUN LIBRARY
     D  USERID               254    263                                         |USER I.D.
     D  SLIBR                314    323                                         |SOURCE LIBRARY
      *
     D  WksCount       S              1S 0
      *
     IRSERPRC
     I              SPPRC1                      PRC(1)
     I              SPPRC2                      PRC(2)
     I              SPPRC3                      PRC(3)
      ****************
      *   START HERE *
      ****************
     C     MINKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C     MINKEY        CHAIN(N)  FMINVT                             10
     C   10              Eval      *InLR = *On
     C   10              Return
      ** SEE IF TRANSPLANT FROM
     C     IMTPSW        IFEQ      'P'
     C     IMFRSZ        ANDGT     *BLANKS
     C                   ExSr      Transplant
     C                   Else
     C                   ExSr      FromSeed
     C                   END
     C                   Eval      *InLR = *On
     C                   Return
     C     FromSeed      BegSr
     C                   Z-ADD     0             OLDPRC            9 4
     C                   Z-ADD     0             NEWPRC
     C                   Z-ADD     0             NTRDSC
     C                   Z-ADD     0             NNTPRC
     C                   Z-ADD     0             MARG
     C                   Z-ADD     0             NMRPCT
     C                   MOVE      *BLANKS       OLIST             4
     C                   MOVE      *BLANKS       LIST
     C                   SETOFF                                       6061
     C     ITEM          CHAIN     FMINSER                            88
     C  N88ISCODE        CHAIN     FSERIES                            88
     C   88              DO
     C                   MOVE      *BLANKS       LVNAME
     C                   MOVE      *BLANKS       HVNAME
     C                   MOVE      *BLANKS       SVNAME
     C                   MOVE      *BLANKS       SEFORM
     C                   MOVE      *BLANKS       SEDESC
     C                   MOVE      *BLANKS       SECODE
     C                   Z-ADD     0             SELPRC
     C                   Z-ADD     0             SEHPRC
     C                   Z-ADD     0             SELSPR
     C                   Z-ADD     0             SEHVND
     C                   Z-ADD     0             SELVND
     C                   Z-ADD     0             ISVEND
     C                   GOTO      NOSERI
     C                   ENDDO
     C     NEWVND        TAG
      ** GET SEED INFO
     C     SEHVND        CHAIN     FMVEND                             90
     C   90              MOVE      *BLANKS       HVNAME
     C  N90              MOVEL     VMNAME        HVNAME
     C     SELVND        CHAIN     FMVEND                             90
     C   90              MOVE      *BLANKS       LVNAME
     C  N90              MOVEL     VMNAME        LVNAME
     C     SEVND         CHAIN     FMVEND                             90
     C   90              MOVE      *BLANKS       SVNAME
     C  N90              MOVEL     VMNAME        SVNAME
      ** GET VENDORS COST
     C     PRCKEY        KLIST
     C                   KFLD                    SEVND
     C                   KFLD                    SECODE
     C     PRCKEY        CHAIN     FSERPRC                            87
     C   87              DO
     C                   Z-ADD     0             SSPRC
     C                   Z-ADD     0             PRC
     C                   GOTO      NOSERI
     C                   ENDDO
      ** GET PRICE EACH
     C     PRC(SEFORM)   DIV(H)    1000          SSPRC
     C                   Z-ADD     PRC(SEFORM)   SELSPR
     C     NOSERI        TAG
     C     SIZE          CHAIN     FMSIZE                             90
     C                   If        IMTPSW = 'R'
     C                   Eval      SZCELL = 100
     C                   EndIf
     C     SZCELL        MULT      IM#SED        #SED              4 0
     C     #SED          MULT(H)   SSPRC         SEDCST
      *? Calculate Sow Factor and Add to Seed Cost
     C                   Eval      SEDIMMULT = 0
     C     IMITEM        Chain     FMINVTL3
     C                   Eval      SMMULT = 1 + (SEDIMMULT/100)
     C                   Eval      SEDCST = SEDCST * SMMULT
      *? Calculate Average Weeks to Grow
     C                   Eval      WksCount = 0
     C                   If        IMWG1 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG2 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG3 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG4 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        WksCount = 0
     C                   Eval      WksCount = 1
     C                   EndIf
     C                   Eval      Wks2Germ  = (IMWG1 + IMWG2 + IMWG3 + IMWG4)/
     C                             WksCount
      ** GET FIXED COST
     C                   Z-ADD     0             FIXCST
     C                   MOVEL     IMTPSW        TSOW              1
     C     RTRY          TAG
     C     TCSKEY        KLIST
     C                   KFLD                    ITEMB
     C                   KFLD                    SIZE
     C                   KFLD                    TSOW
     C                   MOVE      *BLANKS       ITEMB            12
     C                   Eval      TOCOST = 0
     C                   Eval      TOGERM = 100
     C     TCSKEY        Chain     FOCOST
     C                   Eval      TOTOVR = Wks2Germ * TOCOST
     C                   Eval      FIXCST = TOTOVR
     C     TCSKEY        SETLL     FTCOST
     C     NXTCST        TAG
     C     TCSKEY        READE     FTCOST                                 90
     C   90              DO
     C     FIXCST        IFEQ      0
     C     TSOW          ANDGT     *BLANKS
     C                   MOVE      *BLANKS       TSOW
     C                   GOTO      RTRY
     C                   ENDIF
     C                   ENDDO
     C  N90              DO
     C     TCQTY         MULT(H)   TCUCST        WRKCST            9 4
     C                   ADD       WRKCST        FIXCST
     C                   GOTO      NXTCST
     C                   ENDDO
     C     SEDCST        ADD       FIXCST        TOTCST
     C                   Eval      TRAYCOST = TOTCST
     C                   Eval      TOTCST = ( TOTCST * 100 ) / TOGERM
      ** GET PRICE
     C     IMLIST        IFGT      *BLANKS
     C     IMLIST        CHAIN     FLISTCD                            51
     C                   Z-ADD     LCSEL5        UPRICE
     C                   ELSE
     C                   Z-ADD     IMSEL5        UPRICE
     C                   END
      ** CALC TRADE DISCOUNT
     C     UPRICE        IFGT      0.0000
     C*    UPRICE        MULT      .20           TRDSC
     C     UPRICE        MULT      .23           TRDSC
     C     UPRICE        SUB       TRDSC         NETPRC
     C     NETPRC        SUB(H)    TOTCST        MARGIN                 55
     C     MARGIN        DIV(H)    NETPRC        MARWRK            9 6
     C     MARWRK        MULT      100           MARPCT            9 4
     C                   ELSE
     C                   Z-ADD     0             TRDSC
     C                   Z-ADD     0             NETPRC
     C                   Z-ADD     0             MARGIN
     C                   Z-ADD     0             MARPCT
     C                   END
     C                   EndSr
     C     TransPlant    BegSr
     C                   Z-ADD     0             OLDPRC            9 4
     C                   Z-ADD     0             NEWPRC
     C                   Z-ADD     0             NTRDSC
     C                   Z-ADD     0             NNTPRC
     C                   Z-ADD     0             MARG
     C                   Z-ADD     0             NMRPCT
     C                   MOVE      *BLANKS       OLIST             4
     C                   MOVE      *BLANKS       LIST
     C                   SETOFF                                       6061
     C     ITEM          CHAIN     FMINSER                            88
     C  N88ISCODE        CHAIN     FSERIES                            88
     C   88              DO
     C                   MOVE      *BLANKS       LVNAME
     C                   MOVE      *BLANKS       HVNAME
     C                   MOVE      *BLANKS       SVNAME
     C                   MOVE      *BLANKS       SEFORM
     C                   MOVE      *BLANKS       SEDESC
     C                   MOVE      *BLANKS       SECODE
     C                   Z-ADD     0             SELPRC
     C                   Z-ADD     0             SEHPRC
     C                   Z-ADD     0             SELSPR
     C                   Z-ADD     0             SEHVND
     C                   Z-ADD     0             SELVND
     C                   Z-ADD     0             ISVEND
     C                   GOTO      NOSER1
     C                   ENDDO
      ** GET VENDORS COST
     C     PRCKEY        CHAIN     FSERPRC                            87
     C   87              DO
     C                   Z-ADD     0             SSPRC
     C                   Z-ADD     0             PRC
     C                   GOTO      NOSER1
     C                   ENDDO
     C                   EXSR      GETPLG
      ** GET PRICE EACH
     C     NOSER1        TAG
     C     SIZE          CHAIN     FMSIZE                             90
     C                   If        IMTPSW = 'R'
     C                   Eval      SZCELL = 100
     C                   EndIf
     C     SZCELL        MULT      IM#SED        #SED              4 0
     C     #SED          MULT(H)   PLPRC         PLGCST
      ** GET FIXED COST
      *? Calculate Average Weeks to Grow
     C                   Eval      SEDIMMULT = 0

     C                   Eval      WksCount = 0
     C                   If        IMWG1 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG2 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG3 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG4 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        WksCount = 0
     C                   Eval      WksCount = 1
     C                   EndIf
     C                   Eval      TRAWTG    = (IMWG1 + IMWG2 + IMWG3 + IMWG4)/
     C                             WksCount
     C                   Z-ADD     0             FIXCST
     C                   MOVEL     IMTPSW        TSOW              1
     C     RTRY1         TAG
     C                   MOVE      *BLANKS       ITEMB            12
     C     TCSKEY        Chain     FOCOST
     C                   Eval      TRAWKOVRHD = TOCOST
     C                   Eval      TRAOVRHD = TRAWTG * TRAWKOVRHD
     C                   Eval      FIXCST = TRAOVRHD
     C     TCSKEY        SETLL     FTCOST
     C     NXTCS2        TAG
     C     TCSKEY        READE     FTCOST                                 90
     C   90              DO
     C     FIXCST        IFEQ      0
     C     TSOW          ANDGT     *BLANKS
     C                   MOVE      *BLANKS       TSOW
     C                   GOTO      RTRY1
     C                   ENDIF
     C                   ENDDO
     C  N90              DO
     C     TCQTY         MULT(H)   TCUCST        WRKCST            9 4
     C                   ADD       WRKCST        FIXCST
     C                   GOTO      NXTCS2
     C                   ENDDO
     C     PLGCST        ADD       FIXCST        TOTCST
      ** GET PRICE
     C     IMLIST        IFGT      *BLANKS
     C     IMLIST        CHAIN     FLISTCD                            51
     C                   Z-ADD     LCSEL5        UPRICE
     C                   ELSE
     C                   Z-ADD     IMSEL5        UPRICE
     C                   END
      ** CALC TRADE DISCOUNT
     C     UPRICE        IFGT      0.0000
     C     UPRICE        MULT      .20           TRDSC
     C     UPRICE        SUB       TRDSC         NETPRC
     C     NETPRC        SUB(H)    TOTCST        MARGIN                 55
     C     MARGIN        DIV(H)    NETPRC        MARWRK            9 6
     C     MARWRK        MULT      100           MARPCT            9 4
     C                   ELSE
     C                   Z-ADD     0             TRDSC
     C                   Z-ADD     0             NETPRC
     C                   Z-ADD     0             MARGIN
     C                   Z-ADD     0             MARPCT
     C                   END
     C                   EndSr
      ***********************
      ** GET PLUG PRICE    **
      ***********************
     C     GETPLG        BEGSR
      ** GET VENDORS COST
     C     MINFRM        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMFRSZ
     C     MINFRM        CHAIN(N)  FMINVT                             10
      ** GET PRICE EACH
     C     PRC(SEFORM)   DIV(H)    1000          SSPRC                          ?Seed Price
     C     IMSIZE        CHAIN     FMSIZE                             90
     C                   If        IMTPSW = 'R'
     C                   Eval      SZCELL = 100
     C                   EndIf
     C                   Z-ADD     SZCELL        SEDCEL                         ?Number of Cells
     C                   Z-ADD     SZSALE        PLGCEL                         ?Saleable Cells
     C                   Z-ADD     IM#SED        F#SED                          ?Seeds per Cell
     C                   MOVEL     IMTPSW        FTSOW             1
     C     SEDCEL        MULT      F#SED         #SED              4 0          ?Number of Seeds
     C     #SED          MULT(H)   SSPRC         SEDCST                         ?Seed Cost
      *? Calculate Average Weeks to Grow
     C                   Eval      SEDIMMULT = 0
     C     IMITEM        Chain     FMINVTL3
     C                   Eval      SMMULT = 1 + (SEDIMMULT/100)
     C                   Eval      SEDCST = SEDCST * SMMULT
      *? Calculate Average Weeks to Grow
     C                   Eval      WksCount = 0
     C                   If        IMWG1 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG2 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG3 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG4 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        WksCount = 0
     C                   Eval      WksCount = 1
     C                   EndIf
     C                   Eval      PLGWTG    = (IMWG1 + IMWG2 + IMWG3 + IMWG4)/
     C                             WksCount
      ** GET ORIGINAL ITEM AND SIZE
     C     MINKEY        CHAIN(N)  FMINVT                             10
     C     IMSIZE        CHAIN     FMSIZE                             90
      ** GET FIXED COST
     C                   Z-ADD     0             FIXPLG                         ?Fix Cost of Plug
     C     RTR1          TAG
     C     TCSKY         KLIST
     C                   KFLD                    ITEMB
     C                   KFLD                    IMFRSZ
     C                   KFLD                    FTSOW
     C                   MOVE      *BLANKS       ITEMB            12
     C     TCSKY         Chain     FOCOST
     C                   Eval      PLGWKOVRHD = TOCOST
     C                   Eval      PLGOVRHD = PLGWTG * PLGWKOVRHD
     C                   Eval      PLGGERM = TOGERM
     C                   Eval      FIXPLG = PLGOVRHD
     C     TCSKY         SETLL     FTCOST
     C     NXTCS1        TAG
     C     TCSKY         READE     FTCOST                                 90
     C   90              DO
     C     FIXPLG        IFEQ      0
     C     FTSOW         ANDGT     *BLANKS
     C                   MOVE      *BLANKS       FTSOW
     C                   GOTO      RTR1
     C                   ENDIF
     C                   ENDDO
     C  N90              DO
     C     TCQTY         MULT(H)   TCUCST        WRKCST            9 4
     C                   ADD       WRKCST        FIXPLG
     C                   GOTO      NXTCS1
     C                   ENDDO
     C     SEDCST        ADD       FIXPLG        TOTPLG
     C                   Eval      TOTPLGCOST = ( TOTPLG * 100 ) / PLGGERM
     C     TOTPLG        DIV(H)    PLGCEL        PLPRC
     C                   Eval      PLPRC = ( PLPRC * 100 ) / PLGGERM
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C     *Entry        PList
    ?C                   Parm                    Item                           ?Item
    ?C                   Parm                    Size                           ?Size
    ?C                   Parm                    TotCst                         ?Total Cost
    ?C                   Parm                    NetPrc                         ?Net Price
    ?C                   Parm                    Margin                         ?Profit Margin
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
