    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *?                                                              ?
      *??|                                                            |?
      *??|            Remove Lot Inventory (RMVLOTINV)                |?
      *?|                                                            |?

      *? :````````````````````````````````````````````````````````````:
      *? : Created:  February, 2006       ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :  Program Description?                                    ?:
      *? : This program will be called when a tray is used or         :
      *? : destroyed. The tray number or range of numbers is         ?:
      *? : provided as parameters.  This program de-allocates each   ?:
      *? : tray from an order on the FALITEM file and updates the    ?:
      *? : lot inventory on FDLOT & FDLOTRD.                         ?:
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
     FFALITEML  UF A E           K DISK
     FFDLOTALOC UF A E           K DISK
     FFDLOTRDCLTUF A E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Now

      *? Field Definitions
    ?D StartTag#       S              8S 0
    ?D EndTag#         S              8S 0
    ?D Allocated       S               N   Inz(*Off)
    ?D FixerOrder      S              6S 0 Inz(999999)
    ?D FixerSeq#       S              3S 0 Inz(0)
    ?D FixerCUST       S                   Like(OHCUST) Inz(999999)
    ?D Cust999990      S                   Like(OHCUST) Inz(999990)
    ?D DftWHSE         S                   Like(LDWHSE) Inz(*Blanks)
    ?D Type            S             10A

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
     C                             and not %EOF(FTRAY)
      *?   Check if this tray needs 'PARTIAL' processing
     C                   If        TRCNTD = 'P' or TRSTAT = 'P'
     C                   Unlock    FTRAY
     C                   Call      'PRTLOTINV'
     C                   Parm                    TRTAG#
     C                   Else
      *?   Only do deallocations if tray is already counted and is Lost.
     C                   If        TRCNTD =  'Y' and
     C                             TRSTAT <> 'A' and
     C                             TRITEM <> '2786'                             ?Don't do spikes

     C                   ExSr      WhatType
    ?C                   Select
      *?   If fixers are still allocated deallocate a fixer and subtract 1 from On-hand.
    ?C                   When      Type = 'DeAlocFixr'
     C                   ExSr      DeAlocFixr
      *?   No Fixers look for Available ==> Subtract from On-hand or write negative inventory
    ?C                   When      Type = 'SubtInven'
     C                   ExSr      SubtInven
    ?C                   EndSL
      *?   Now update the Tray File as having been removed from inventory.
     C                   Eval      TRCNTD = 'D'                                 ?Deleted
    ?C                   Update    RTRAY
     C                   EndIf
     C                   EndIf
    ?C                   Read      FTRAY
     C                   EndDo

     C                   Eval      *InLr = *On

     ?*   .....................................................
     ?*   :      WhatType - What Type of Deallocation ?       :
     ?*   :...................................................:

     C     WhatType      BegSr

    ?C     AllocKey      Chain     FALITEML
     C                   If        %Found(FALITEML)
     C                             and AIQTOA > *Zero
     C                   Eval      Type = 'DeAlocFixr'
     C                   Else
     C                   Eval      Type = 'SubtInven'
     C                   EndIf

     C                   EndSr


     ?*   ................................................
     ?*   :      DeAlocFixr - Deallocate Fixers          :
     ?*   :..............................................:

     C     DeAlocFixr    BegSr

      *?   Subtract from the Fixer allocation record for this lot.
    ?C     AllocKey      Chain     FALITEML
     C                   If        %Found(FALITEML)
     C                   Eval      AIQTOA = AIQTOA - 1
     C                   If        AIQTOA > 0
    ?C                   Update    RALITEM
     C                   Else
    ?C                   Delete    RALITEM
     C                   EndIf
     C                   EndIf
      *?   Subtract one from the Lot. Pull from On-hand and Allocated.
    ?C     LotKey        Chain     FDLOTALOC
     C                   If        %Found(FDLOTALOC)
     C                   Eval      LDQTOH = LDQTOH - 1                          ?QTY O/H
     C                   Eval      LDQTAL = LDQTAL - 1                          ?QTY ALLOCATED
     C                   If        TRSTAT = 'F' or TRSTAT = 'P'
     C                   Eval      LDQFIX = LDQFIX + 1                          ?Fixers/Partials
     C                   Else
     C                   Eval      LDQDMP = LDQDMP + 1                          ?Dumped/Damaged
     C                   EndIf
    ?C                   Update    RDLOT
     C                   EndIf
      *?   Subtract one from the LotRD. Pull from On-hand and Allocated.
    ?C     LotKeyRD      Chain     FDLOTRDCLT
     C                   If        %Found(FDLOTRDCLT)
     C                   Eval      LRQTOH = LRQTOH - 1                          ?QTY O/H
     C                   Eval      LRQTAL = LRQTAL - 1                          ?QTY ALOC
WJB   *?      ... change: Do Not Delete Records, always just update record.
WJB  C*                  If        LRQTAL > 0 or
WJB  C*                            LRQTOH > 0
    ?C                   Update    RDLOTRD
WJB  C*                  Else
WJB ?C*                  Delete    RDLOTRD
WJB  C*                  EndIf
     C                   EndIf

     C                   EndSr


     ?*   ................................................
     ?*   :      SubtInven - Subtract Inventory          :
     ?*   :..............................................:

     C     SubtInven     BegSr

      *?   Subtract one from the Lot. Pull from On-hand and Available.
    ?C     LotKey        Chain     FDLOTALOC
     C                   If        %Found(FDLOTALOC)
     C                   Eval      LDQTOH = LDQTOH - 1                          ?QTY O/H
WJB  C                   Eval      LDQTAV = LDQTAV - 1                          ?QTY Available
     C                   If        TRSTAT = 'F' or TRSTAT = 'P'
     C                   Eval      LDQFIX = LDQFIX + 1                          ?Fixers/Partials
     C                   Else
     C                   Eval      LDQDMP = LDQDMP + 1                          ?Dumped/Damaged
     C                   EndIf
    ?C                   Update    RDLOT
     C                   EndIf
      *?   Subtract one from the LotRD. Pull from On-hand and Available.
    ?C     LotKeyRD      SetGT     FDLOTRDCLT
    ?C     LotKey        ReadPE    FDLOTRDCLT
     C                   DoW       not %EOF(FDLOTRDCLT) and
     C                             LRQTOH - LRQTAL <= 0
    ?C     LotKey        ReadPE    FDLOTRDCLT
     C                   EndDo
     C                   If        not %EOF(FDLOTRDCLT)
     C                   Eval      LRQTOH = LRQTOH - 1                          ?QTY O/H
     C                   Eval      LRQTAV = LRQTOH- LRQTAL                      ?QTY AVAILABLE
    ?C                   Update    RDLOTRD
     C                   Else
      *?   Write a 999990 record to Balance LOT Files
    ?C     Key999990     Chain     FDLOTRDCLT
     C                   If        %Found(FDLOTRDCLT)
     C                   Eval      LRQTOH = LRQTOH - 1
     C                   Eval      LRQTAV = LRQTAV - 1
    ?C                   Update    RDLOTRD
     C                   Else
     C                   Eval      IMDES1 = 'Item Missing from Master'
    ?C     ItemKey       Chain     FMINVT
     C                   Eval      LRSTAT = 'A'                                 STATUS A/D/C
     C                   Eval      LRITEM = TRITEM                              ITEM #
     C                   Eval      LRSIZE = TRSIZE                              SIZE CODE
     C                   Eval      LRWHSE = *Blanks                             LOCATION
     C                   Eval      LRSOWD = TRSCYM                              SOW DATE CYMD
     C                   Eval      LRGLOC = *Blanks                             GROW LOC. ORIG
     C                   Eval      LRPHYT = *Blanks                             PHYTO CODE
     C                   Eval      LRCRDY = TRCRDT                              CURR. READY DATE
     C                   Eval      LRCPHY = *Blanks                             CURR PHYTO CODE
     C                   Eval      LRCLOC = ' '                                 LOC. CURR
     C                   Eval      LRCODE = 'A'                                 CODE A/H/R/S/T
     C                   Eval      LRCUST = 999990                              RESERV. CUST #
     C                   Eval      LRAREA = *Blanks                             AREA
     C                   Eval      LRCOMP = 1                                   COMPANY NO
     C                   Eval      LRQTOH = -1                                  QTY O/H
     C                   Eval      LRDTLA = $MDYDate($Date(0))                  LAST ACTIVITY
     C                   Eval      LRTIME = $Now()                              TIME
     C                   Eval      LRUSER = $User()                             USER
     C                   Eval      LRALPH = TRALPH                              ALPHA SEARCH
     C                   Eval      LRPRCL = TRPRDC                              PRODUCT CLASS
     C                   Eval      LRQTAL = *Zero                               QTY ALOC
     C                   Eval      LRDESC = IMDES1                              DESCRIPTION
     C                   Eval      LRQTCM = *Zero                               QTY COMIT
     C                   Eval      LRQTSL = *Zero                               QTY SOLD
     C                   Eval      LRQADJ = *Zero                               QTY ADJ
     C                   Eval      LRQTAV = -1                                  QTY AVAIL
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
?    C*                  Eval      StartTag#  =  1379871
    C*                  Eval      EndTag#    =  9999999

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
    ?C                   KFld                    FixerOrder                     ?Order Number 999999
    ?C                   KFld                    FixerSeq#                      ?Order SEQ#      000
    ?C                   KFld                    TRITEM                         ?Item
    ?C                   KFld                    TRSIZE                         ?Size
    ?C                   KFld                    TRSCYM                         ?Sow Date
    ?C                   KFld                    DftWHSE                        ?Warehouse
    ?C                   KFld                    FixerCust                      ?Customer     999999
    ?C                   KFld                    TRCRDT                         ?Ready Date
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
    ?C                   KFld                    FixerCUST                      ?Customer
    ?C     Key999990     KList
    ?C                   KFld                    TRITEM                         ?Item
    ?C                   KFld                    TRSIZE                         ?Size
    ?C                   KFld                    DftWHSE                        ?Default Location
    ?C                   KFld                    TRSCYM                         ?Sow Date
    ?C                   KFld                    TRCRDT                         ?Ready Date
    ?C                   KFld                    Cust999990                     ?Customer

     C                   EndSr
