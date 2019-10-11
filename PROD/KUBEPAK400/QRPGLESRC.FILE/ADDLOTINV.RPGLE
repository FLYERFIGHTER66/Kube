    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *?                                                              ?
      *??|                                                            |?
      *??|               Add Lot Inventory (ADDLOTINV)                |?
      *?|                                                            |?

      *? :````````````````````````````````````````````````````````````:
      *? : Created:  October, 2005        ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :  Program Description?                                    ?:
      *? : This program will be called when a tray is sown or         :
      *? : verified.  The tray number or range of numbers is         ?:
      *? : provided as parameters.  This program allocates each      ?:
      *? : tray to an order on the FALITEM file and updates the      ?:
      *? : lot inventory on FDLOT & FDLOTRD.  Any trays that are     ?:
      *? : not allocated to an order are allocated as FIXERS.        ?:
      *? :............................................................:
      *?                                                              ?
      *? |?  Subroutine Usage                                        ?|
      *? |                                                           ?|
      *? | CheckOrders?- Check Orders Allocation                     ?|
      *? | AllocFixers?- Allocate Fixer Trays                        ?|
      *? | UpdateLots ?- Update FDLOT & FDLOTRD                      ?|
      *? | *InzSr     ?- Must I explain this ?!?!?                   ?|
      *?|                                                            |?
      *?                                                              ?
      *? |?  Function Usage                                          ?|
      *? |                                                           ?|
      *? | $MDYDate   ?- Return MDY Date from Date Field             ?|
      *? | $Date      ?- Return Date field from Number               ?|
      *? | $User      ?- Return Current User I.D.                    ?|
      *? | $Now       ?- Return Current Time as Number               ?|
      *?|                                                            |?
      *?                                                              ?
      *? |?  Indicator Usage                                         ?|
      *? |                                                           ?|
      *? |  LR      ?Does this really need a description ?           ?|
      *?|                                                            |?
      *?                                                              ?
      *? |?  Edit Log                                                ?|
      *? |                                                           ?|
      *? |WJB10/14/05?-Initial Programming                        ?|
      *? |   mm/dd/yy?-                                           ?|
      *?|                                                            |?

     FFTRAY     UF   E           K DISK
     FFIORDRL5  UF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFALITEML2 UF A E           K DISK
     FFDLOTALOC UF A E           K DISK
     FFDLOTRDCLTUF A E           K DISK
     FFDLOTRD990UF A E           K DISK    Rename(RDLOTRD:RDLOTRD990)

      *? Function Prototypes
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Now

      *? Field Definitions
    ?D StartTag#       S              8S 0
    ?D EndTag#         S              8S 0
    ?D Allocated       S               N   Inz(*Off)
    ?D isOverRun       S               N   Inz(*Off)
    ?D FixerOrder      S              6S 0
    ?D FixerSeq#       S              3S 0 Inz(0)
    ?D FixerCUST       S                   Like(OHCUST)
    ?D DftWHSE         S                   Like(LDWHSE) Inz(*Blanks)
    ?D TotOnOrder      S              7S 1 Inz(*Zero)
    ?D QtyToSow        S              7S 1 Inz(*Zero)
    ?D FIXERS          S              6S 0 Inz(*Zero)
    ?D FullyAllocated  S               N   Inz(*Off)
    ?D CUST990         S                   Like(OHCUST) Inz(999990)
    ?D Found990        S               N

     ?*   ................................................
     ?*   :   Main Calcs                                 :
     ?*   :..............................................:

      *?   Process all tags within the given range
    ?C     StartTag#     SetLL     FTRAY
    ?C                   Read      FTRAY

     C                   If        %EOF(FTRAY)
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf

     C                   DoW       TRTAG# <= EndTag#
WJB  C                             and not %EOF(FTRAY)
      *    Check if this tray needs 'PARTIAL' processing
     C                   If        TRCNTD = 'P' or TRSTAT = 'P'
     C                   Unlock    FTRAY
     C                   Call      'PRTLOTINV'
     C                   Parm                    TRTAG#
     C                   Else
      *?   Only do allocations if tray is not already counted and is active.
     C*                  If        TRCNTD =  ' ' and
     C*                            TRSTAT =  'A' and
     C*                            TRREAS =  ' ' OR
     C*                            TRCNTD =  ' ' and
     C*                            TRSTAT =  'A' and
     C*                            TRREAS =  'PNS'
     C                   If        TRSTAT =  'A' and
     C                             TRCNTD <> 'Y'
    ?C     ItemKey       Chain     FMINVT
    ?C                   ExSr      Check990s
     C                   If        not Found990
    ?C                   ExSr      CheckOrders
      *?   If tray cannot be allocated to an order then allocate it as a fixer.
     C                   If        not Allocated
     C                             or  isOverRun
    ?C                   ExSr      AllocFixers
     C                   EndIf
     C                   EndIf
      *?   Now that the item has been allocated update the Lot Files.
    ?C                   ExSr      UpdateLots
      *?   Now mark the Tray as having been counted in the lot.
     C                   Eval      TRCNTD = 'Y'
    ?C                   Update    RTRAY
     C                   EndIf
     C                   EndIf
    ?C                   Read      FTRAY
     C                   EndDo

     C                   Eval      *InLr = *On

     ?*   ................................................
     ?*   :      Check990s - Check FDLOTRD forTrays      :
     ?*   :..............................................:

     C     Check990s     BegSr

     C                   Eval      Found990  = *Off
     C     Key990        Chain     FDLOTRD990
     C                   If        %Found(FDLOTRD990) and LRQTOH < 0
     C                   Eval      LRQTOH = LRQTOH + 1
     C                   Eval      LRQTAV = LRQTAV + 1
     C                   Eval      LRUSER = 'ADDLOTINVa'
     C                   Eval      LRDTLA = $MDYDate($Date(0))
     C                   Eval      LRTIME = $Now()
     C                   Eval      Allocated = *On
     C                   Eval      Found990  = *On
     C                   Update    RDLOTRD990
     C                   EndIf

     C                   EndSr

     ?*   ................................................
     ?*   :      CheckOrders - Check Orders Allocation   :
     ?*   :..............................................:

     C     CheckOrders   BegSr

     C                   Eval      isOverRun = *Off
     C                   If        TRLIN# = 8
     C                   Eval      isOverRun = *On
     C                   Else

     C                   Eval      Allocated = *Off
     C                   Eval      TotOnOrder = *Zero
    ?C     ItemLot       SetLL     FIORDRL5
    ?C     ItemLot       ReadE     FIORDRL5

     C                   DoW       not %EOF(FIORDRL5) and
     C                             not Allocated
     C                   Eval      TotOnOrder = TotOnOrder + OIQORD
      *?   Only process order if has been posted.
     C*Changed 3/07/2012 If        OIPOST = 'Y'                                  Only Posted
     C*Changed 1/28/2014 If        OIPOST = 'Y' or OIPOST <> 'Y'                 Do regardless
     C                   If        OIPOST = 'Y'                                  Only Posted
    ?C     OIORD#        Chain     FHORDR
    ?C     AllocKey      Chain     FALITEML2
      *?   Determine if Order is allocated
     C                   If        %Found(FALITEML2)
     C                   If        AIQTOA < OIQORD
      *?                 If not fully allocated, allocate this tray to this order
     C                   Eval      AIQTOA = AIQTOA + 1
     C                   Eval      Allocated = *On
    ?C                   Update    RALITEM
     C                   EndIf
      *?                 Create first allocation
     C                   Else
     C                   Eval      AIORD# = OIORD#                              ?ORDER NUMBER
     C                   Eval      AIOSEQ = OISEQ#                              ?ORDER SEQ #
     C                   Eval      AISHPD = TRCRDT                              ?SHIP DATE CYMD
     C                   Eval      AISTAT = 'A'                                 ?STATUS A/D/C
     C                   Eval      AIITEM = IMITEM                              ?ITEM #
     C                   Eval      AISIZE = IMSIZE                              ?SIZE CODE
     C                   Eval      AIWHSE = DftWHSE                             ?LOCATION
     C                   Eval      AISOWD = TRSCYM                              ?SOW DATE CYMD
     C                   Eval      AIGLOC = ' '                                 ?GROW LOC. ORIG
     C                   Eval      AIPHYT = ' '                                 ?PHYTO CODE
     C                   Eval      AICRDY = TRCRDT                              ?CURR READY DATE CY
     C                   Eval      AICUST = OHCUST                              ?RESERV. CUST #
     C                   Eval      AICOMP = 1                                   ?COMPANY NO
     C                   Eval      AIQTOA = 1                                   ?QTY ALLOC
     C                   Eval      AIDTLA = $MDYDate($Date(0))                  ?LAST ACTIVITY DATE
     C                   Eval      AITIME = $Now()                              ?TIME
     C                   Eval      AIUSER = $User()                             ?USER
     C                   Eval      AIPRCL = OIPRCL                              ?PRODUCT CLASS
     C                   Eval      Allocated = *On
    ?C                   Write     RALITEM
      *?   Change order detail Allocation
     C                   Eval      OIQTAL = OIQTAL + 1                          ?Quantity Allocated
      *?   Change order detail to look like a lot order
     C                   Eval      OILOTC = 'Y'                                 ?Lot Control
     C*                  Eval      OIPOST = ' '                                 ?Post Flag
     C*                  Eval      OISOW  = *Zeros                              ?Sow Date CYMD
      *?   Change order detail to differentiate from Lot Order
     C                   Eval      OILOT# = 'CustomOrdr'                        ?Lot Order Number
    ?C                   Update    RIORDR
     C                   EndIf
     C                   EndIf
      *?   Keep reading through the lot until you find one
     C                   If        not Allocated
    ?C     ItemLot       ReadE     FIORDRL5
     C                   EndIf
     C                   EndDo
     C                   EndIf
     C                   EndSr

     ?*   ................................................
     ?*   :      AllocFixers - Allocate Fixer Trays      :
     ?*   :..............................................:

     C     AllocFixers   BegSr

    ?C                   Call      '#SOWFACT71'
    ?C                   Parm                    IMITEM
    ?C                   Parm                    IMSIZE
    ?C                   Parm                    IMFTAB
    ?C                   Parm                    TotOnOrder
    ?C                   Parm                    QtyToSow

     C                   Eval      FixerOrder = 999999                          ?ORDER NUMBER
     C                   Eval      FixerCUST  = 999999                          ?Customer #
     C                   If        isOverRun
     C                   Eval      FixerOrder = 999998                          ?ORDER NUMBER
     C                   Eval      FixerCUST  = 999998                          ?Customer #
     C                   EndIf
WJB  C                   Eval      OHCUST = FixerOrder
     C                   Eval      FullyAllocated = *Off
    ?C     FixerKey      Chain     FALITEML2
     C                   If        %Found(FALITEML2)
     C                   If        AIQTOA >= QtyToSow and not isOverRun
     C                   Eval      OHCUST = *Zero
     C                   Eval      FullyAllocated = *On
     C                   LeaveSR
     C                   EndIf
     C                   Eval      AIQTOA = AIQTOA + 1                          ?QTY ALLOC
    ?C                   Update    RALITEM
     C                   Else
     C                   Eval      AIORD# = FixerOrder                          ?ORDER NUMBER
     C                   Eval      AIOSEQ = FixerSeq#                           ?ORDER SEQ #
     C                   Eval      AISHPD = TRCRDT                              ?SHIP DATE CYMD
     C                   Eval      AISTAT = 'A'                                 ?STATUS A/D/C
     C                   Eval      AIITEM = IMITEM                              ?ITEM #
     C                   Eval      AISIZE = IMSIZE                              ?SIZE CODE
     C                   Eval      AIWHSE = DftWHSE                             ?LOCATION
     C                   Eval      AISOWD = TRSCYM                              ?SOW DATE CYMD
     C                   Eval      AIGLOC = ' '                                 ?GROW LOC. ORIG
     C                   Eval      AIPHYT = ' '                                 ?PHYTO CODE
     C                   Eval      AICRDY = TRCRDT                              ?CURR READY DATE CY
     C                   Eval      AICUST = FixerCUST                           ?RESERV. CUST #
     C                   Eval      AICOMP = 1                                   ?COMPANY NO
     C                   Eval      AIQTOA = 1                                   ?QTY ALLOC
     C                   Eval      AIDTLA = $MDYDate($Date(0))                  ?LAST ACTIVITY DATE
     C                   Eval      AITIME = $Now()                              ?TIME
     C                   Eval      AIUSER = $User()                             ?USER
     C                   Eval      AIPRCL = TRPRDC                              ?PRODUCT CLASS
    ?C                   Write     RALITEM
     C                   EndIf

     C                   EndSr

     ?*   ................................................
     ?*   :      UpdateLots - Update FDLOT & FDLOTRD     :
     ?*   :..............................................:

     C     UpdateLots    BegSr

     C                   Eval      LDWHSE = DftWHSE                             ?Default Location
      *?   Update or Write the FDLOT file record
    ?C     LotKey        Chain     FDLOTALOC
     C                   If        %Found(FDLOTALOC)
     C                   Eval      LDQTOH = LDQTOH + 1                          ?QTY O/H
     C                   If        Found990
     C                   Eval      LDQTAV = LDQTAV + 1                          ?QTY AVAILABLE
     C                   Else
     C                   If        not FullyAllocated
     C                   Eval      LDQTAL = LDQTAL + 1                          ?QTY ALLOC
     C                   Else
     C                   Eval      LDQTAV = LDQTAV + 1                          ?QTY AVAILABLE
     C                   EndIf
     C                   Eval      LDSOWN = LDSOWN + 1                          ?QTY ACT SOWN
     C                   EndIf
    ?C                   Update    RDLOT
     C                   Else
     C                   Eval      LDSTAT = 'A'                                 ?STATUS A/D/C
     C                   Eval      LDITEM = IMITEM                              ?ITEM #
     C                   Eval      LDSIZE = IMSIZE                              ?SIZE CODE
     C                   Eval      LDWHSE = DftWHSE                             ?LOCATION
     C                   Eval      LDSOWD = TRSCYM                              ?SOW DATE CYMD
     C                   Eval      LDGLOC = ' '                                 ?GROW LOCATION
     C                   Eval      LDPHYT = ' '                                 ?PHYTO CODE
     C                   Eval      LDFIXD = 'N'                                 ?FIXED Y/N
     C                   Eval      LDAREA = ' '                                 ?AREA
     C                   Eval      LDCOMP = IMCOMP                              ?COMPANY NO
     C                   Eval      LDSHPD = TRCRDT                              ?ORIG READY DATE
     C                   Eval      LDCOST = 0                                   ?UNIT COST
     C                   Eval      LDVEND = 0                                   ?VENDOR NO
     C                   Eval      LDQTOH = 1                                   ?QTY O/H
     C                   If        not FullyAllocated
     C                   Eval      LDQTAL = 1                                   ?QTY ALLOC
     C                   Eval      LDQTAV = 0                                   ?QTY AVAIL
     C                   Else
     C                   Eval      LDQTAL = 0                                   ?QTY ALLOC
     C                   Eval      LDQTAV = 1                                   ?QTY AVAIL
     C                   EndIf
     C                   Eval      LDQTSP = 0                                   ?QTY SHIPPED
     C                   Eval      LDQTAJ = 0                                   ?QTY ADJUSTED
     C                   Eval      LDQFIX = 0                                   ?QTY FIXERS
     C                   Eval      LDQDMP = 0                                   ?QTY DUMPED
     C                   Eval      LDQTXP = 0                                   ?QTY TRANSPLANTED
     C                   Eval      LDDTLA = $MDYDATE($DATE(0))                  ?LAST ACTIVITY DATE
     C                   Eval      LDTIME = $NOW()                              ?TIME
     C                   Eval      LDUSER = $USER()                             ?USER
     C                   Eval      LDPCQT = 0                                   ?PHYS COUNT
     C                   Eval      LDALPH = TRALPH                              ?ALPHA SEARCH
     C                   Eval      LDCRDY = TRCRDT                              ?CURR. READY DATE C
     C                   Eval      LDSOWN = 1                                   ?QTY ACT SOWN
     C                   Eval      LDSDLT = *Blanks                             ?SEED LOT NUMBER
     C                   Eval      LDGERM = 0                                   ?GERM PERCENT
     C                   Eval      LDDESC = IMDES1                              ?DESCRIPTION
     C                   Eval      LDPRCL = TRPRDC                              ?PRODUCT CLASS
    ?C                   Write     RDLOT
     C                   EndIf

      *?   Update or Write the FDLOTRD file record
     C                   If        not Found990
    ?C     LotKeyRD      Chain     FDLOTRDCLT
     C                   If        %Found(FDLOTRDCLT)
     C                   If        not FullyAllocated
     C                   Eval      LRQTAL = LRQTAL + 1                          ?QTY ALOC
     C                   Else
     C                   Eval      LRQTAV = LRQTAV + 1                          ?QTY AVAILABLE
     C                   EndIf
     C                   Eval      LRQTOH = LRQTOH + 1                          ?QTY O/H
    ?C                   Update    RDLOTRD
     C                   Else
     C                   Eval      LRSTAT = 'A'                                 ?STATUS A/D/C
     C                   Eval      LRITEM = IMITEM                              ?ITEM #
     C                   Eval      LRSIZE = IMSIZE                              ?SIZE CODE
     C                   Eval      LRWHSE = DftWHSE                             ?LOCATION
     C                   Eval      LRSOWD = TRSCYM                              ?SOW DATE CYMD
     C                   Eval      LRGLOC = ' '                                 ?GROW LOC. ORIG
     C                   Eval      LRPHYT = ' '                                 ?PHYTO CODE
     C                   Eval      LRCRDY = TRCRDT                              ?CURR. READY DATE C
     C                   Eval      LRCPHY = ' '                                 ?CURR PHYTO CODE
     C                   Eval      LRCLOC = ' '                                 ?LOC. CURR
     C                   Eval      LRCODE = 'A'                                 ?CODE A/H/R/S/T
     C                   Eval      LRCUST = OHCUST                              ?RESERV. CUST #
     C                   Eval      LRAREA = ' '                                 ?AREA
     C                   Eval      LRCOMP = IMCOMP                              ?COMPANY NO
     C                   Eval      LRQTOH = 1                                   ?QTY O/H
     C                   Eval      LRDTLA = $MDYDATE($DATE(0))                  ?LAST ACTIVITY DATE
     C                   Eval      LRTIME = $NOW()                              ?TIME
     C                   Eval      LRUSER = $USER()                             ?USER
     C                   Eval      LRALPH = IMLOOK                              ?ALPHA SEARCH
     C                   Eval      LRPRCL = TRPRDC                              ?PRODUCT CLASS
     C                   If        not FullyAllocated
     C                   Eval      LRQTAL = 1                                   ?QTY ALOC
     C                   Eval      LRQTAV = 0                                   ?QTY AVAIL
     C                   Else
     C                   Eval      LRQTAL = 0                                   ?QTY ALOC
     C                   Eval      LRQTAV = 1                                   ?QTY AVAIL
     C                   EndIf
     C                   Eval      LRDESC = IMDES1                              ?DESCRIPTION
     C                   Eval      LRQTCM = 0                                   ?QTY COMIT
     C                   Eval      LRQTSL = 0                                   ?QTY SOLD
     C                   Eval      LRQADJ = 0                                   ?QTY ADJ
    ?C                   Write     RDLOTRD
     C                   EndIf
     C                   EndIf

     C                   EndSr

     ?*   ................................................
     ?*   :      *InzSr - Initialization Subroutine      :
     ?*   :..............................................:

     C     *InzSr        BegSr

     *
?    C     *Entry        PList
?    C                   Parm                    StartTag#
    C                   Parm                    EndTag#

TEMP C*                  Eval      StartTag# = 1391310
TEMP C*                  Eval      EndTag#   = 1391448

     C                   If        EndTag# < StartTag#
     C                   Eval      EndTag# = StartTag#
     C                   EndIf

    ?C     ItemKey       KList
    ?C                   KFld                    TRITEM
    ?C                   KFld                    TRSIZE
    ?C     ItemLot       KList
    ?C                   KFld                    TRITEM
    ?C                   KFld                    TRSIZE
    ?C                   KFld                    TRCRDT
    ?C     AllocKey      KList
WHT ?C                   KFld                    OIORD#                         |Order Number
WHT ?C                   KFld                    OISEQ#                         |Order SEQ#
WHT ?C                   KFld                    TRITEM                         |Item
WHT ?C                   KFld                    TRSIZE                         |Size
WHT ?C                   KFld                    TRSCYM                         |Sow Date
WHT ?C                   KFld                    DftWHSE                        |Warehouse
WHT ?C                   KFld                    OHCUST                         |Customer
WHT ?C                   KFld                    TRCRDT                         |Ready Date
    ?C     FixerKey      KList
WHT ?C                   KFld                    FixerOrder                     |Order Number
WHT ?C                   KFld                    FixerSeq#                      |Order SEQ#
WHT ?C                   KFld                    TRITEM                         |Item
WHT ?C                   KFld                    TRSIZE                         |Size
WHT ?C                   KFld                    TRSCYM                         |Sow Date
WHT ?C                   KFld                    DftWHSE                        |Warehouse
WHT ?C                   KFld                    FixerCUST                      |Customer
WHT ?C                   KFld                    TRCRDT                         |Ready Date
    ?C     LotKey        KList
    ?C                   KFld                    TRITEM                         ?Item
    ?C                   KFld                    TRSIZE                         ?Size
    ?C                   KFld                    DftWHSE                        ?Default Location
    ?C                   KFld                    TRSCYM                         ?Sow Date
    ?C                   KFld                    TRCRDT                         ?Ready Date
    ?C     LotKeyRD      KList
    ?C                   KFld                    TRITEM                         ?Item
    ?C                   KFld                    TRSIZE                         ?Size
    ?C                   KFld                    DftWHSE                        ?Default Location
    ?C                   KFld                    TRSCYM                         ?Sow Date
    ?C                   KFld                    TRCRDT                         ?Ready Date
    ?C                   KFld                    OHCUST                         ?Customer

    ?C     Key990        KList
    ?C                   KFld                    TRITEM                         ?Item
    ?C                   KFld                    TRSIZE                         ?Size
    ?C                   KFld                    DftWHSE                        ?Default Location
    ?C                   KFld                    TRSCYM                         ?Sow Date
    ?C                   KFld                    TRCRDT                         ?Ready Date
    ?C                   KFld                    CUST990                        ?Customer

     C                   EndSr
