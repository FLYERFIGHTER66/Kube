    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:     Call BIR103 with all shipdates in and Order.           :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  May  2007            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? : Subroutine ?-Subroutine Description                  ?  ?:
      *? :  *INZSR      -?Initialization Subroutine                  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? : Function   ?-Function Description                    ?  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : Int   Date  ?-Change Description                     ?  ?:
      *? :  WB01 5/07/07  ?Initial Programming.                      ?:
      *? :............................................................:

     FFIORDR    IF   E           K DISK

      *? Field Definitions
     D Order#          S                   Like(OIORD#)
     D SaveOIDTRQ      S                   Like(OIDTRQ) Inz(0)

      *? Indicators
     D  NewSDate       S               N   Inz(*Off)

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

      *? Read through SQL cursor and Call BIR103
    ?C     ORDER#        SetLL     FIORDR
    ?C     ORDER#        ReadE     FIORDR
   ? C                   DoW       not %EOF(FIORDR)
   ? C                   If        OIDTRQ <> SaveOIDTRQ
     C                   Eval      SaveOIDTRQ =  OIDTRQ
     C                   Call      'BIR103'      BIR103
   ? C                   EndIf
    ?C     ORDER#        ReadE     FIORDR
   ? C                   EndDo

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

   ? C     *Entry        PList
   ? C                   Parm                    ORDER#

   ? C     BIR103        PList
   ? C                   Parm                    OIDTRQ                         ?Ship Date
   ? C                   Parm                    OIORD#                         ?Order Number
   ? C                   Parm                    Qty_Carts         5 2          ?Number of Carts
   ? C                   Parm      'N'           Show_YN           1            ?Show Screen Y/N

     C                   EndSR
