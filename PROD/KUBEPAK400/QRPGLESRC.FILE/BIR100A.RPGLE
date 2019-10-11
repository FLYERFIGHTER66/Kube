    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *??:````````````````````````````````````````````````````````````:?
      *??:     Change the Customer Number of an Order                 :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Jul. 2012            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program provides the ability to change a customer  ?:
      *? : number on an existing order.                              ?:
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
      *? :  $Date        ?Get Date Value                             ?:
      *? :  $DateMDY     ?Get Date Number in MM/DD/YY                ?:
      *? :  $Monday      ?Get Monday Date Value                      ?:
      *? :  $AddDate     ?Add/Subtract Days from Date                ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFMCUST    IF   E           K DISK
     FFMCUSTCN  IF   E           K DISK    RENAME(RMCUST:BILLTO)  PREFIX(BT_)   ?Customer Master

     FFHORDR    UF   E           K DISK
     FFIORDR    UF   E           K DISK
     FFIORDRWK  UF   E           K DISK
     FFIORESOW  UF A E           K DISK

     FFMTAXF    IF   E           K DISK
     FFMTERM    IF   E           K DISK                                         ?Terms File

      *? Function Prototypes
    ?D/COPY QFunctDefn,$UnitPrice
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User

      *? Field Definitions
     D   Order         S                   Like(OIORD#)                         ?
     D   NewCUST       S                   Like(OICUST)                         ?
     D   Tax1          S              5S 2 Inz(0)                               ?Tax:State Tax
     D   Tax2          S              5S 2 Inz(0)                               ?Tax:County Tax
     D   Tax3          S              5S 2 Inz(0)                               ?Tax:Local Tax
     D   TotalTax01    S              7S 2 Inz(0)                               ?Sum:State Tax
     D   TotalTax02    S              7S 2 Inz(0)                               ?Sum:County Tax
     D   TotalTax03    S              7S 2 Inz(0)                               ?Sum:Local Tax
     D   TotalOrder    S              9S 2 Inz(0)                               ?Total Order Value

    ?C     Order         Chain     FHORDR
    ?C     NewCUST       Chain     FMCUST
     C                   If        not %Equal(FHORDR) or
     C                             not %Found(FMCUST)
     C                   Return
     C                   EndIf

     C                   Eval      OHCUST = NewCUST

    ?C     CMBLCU        Chain     FMCUSTCN                                     ?Get billto info
     C                   Clear                   RMTERM
    ?C     BT_CMTMCD     Chain     FMTERM                                       ?Get Terms
     C                   Eval      OHNAME=CMNAME                                ?SHIP TO NAME
     C                   Eval      OHSHP2=CMADD2                                ?ADDRESS LINE #1
     C                   Eval      OHSHP3=CMADD3                                ?ADDRESS LINE #2
     C                   Eval      OHSHP4=CMADD4                                ?ADDRESS LINE #3
     C                   Eval      OHSHCT=CMCITY                                ?CITY
     C                   Eval      OHSHST=CMSTST                                ?STATE
     C                   Eval      OHSHZP=CMZIP                                 ?ZIP CODE

     C                   Eval      OHTERM=TCDESC                                ?TERMS
     C                   Eval      OHTRAT=*Zero                                 ?CASH DISC PERCENT
     C                   Eval      OHTDAY=*Zero                                 ?CASH DISCOUNT DAYS
     C                   Eval      OHTXST=CMTXST                                ?TAX EXEMPT
     C                   Eval      OHTXJU=CMTXJU                                ?JURISDICTION
      *?  Tax calculations for New Customer
     C                   Clear                   RMTAXF
     C                   Eval      OITXCD = 'N'                                 ?TAX ITEM CODE 1
     C                   Eval      OITXST = 'N'                                 ?TAX ITEM CODE 2
     C                   Eval      OITXCT = 'N'                                 ?TAX ITEM CODE 3
     C                   Eval      OITXLC = 'N'                                 ?TAX ITEM CODE 4
     C                   If        CMTXST = 'N'                                 ?Tax Exempt ?
    ?C     CMTXJU        Chain     FMTAXF                                       ?Item Master File
     C                   If        %found(FMTAXF)
     C                   Eval      OIAMT1=TXPCT1                                ?TAX AMT RATE 1
     C                   Eval      OIAMT2=TXPCT2                                ?TAX AMT RATE 2
     C                   Eval      OIAMT3=TXPCT3                                ?TAX AMT RATE 3
     C                   If           OIAMT1<>*Zero
     C                             or OIAMT2<>*Zero
     C                             or OIAMT3<>*Zero
     C                   Eval      OITXCD='Y'                                   ?TAX ITEM CODE 1
     C                   EndIf
     C                   If        OIAMT1<>*Zero
     C                   Eval      OITXST='Y'                                   ?TAX ITEM CODE 2
     C                   EndIf
     C                   If        OIAMT2<>*Zero
     C                   Eval      OITXCT='Y'                                   ?TAX ITEM CODE 3
     C                   EndIf
     C                   If        OIAMT3<>*Zero
     C                   Eval      OITXLC='Y'                                   ?TAX ITEM CODE 4
     C                   EndIf
     C                   EndIf
     C                   EndIf


    ?C     Order         SetLL     FIORDR
    ?C     Order         ReadE     FIORDR
     C                   DoW       not %EOF(FIORDR)
     C                   Eval      OICUST = NewCUST
     C                   Eval      OIUPRI=$UnitPrice(OIITEM:OISIZE:OHCUST)      ?UNIT PRICE
     C                   Eval      OIEXT$=OIQORD*OIUPRI                         ?EXT AMOUNT
     C                   Eval      OIDTLA=$MDYDate($Date(0))                    ?LAST ACTIVITY DATE
     C                   Eval      OITIME=$Now()                                ?TIME
     C                   Eval      OIUSER=$User                                 ?USER
     C                   Eval      OIALPH=CMLOOK                                ?CUST ALPHA SEARCH
    ?C                   Update    RIORDR
    ?C     Order         ReadE     FIORDR
     C                   EndDo

    ?C     Order         SetLL     FIORDRWK
    ?C     Order         ReadE     FIORDRWK
     C                   DoW       not %EOF(FIORDRWK)
     C                   Eval      OICUST = NewCUST
    ?C                   Update    RIORDRWK
    ?C     Order         ReadE     FIORDRWK
     C                   EndDo

    ?C     Order         SetLL     FIORESOW
    ?C     Order         ReadE     FIORESOW
     C                   DoW       not %EOF(FIORESOW)
     C                   Eval      OICUST = NewCUST
    ?C                   Update    RIORESOW
    ?C     Order         ReadE     FIORESOW
     C                   EndDo

    ?C                   Update    RHORDR

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      TAXES - Calculate Taxes for new Customer           :
      *?  :.........................................................:

     C     TAXES         BegSR
     C                   Eval      Tax1  = OIAMT1 * OIUPRI                      ?ST Tax on Item
     C                   Eval      Tax2  = OIAMT2 * OIUPRI                      ?CO Tax on Item
     C                   Eval      Tax3  = OIAMT3 * OIUPRI                      ?MU Tax on Item

     C                   Eval      TotalTax01 = TotalTax01 + Tax1               ?ST Total Tax
     C                   Eval      TotalTax02 = TotalTax02 + Tax2               ?CO Total Tax
     C                   Eval      TotalTax03 = TotalTax03 + Tax3               ?MU Total Tax
     C                   Eval      TotalOrder = TotalOrder + OIEXT$             ?Total Order Value
     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

    ?C     *Entry        PList
    ?C                   Parm                    Order                          Order Number
    ?C                   Parm                    NewCUST                        New Customer Number

     C                   EndSR
