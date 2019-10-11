    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DftActGrp(*No)
    ?H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
    ?H DatFmt(*Usa)
      *?-------------------------------------------------------------
      *?**PROGRAM NAME-------- TRR050
      *?**APPLICATION--------- CREATE TRUCK WORK FILE
      *?
      *?           CHANGE--DATE-------DESCRIPTION
      *?-------------------------------------------------------------

     FFHORDRCD  IF   E           K DISK

     FFTRSTAT   UF A E           K DISK
     FFTRUCKS   O    E           K DISK
     FFTRUCKO   O    E           K DISK

      *? .........................
      *? :  PROG DATA STRUCTURE  :
      *? :.......................:
    ?D                SDS
    ?D  PROGID                 1     10                                         ?PROGRAM NAME
    ?D  RLIBR                 81     90                                         ?RUN LIBRARY
    ?D  USERID               254    263                                         ?USER I.D.
    ?D  SLIBR                314    323                                         ?SOURCE LIBRARY
      *? .........................
      *? :  LDA                  :
      *? :.......................:
    ?D                UDS
    ?D  LCO                    1      2  0
    ?D  BEGDT                  3      8  0
    ?D  ENDDT                  9     14  0
    ?D  YEAR                  15     18  0
    ?D  WEEK                  19     20  0

      *? Field Definitions
    ?D  BEGCYM         S              7S 0
    ?D  ENDCYM         S              7S 0
    ?D  TDATE          S              6S 0
    ?D  TIMOD          S              6S 0

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$Week#
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$IsoYear

      *? .......................................................................
      *? :  START HERE                                                         :
      *? :.....................................................................:

    ?C     BEGCYM        SETLL     FHORDRCD

    ?C                   READ      FHORDRCD                               90
    ?C                   DoW       not %EOF(FHORDRCD) and OHDTRY <= ENDCYM
     C     OHSTAT        IfEq      'A'
     C     OHCOFL        AndNE     'Y'
    ?C                   ExSr      ProcessOrd
     C                   EndIf
    ?C                   READ      FHORDRCD                               90
    ?C                   EndDo

     C                   SETON                                        LR
     C*                  CALL      'GRS610_620'
     C*                  PARM                    BEGCYM

      *? .......................................................................
      *? :  Process this Order                                                 :
      *? :.....................................................................:
    ?C     ProcessOrd    BEGSR

    ?C                   Select
    ?C                   When      OHSHPC = '01' or
     C                             OHSHPC = '08' or
     C                             OHSHPC = '21' or
     C*                            OHSHPC = '40' or
     C                             OHSHPC = '41'
     C                   MOVEL     OHSHPC        TSSVIA
    ?C                   Other
     C                   LeaveSR
    ?C                   EndSL

    ?C                   EXSR      CalcCarts
    ?C                   EXSR      CalcQty

     C                   If        (OrdPLUG + OrdFLAT + OrdHBPT + OrdPOIN) <= 0
     C                   LeaveSR
     C                   EndIf

    ? ** NOW OUTPUT FILES FTRUCKS and FTRUCKO
      *?    FTRUCKO File
     C                   Z-ADD     OHORD#        TOORD#
     C                   Z-ADD     BEGCYM        TOSHPD
     C                   ADD       1             TOSEQ#
    ?C                   WRITE     RTRUCKO
      *?    FTRUCKS File
     C                   Eval      TSYEAR = YEAR                                ?YEAR (2001)
     C                   Eval      TSWEEK = WEEK                                ?WEEK #
     C*                  Eval      TSDAY#                                       ?DAY #
     C*                  Eval      TSROUT                                       ?ROUTE #
     C*                  Eval      TSSTOP                                       ?STOP #
     C*                  Eval      TSSVIA                                       ?SHIP VIA.
     C                   Eval      TSOVIA = OHSHPC                              ?ORDER SHIP VIA
     C*                  Eval      TSNVIA                                       ?NEW SHIP VIA.
     C*                  Eval      TSDRIV                                       ?DRIVER
     C*                  Eval      TSTRUC                                       ?TRUCK I.D.
     C                   Eval      TSCUST = OHCUST                              ?CUSTOMER #
     C                   Eval      TSZIP  = OHSHZP                              ?ZIP CODE
     C                   Eval      TSLOOK = OHALPH                              ?CUST. ALPHA
     C                   Eval      TSORD# = OHORD#                              ?ORDER #
     C                   Eval      TS#ORD = 1                                   ?# OF ORDERS
     C*                  Eval      TSSCHD                                       ?SCHEDULED DATE
     C*                  Eval      TSTIME                                       ?SCHEDULED TIME
     C                   Eval      TSSHPD = OHDTRY                              ?SHIP DATE DATE
     C                   Eval      TSSEQ# = TSSEQ# + 1                          ?SEQ. #
     C                   Eval      TSQTY1 = OrdPLUG                             ?QTY CODE 1
     C                   Eval      TSQTY2 = OrdFLAT                             ?QTY CODE 2
     C                   Eval      TSQTY3 = Carts                               ?QTY CODE 3
     C                   Eval      TSQTY4 = OrdHBPT                             ?QTY CODE 4
     C                   Eval      TSQTY5 = OrdPOIN                             ?QTY CODE 5
     C                   Eval      TSQTY6 = *Zero                               ?QTY CODE 6
    ?C                   WRITE     RTRUCKS

    ?C     BEGCYM        CHAIN     FTRSTAT                            91
     C                   Z-ADD     BEGCYM        STSHDT
     C                   MOVEL     'Y'           STBLDR
     C                   Z-ADD     TDATE         STBLDD
     C                   Z-ADD     TSSEQ#        STNSEQ
     C                   Z-ADD     TIMOD         STBLDT
     C                   MOVEL     USERID        STBLDU
     C                   Add       1             STNSEQ
    ?C   91              WRITE     RTRSTAT
    ?C  N91              UPDATE    RTRSTAT
    ?C                   EndSr
      *? .......................................................................
      *? :  Calculate Carts                                                    :
      *? :.....................................................................:
    ?C     CalcCarts     BegSr

     C                   Z-ADD     *ZERO         CARTS
     C                   Eval      ShipDate = $MDYDate($Date(OHDTRY))
    ?C                   Call      'BIR103'
    ?C                   Parm                    SHIPDATE          7 0
    ?C                   Parm                    OHORD#
    ?C                   Parm                    CARTS             5 2
    ?C                   Parm                    SHOWYN            1

    ?C                   EndSr
      *? .......................................................................
      *? :  Get Shipping Quantities                                            :
      *? :.....................................................................:
    ?C     CalcQty       BEGSR

    ?C                   Call      'TRR105'
    ?C                   Parm      OHORD#        Order#            6 0
    ?C                   Parm      BEGCYM        ShipDate          7 0
    ?C                   Parm      0             OrdPLUG           7 1
    ?C                   Parm      0             OrdFLAT           7 1
    ?C                   Parm      0             OrdHBPT           7 1
    ?C                   Parm      0             OrdPOIN           7 1

    ?C                   ENDSR

      *? .......................................................................
      *? :       *InzSR - Initialization Subroutine                            :
      *? :.....................................................................:
    ?C     *INZSR        BEGSR

     C                   Eval      TDate  = $MDYDate($Date(0))
     C                   Eval      BEGCYM = $Date7($DateMDY(BEGDT))
     C                   Eval      YEAR   = $IsoYear($DateMDY(BEGDT))
     C                   Eval      WEEK   = $Week#($DateMDY(BEGDT))
     C                   Eval      ENDCYM = $Date7($DateMDY(ENDDT))
     C                   Eval      TIMOD  = $Now()

     C   U1              MOVE      'Y'           SHOWYN
     C  NU1              MOVE      'N'           SHOWYN

    ?C                   ENDSR
