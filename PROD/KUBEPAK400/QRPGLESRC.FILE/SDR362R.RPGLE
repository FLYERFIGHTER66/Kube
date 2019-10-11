    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *--------------------------------------------------------------
      *
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- SDR362R
      **APPLICATION--------- ITEM COST/PRICE REPORT within Date Selection
      *
      *
     FSDR360WK  IP   E           K DISK
     FFMINSER   IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMINVTDESCIF   E           K DISK
     FFMINVTL3  IF   E           K DISK    RENAME(RMINVT:SEDINVT) PREFIX(SED)
     FFMSIZE    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFLISTCD   IF   E           K DISK
     FFTCOST    IF   E           K DISK
     FFOCOST    IF   E           K DISK
     FFSERIES   IF   E           K DISK
     FFSERPRC   IF   E           K DISK
     FFSEDCTL   IF   E           K DISK
     FSDR362P   O    E             PRINTER OFLIND(*IN11)
      *
      * PRICE ARRAY
     D PRC             S              9  4 DIM(3)                               PRICES
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
      *    LDA       *
      ****************
     D                UDS
     D  LCO                    1      2  0
     D  ALPHA                  3     17
     D  SIZE                  18     20
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LFRDT                134    141  0
     D  FRDT                 136    141  0
     D  LTODT                142    149  0
     D  TODT                 144    149  0
     D  LSORT                150    150
     D  IncludeKP            165    165
      *
     D  Wks2Germ       S              4S 2
     D  WksCount       S              1S 0
     D  SMMULT         S              6S 5
     D  Transplant     S               N
     D  Wrote1St       S               N
     D  HoldISCODE     S                   Like(ISCODE)
     D FCGERM          S                   LIKE(TOGERM)                         Factor Table Germ%
     D  CRTDate        S              6S 0                                      Item Created Date

      *? Function Prototypes
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date

     IRSERPRC
     I              SPPRC1                      PRC(1)
     I              SPPRC2                      PRC(2)
     I              SPPRC3                      PRC(3)
      //Free
    ?   //COPY QFunctDefn,LASTUSEDCB
      //End-Free
      ****************
      *   START HERE *
      ****************
     C     IMKEY         CHAIN     FMINVT                             99
     C                   If        IMSTAT = 'A'
     C*                  If        IMSOWC <> 'K' or IncludeKP = 'Y'
     C                   If        IMSOWC = ' ' or IncludeKP = 'Y'
     C                   MOVEL     WKDESC        DESCO            30
     C                   EXSR      GETCAL
     C                   MOVEL     IMITEM        ITEM              5
     C   11              DO
     C                   WRITE     HEAD
     C                   SETOFF                                       11
     C                   ENDDO
     C                   WRITE     DETL
     C                   Eval      Wrote1St = *On
     C                   EndIf
     C                   EndIf
      ********************
      ** GET CALCS      **
      ********************
     C     GETCAL        BEGSR
     C                   Z-ADD     0             OLDPRC            9 4
     C                   MOVE      *BLANKS       OLIST             4
     C     WKITEM        CHAIN     FMINSER                            88
    ?C     ItemSize      KList
    ?C                   KFld                    IMITEM
    ?C                   KFld                    IMSIZE
    ?C     ItemSize      Chain     FMINVTDESC
     C                   If        not %Found(FMINVTDESC)
     C                   Eval      IDDATE = $Date(1100901)
     C                   EndIf
     C                   Eval      CRTDATE = $MDYDate(IDDATE)

     C                   If        HoldISCODE <> ISCODE
     C                   Eval      HoldISCODE = ISCODE
     C                   If        Wrote1St and *In85
     C                   Write     UNDRLN
     C                   EndIf
     C                   EndIf
     C  N88ISCODE        CHAIN     FSERIES                            88
     C     NEWVND        TAG
      ** GET VENDORS COST
      ** SEE IF TRANSPLANT FROM
     C                   Eval      Transplant = *Off
     C     IMTPSW        IFEQ      'P'
     C     IMFRSZ        ANDGT     *BLANKS
     C                   Z-ADD     0             PLGCST
     C                   CALL      'SDRTXP'
     C                   PARM                    IMITEM
     C                   PARM                    IMFRSZ
     C                   PARM                    PLGCST            9 6
     C                   Eval      Transplant = *On
     C                   Z-ADD     PLGCST        SSPRC
     C                   GOTO      NOSERI
     C                   END
     C     PRCKEY        CHAIN     FSERPRC                            87
     C   87              DO
     C                   Z-ADD     0             PRC
     C                   Z-ADD     0             SSPRC             7 6
     C                   GOTO      NOSERI
     C                   ENDDO
     C     SPVEND        CHAIN     FMVEND                             52
     C                   MOVEL     VMNAME        NAM04             4
      ** GET PRICE EACH
     C     PRC(SEFORM)   DIV(H)    1000          SSPRC
     C**                   Z-ADDPRC,SEFORMSELSPR
     C     NOSERI        TAG
     C     IMSIZE        CHAIN     FMSIZE                             90
     C                   If        IMTPSW = 'R'
     C                   Eval      SZCELL = SZSALE
     C                   EndIf
     C     SZCELL        MULT      IM#SED        #SED              4 0
     C     #SED          MULT(H)   SSPRC         SEDCST            9 4
      *? Calculate Sow Factor and Add to Seed Cost
     C                   Eval      SEDIMMULT = 0
     C                   Eval      SMMULT = 1
     C                   If        not Transplant and IMTPSW <> 'R'
     C     IMITEM        Chain     FMINVTL3
     C                   Eval      SMMULT = 1 + (SEDIMMULT/100)
     C                   Eval      SEDCST = SEDCST * SMMULT
     C                   EndIf
      ** GET FIXED COST
     C                   Z-ADD     0             FIXCST            9 4
     C                   MOVE      *BLANKS       ITEMB            12
     C                   MOVEL     IMTPSW        TSOW              1
     C     RTRY          TAG
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
      *? Calculate Other Costs
     C                   Eval      TOCOST = *Zeros
     C*                  Eval      TOGERM = 100
     C                   Eval      FCGERM = 100
    ?C     TCSKEY        Chain     FOCOST
wjb  C                   Call      '$FACTGERM'
wjb  C                   Parm                    IMITEM
wjb  C                   Parm                    IMSIZE
wjb  C                   Parm                    GERM              5 4
wjb  C                   If        GERM <> 0
wjb  C                   Eval      FCGERM = GERM * 100
wjb  C                   EndIf
     C                   Eval      FixCst = TOCOST * Wks2Germ
      *? Calculate Fixed Costs
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
     C     SEDCST        ADD       FIXCST        TOTCST            9 4
     C                   If        not Transplant
     C*                  Eval      TOTCST = TOTCST * 100 / TOGERM
     C                   Eval      TOTCST = TOTCST * 100 / FCGERM
     C                   EndIf

      ** GET PRICE
     C     IMLIST        IFGT      *BLANKS
     C     IMLIST        CHAIN     FLISTCD                            51
     C                   Z-ADD     LCSEL5        UPRICE            9 4
     C                   SETOFF                                       22
     C                   ELSE
     C                   Z-ADD     IMSEL5        UPRICE
     C                   Z-ADD     IMSEL5        UPRIC             9 2
     C                   SETON                                        22
     C                   END
      ** CALC TRADE DISCOUNT
     C**         SZDISC    DIV  100       TRWRK   86
     C**         UPRICE    MULT TRWRK     TRDSC     H
     C     UPRICE        IFGT      0.0000
     C*    UPRICE        MULT(H)   .2000         TRDSC                  94
     C     UPRICE        MULT(H)   .2300         TRDSC                  94
     C     UPRICE        SUB       TRDSC         NETPRC                 94
     C     NETPRC        SUB(H)    TOTCST        MARGIN            6 2  55
     C     MARGIN        DIV(H)    NETPRC        MARWRK            9 6
     C     MARWRK        MULT      100           MARPCT            9 4
     C                   ELSE
     C                   Z-ADD     0             TRDSC             9 2
     C                   Z-ADD     0             NETPRC            9 2
     C                   Z-ADD     0             MARGIN
     C                   Z-ADD     0             MARPCT
     C                   END
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C     IMKEY         KLIST
     C                   KFLD                    WKITEM
     C                   KFLD                    WKSIZE
     C                   KFLD                    WHOUSE
     C                   MOVE      ' '           WHOUSE            3
     C     PRCKEY        KLIST
     C                   KFLD                    SEVND
     C                   KFLD                    SECODE
     C     TCSKEY        KLIST
     C                   KFLD                    ITEMB
     C                   KFLD                    IMSIZE
     C                   KFLD                    TSOW
     C     FRDT          MULT      100.0001      FRDT
     C     TODT          MULT      100.0001      TODT
WJB  C*          LSORT     IFEQ 'S'
WJB  C*                    MOVE *ON       *IN85
WJB  C*                    ELSE
WJB  C*                    MOVE *ON       *IN84
WJB  C*                    ENDIF
WJB  C                   SELECT
WJB  C     LSORT         WHENEQ    'P'
WJB  C                   MOVE      *ON           *IN84
WJB  C     LSORT         WHENEQ    'S'
WJB  C                   MOVE      *ON           *IN85
WJB  C     LSORT         WHENEQ    'Q'
WJB  C                   MOVE      *ON           *IN86
WJB  C                   ENDSL
     C     01            CHAIN     FSEDCTL                            90
     C                   SETON                                        11
     C                   ENDSR
