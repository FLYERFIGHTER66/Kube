    ?H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DftActGrp(*No)
    ?H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
    ?H DatFmt(*Usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:   FXG065 - Fixing - Recalc all FLOSSLOT records            :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  December 2005        ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? :  *INZSR   -?Initialization Subroutine                     ?:
      *? :  *INZSR   -?Initialization Subroutine                     ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Edit Log                                                ?:
      *? :                                                           ?:
      *? :  WJB    -?11/30/05 - Initial Coding                       ?:
      *? :............................................................:

     FFLOSSLOTR UF   E           K DISK                                         ?Loss Lot Details

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$MDYDate

      *? Field Definitions
     D   Today         S                   Like(LDDTLA)                         ?Today's Date
     D   Reason        S              1A                                        ?Reason Code
     D   ShipDate      S              7S 0                                      ?Ship Date
     D   QtyOrdered    S              7S 0                                      ?Quantity Ordered
     D   QtySown       S              7S 0                                      ?Quantity Sown
     D   QtyLost       S              7S 0                                      ?Quantity Lost Fix
     D   TotalLoss     S              7S 0                                      ?Quantity Lost All
     D   Scanned       S              7S 0                                      ?Quantity Scanned
     D   Unfixed       S              7S 0                                      ?Quant Unfixed
     D   Partial       S              7S 0                                      ?Count Partials
     D   PartSum       S              7S 2                                      ?Sum Partials
     D   ReadyDate     S              7S 0                                      ?Ready Date
     D   ReadyDate@    S              7                                         ?Ready Date

     C                   Eval      ReadyDate = %Int(ReadyDate@)

    ?C     ReadyDate     SetLL     FLOSSLOTR
    ?C     ReadyDate     ReadE     FLOSSLOTR
     C                   DoW       not %Eof(FLOSSLOTR)
    ?C                   Call      'FXG061'      FXG061                         ?
    ?C                   Update    RLOSSLOT
    ?C     ReadyDate     ReadE     FLOSSLOTR
     C                   EndDo

     C                   Eval      *InLr = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *Entry        PList
    ?C                   Parm                    ReadyDate@                     Ready Date 7A

    ?C     FXG061        PList
    ?C                   Parm                    LDITEM
    ?C                   Parm                    LDSIZE
    ?C                   Parm      LDREDY        ShipDate
    ?C                   Parm      'F'           Reason
    ?C     LDQORD        Parm      0             QtyOrdered
    ?C     LDQSOW        Parm      0             QtySown
    ?C     LDCONT        Parm      0             QtyLost
    ?C     LDTLOS        Parm      0             TotalLoss
    ?C     LDSCAN        Parm      0             Scanned
    ?C     LDNOTC        Parm      0             Unfixed
    ?C     LDPART        Parm      0             Partial
    ?C     LDPRTT        Parm      0             PartSum

     C                   Eval      Today = $MDYDate($Date(0))
    ?C                   EndSr                                                  ?
