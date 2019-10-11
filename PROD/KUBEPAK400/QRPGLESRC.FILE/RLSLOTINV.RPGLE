    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *?                                                              ?
      *??|                                                            |?
      *??|            Release Lot Inventory (RLSLOTINV)               |?
      *?|                                                            |?

      *? :````````````````````````````````````````````````````````````:
      *? : Created:  February, 2006       ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :  Program Description?                                    ?:
      *? : This program takes allocated fixers from customer 999999   :
      *? : records and places it back on the Customer Zero record as ?:
      *? : available.                                                ?:
      *? :............................................................:
      *?                                                              ?
      *? |?  Subroutine Usage                                        ?|
      *? |                                                           ?|
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

     FFDLOTRDFIXUF   E           K DISK    Prefix(fix_)                         ?Records to Release
     F                                     Rename(RDLOTRD:Available)
     FFDLOTRDCLTUF A E           K DISK                                         ?Cust. *Zero Records
     FFDLOTALOC UF   E           K DISK                                         ?Lot Record
     FFLOSSDLOT IF   E           K DISK                                         ?Loss Details
     FFALITEMLOTUF   E           K DISK                                         ?Order Allocations

      *? Function Prototypes
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Now

      *? Field Definitions
    ?D Days2Wait       S              2S 0 Inz(0)                               ?Wait 3 days b4 rel.
    ?D Qty2Move        S             11s 1
    ?D DftWHSE         S                   Like(LRWHSE) Inz(*Blanks)
    ?D ZeroCUST        S              6s 0 Inz(*Zero)
    ?D FIXR_ORD#       S              6s 0 Inz(999999)
    ?D FIXR_CUST       S              6s 0 Inz(999999)

     ?*   ................................................
     ?*   :   Main Calcs                                 :
     ?*   :..............................................:

      *?   Process all Fixer Inventory
    ?C     *LoVal        SetLL     FDLOTRDFIX
    ?C                   Read      FDLOTRDFIX
    ?C     LotKey        Chain     FDLOTALOC

     C                   If        %EOF(FDLOTRDFIX)
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf

    ?C                   DoW       not %EOF(FDLOTRDFIX)

      *?   Only process if lot has been fixed
     C                   If        LDFIXD = 'Y' and %Found(FDLOTALOC)
      *?   Wait the specified number of days before releasing.
    ?C     LossKey       Chain     FLOSSDLOT
     C                   If        not %Found(FLOSSDLOT) or
     C                             (%Found(FLOSSDLOT) and
     C                             $AddDate($Date(0):-Days2Wait)>$Date(LDLOSD))
     C                   ExSr      Release
     C                   EndIf
     C                   EndIf

    ?C                   Read      FDLOTRDFIX
    ?C     LotKey        Chain     FDLOTALOC
    ?C                   EndDo

     C                   Eval      *InLr = *On


     ?*   ................................................
     ?*   :      Release - Release Inventory             :
     ?*   :..............................................:

     C     Release       BegSr

     C                   Eval      Qty2Move   = fix_LRQTAL
      *?   Subtract Fixing Allocation from Allocated and add to Available on Lot Record
     C                   Eval      LDQTAV     = LDQTAV     + Qty2Move           ?QTY AVAILABLE
     C                   Eval      LDQTAL     = LDQTAL     - Qty2Move           ?QTY ALOC
    ?C                   Update    RDLOT
      *?   Subtract Allocated Quantity from 999999 Customer Record
     C                   Eval      fix_LRQTOH = fix_LRQTOH - Qty2Move           ?QTY O/H
     C                   Eval      fix_LRQTAL = fix_LRQTAL - Qty2Move           ?QTY ALOC
      *?   Check to see if a Customer *ZERO record exists for Lot.
    ?C     ZeroKey       Chain     FDLOTRDCLT
      *?   If Customer *ZERO record exists... then Add to Cust. *Zero record
     C                   If        %Found(FDLOTRDCLT)
     C                   Eval      LRQTOH     = LRQTOH     + Qty2Move           ?QTY O/H
     C                   Eval      LRQTAV     = LRQTAV     + Qty2Move           ?QTY AVAIL
    ?C                   Update    RDLOTRD
      *?   If no Customer *ZERO record exists... then Write the Customer *Zero Record
     C                   Else
     C                   Eval      LRSTAT = fix_LRSTAT                          ?STATUS A/D/C
     C                   Eval      LRITEM = fix_LRITEM                          ?ITEM #
     C                   Eval      LRSIZE = fix_LRSIZE                          ?SIZE CODE
     C                   Eval      LRWHSE = fix_LRWHSE                          ?LOCATION
     C                   Eval      LRSOWD = fix_LRSOWD                          ?SOW DATE CYMD
     C                   Eval      LRGLOC = fix_LRGLOC                          ?GROW LOC. ORIG
     C                   Eval      LRPHYT = fix_LRPHYT                          ?PHYTO CODE
     C                   Eval      LRCRDY = fix_LRCRDY                          ?CURR. READY DATE
     C                   Eval      LRCPHY = fix_LRCPHY                          ?CURR PHYTO CODE
     C                   Eval      LRCLOC = fix_LRCLOC                          ?LOC. CURR
     C                   Eval      LRCODE = fix_LRCODE                          ?CODE A/H/R/S/T
     C                   Eval      LRCUST = *Zero                               ?RESERV. CUST #
     C                   Eval      LRAREA = fix_LRAREA                          ?AREA
     C                   Eval      LRCOMP = fix_LRCOMP                          ?COMPANY NO
     C                   Eval      LRQTOH = Qty2Move                            ?QTY O/H
     C                   Eval      LRDTLA = $MDYDate($Date(0))                  ?LAST ACTIVITY DATE
     C                   Eval      LRTIME = $now()                              ?TIME
     C                   Eval      LRUSER = 'RLSLOTINV'                         ?USER
     C                   Eval      LRALPH = fix_LRALPH                          ?ALPHA SEARCH
     C                   Eval      LRPRCL = fix_LRPRCL                          ?PRODUCT CLASS
     C                   Eval      LRQTAL = *Zero                               ?QTY ALOC
     C                   Eval      LRDESC = fix_LRDESC                          ?DESCRIPTION
     C                   Eval      LRQTCM = *Zero                               ?QTY COMIT
     C                   Eval      LRQTSL = *Zero                               ?QTY SOLD
     C                   Eval      LRQADJ = *Zero                               ?QTY ADJ
     C                   Eval      LRQTAV = Qty2Move                            ?QTY AVAIL
    ?C                   Write     RDLOTRD
     C                   EndIf
      *?   If Fixer Customer record has nothing left on it then delete it.
     C                   If        fix_LRQTOH = *Zero and
     C                             fix_LRQTAL = *Zero and
     C                             fix_LRQTCM = *Zero and
     C                             fix_LRQTSL = *Zero and
     C                             fix_LRQADJ = *Zero and
     C                             fix_LRQTAV = *Zero
WJB   *?      ... no, WAIT...  Don't Delete it..  let it be Zero!                 10/10/2012
WJB ?C*                  Delete    Available                                      10/10/2012
WJB ?C                   Update    Available                                      10/10/2012
     C                   Else
    ?C                   Update    Available
     C                   EndIf

    ?C     FixRKey       Chain     FALITEMLOT
     C                   If        %Found(FALITEMLOT)
    ?C                   Delete    RALITEM
     C                   EndIf

     C                   EndSr

     ?*   ................................................
     ?*   :      *InzSr - Initialization Subroutine      :
     ?*   :..............................................:

     C     *InzSr        BegSr
     *
?    C*    *Entry        PList
?    C*                  Parm                    prm_LRITEM                     Item
?    C*                  Parm                    prm_LRSIZE                     Size
?    C*                  Parm                    prm_LRSOWD                     Sow Date
    C*                  Parm                    prm_LRCRDY                     Ready Date

    ?C     ZeroKey       KList
    ?C                   KFld                    fix_LRITEM                     ?Item
    ?C                   KFld                    fix_LRSIZE                     ?Size
    ?C                   KFld                    DftWHSE                        ?Default Location
    ?C                   KFld                    fix_LRSOWD                     ?Sow Date
    ?C                   KFld                    fix_LRCRDY                     ?Ready Date
    ?C                   KFld                    ZeroCUST                       ?Customer Zero

    ?C     FixRKey       KList
    ?C                   KFld                    fix_LRITEM                     ?Item
    ?C                   KFld                    fix_LRSIZE                     ?Size
    ?C                   KFld                    DftWHSE                        ?Default Location
    ?C                   KFld                    fix_LRSOWD                     ?Sow Date
    ?C                   KFld                    fix_LRCRDY                     ?Ready Date
    ?C                   KFld                    FIXR_ORD#                      ?Order# 999999
    ?C                   KFld                    FIXR_CUST                      ?Customer 999999

    ?C     LossKey       KList
    ?C                   KFld                    fix_LRITEM                     ?Item
    ?C                   KFld                    fix_LRSIZE                     ?Size
    ?C                   KFld                    fix_LRSOWD                     ?Sow Date
    ?C                   KFld                    fix_LRCRDY                     ?Ready Date

    ?C     LotKey        KList
    ?C                   KFld                    fix_LRITEM                     ?Item
    ?C                   KFld                    fix_LRSIZE                     ?Size
    ?C                   KFld                    DftWHSE                        ?Default Location
    ?C                   KFld                    fix_LRSOWD                     ?Sow Date
    ?C                   KFld                    fix_LRCRDY                     ?Ready Date

     C                   EndSr
