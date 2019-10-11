    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:     Populate the REP010PF file.                            :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Nov. 2010            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program lists Customer PC Changes.                 ?:
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
      *? :  WJB 11/05/10  ?Initial Programming                       ?:
      *? :  ... ../../..  ?..........................................?:
      *? :............................................................:

     FFMCUSTAL  IP   E           K DISK
     FREP030P   O    E             PRINTER OFLIND(*In01)

     D  PC             S                   Like(CMPRCD)
     D  FirstPage      S               N   Inz(*On)

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

     C*                  If        CMCTYP = '05' or CMCTYP = '12'
     C                   If        CMBABB <> 'TRICO'                            All TRICO = PC 5
     C                   Call      '#PRICECODE'
     C                   Parm                    CMCUST
     C                   Parm                    PC
     C                   Else
     C                   Eval      PC = 5
     C                   EndIf

     C                   If        PC <> CMPRCD and PC <> 0
     C                   If        FirstPage or *In01
     C                   Write     Header
     C                   Eval      FirstPage = *Off
     C                   Eval      *In01 = *Off
     C                   SetOff                                       OV
     C                   EndIf
     C                   Write     CustDet
     C                   EndIf
     C*                  EndIf

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR


     C                   EndSR
