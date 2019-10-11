    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *?                                                              ?
      *??|                                                            |?
      *??|            Partial Lot Inventory (PRTLOTINV)               |?
      *?|                                                            |?

      *? :````````````````````````````````````````````````````````````:
      *? : Created:  August, 2012         ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :  Program Description?                                    ?:
      *? : This program will be called when a tray is made into a     :
      *? : Partial or back into a full tray from a Partial.          ?:
      *? :   This program allocates or de-allocates each             ?:
      *? : tray from an order on the FALITEM file and updates the    ?:
      *? : lot inventory on FDLOT & FDLOTRD.                         ?:
      *? :............................................................:
      *?                                                              ?
      *? |?  Edit Log                                                ?|
      *? |                                                           ?|
      *? |WJB07/27/12?-Initial Programming                        ?|
      *? |   mm/dd/yy?-                                           ?|
      *?|                                                            |?

     FFTRAY     UF   E           K DISK
     FFIORDRL5  UF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFDLOT     UF   E           K DISK
     FFDLOTRDCLTUF A E           K DISK
     FFDLOTRDCLAUF A E           K DISK    Rename(RDLOTRD:RDLOTRDCLA)
     FFALITEML2 UF A E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Now

      *? Field Definitions
    ?D TrayTag#        S                   Like(TRTAG#)
    ?D Allocated       S                   Like(LRQTAL)
    ?D Allocated997    S               N

    ?D FixerOrder      S              6S 0 Inz(999999)
    ?D FixerSeq#       S              3S 0 Inz(0)

    ?D CUST000         S                   Like(OHCUST) Inz(000000)
    ?D CUST990         S                   Like(OHCUST) Inz(999990)
    ?D CUST997         S                   Like(OHCUST) Inz(999997)
    ?D CUST998         S                   Like(OHCUST) Inz(999998)
    ?D CUST999         S                   Like(OHCUST) Inz(999999)

    ?D DftWHSE         S                   Like(LRWHSE) Inz(*Blanks)
    ?D Type            S             10A
    ?D TrayTag@        S              8A

    ?D LOT990          S               N   Inz(*Off)

    ?D StartTag#       S              8S 0
    ?D EndTag#         S              8S 0

    ?D SaveTRSTAT      S                   Like(TRSTAT)

     ?*   ................................................
     ?*   :   Main Calcs                                 :
     ?*   :..............................................:

      *?   Process the given Tag
    ?C     TrayTag#      Chain     FTRAY
     C                   If        not %Found(FTRAY) or
     C                             (TRCNTD <> 'P' and TRSTAT <> 'P') or
     C                             (TRCNTD =  'P' and TRSTAT =  'P')
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf

     C                   Select
     ?* A to P   Active  ==>  Partial
    ?C                   When      (TRSTAT = 'P' and TRCNTD = 'Y')
     C                   ExSr      A_to_P
     ?* D to P   Deleted ==>  Partial
    ?C                   When      (TRSTAT = 'P')
     C                   ExSr      D_to_P
     ?* P to A   Partial ==>  Active
    ?C                   When      (TRCNTD = 'P' and TRSTAT = 'A')
     C                   ExSr      P_to_A
     ?* P to D   Partial ==>  Deleted
    ?C                   When      (TRCNTD = 'P')
     C                   ExSr      P_to_D

     C                   ENDSL

    ?C                   Update    RTRAY

     C                   Eval      *InLr = *On

     ?*----------------------------------------------------------------------------------*
     ?*   :``````````````````````````````````````````````````````````````````````````:   *
     ?*   :    S U B R O U T I N E S                                                 :   *
     ?*   :..........................................................................;   *
     ?*----------------------------------------------------------------------------------*


     ?*   ................................................
     ?*   :      D_to_P   - Make a good Tray             :
     ?*   :..............................................:

     C     D_to_P        BegSr
      *                  Fake a full tray for ADDLOTINV
     C                   Eval      SaveTRSTAT = TRSTAT
     C                   Eval      TRSTAT = 'A'
     C                   Update    RTRAY
     C                   Call      'ADDLOTINV'
     C                   Parm      TrayTag#      StartTag#
     C                   Parm      TrayTag#      EndTag#
     C     TrayTag#      Chain     FTRAY
     C                   Eval      TRSTAT = SaveTRSTAT

     C                   ExSr      A_to_P

     C                   Eval      TRCNTD = 'P'

     C                   EndSr


     ?*   ................................................
     ?*   :      A_to_P - Make this a Partial Flat       :
     ?*   :..............................................:

     C     A_to_P        BegSr

     C                   Eval      LOT990 = *Off
      *?   See if there is unalocated inventory on the FDLOTRD file
      *?   1. First Check Fixers for On-hand
    ?C     Lot999Key     Chain     FDLOTRDCLA
     C                   If        %Found(FDLOTRDCLA) and LRQTOH > 0
     C                   Eval      LRQTOH = LRQTOH - 1
wjb  C                   Eval      LRQTAL = LRQTAL - 1
     C                   Eval      LRDTLA = $MDYDate($Date(0))                  ?LAST ACTIVITY
     C                   Eval      LRTIME = $Now()                              ?TIME
     C                   Eval      LRUSER = $User()                             ?USER
     C                   Eval      LRUSER = 'PRTLOTINV4'                        ?USER
    ?C                   Update    RDLOTRDCLA
    ?C                   ExSr      ReduceAlloc
    ?C                   ExSr      AddPartial
     C                   Else
      *?   2. Then Check Overruns for On-hand
    ?C     Lot998Key     Chain     FDLOTRDCLA
     C                   If        %Found(FDLOTRDCLA) and LRQTOH > 0
     C                   Eval      LRQTOH = LRQTOH - 1
     C                   Eval      LRDTLA = $MDYDate($Date(0))                  ?LAST ACTIVITY
     C                   Eval      LRTIME = $Now()                              ?TIME
     C                   Eval      LRUSER = $User()                             ?USER
     C                   Eval      LRUSER = 'PRTLOTINV5'                        ?USER
    ?C                   Update    RDLOTRDCLA
    ?C                   ExSr      ReduceAlloc
    ?C                   ExSr      AddPartial
     C                   Else
      *?   3. If no Fixers/Overruns Check *Zero Record for Avail
    ?C     Lot000Key     Chain     FDLOTRDCLA
     C                   If        %Found(FDLOTRDCLA) and LRQTAV > 0
     C                   Eval      LRQTOH = LRQTOH - 1
     C                   Eval      LRQTAV = LRQTAV - 1
     C                   Eval      LRDTLA = $MDYDate($Date(0))                  ?LAST ACTIVITY
     C                   Eval      LRTIME = $Now()                              ?TIME
     C                   Eval      LRUSER = $User()                             ?USER
     C                   Eval      LRUSER = 'PRTLOTINV6'                         ?USER
    ?C                   Update    RDLOTRDCLA
    ?C                   ExSr      AddPartial
     C                   Else
      *?   4. Still none Available check Customer Records for Avail
    ?C     Lot000Key     SetGT     FDLOTRDCLA
    ?C     LotRDKey      ReadE     FDLOTRDCLA
     C                   DoW       Not %EOF(FDLOTRDCLA) and LRCUST < 999900
     C                   If        LRQTAV > 0
     C                   Eval      LRQTOH = LRQTOH - 1
     C                   Eval      LRQTAV = LRQTAV - 1
     C                   Eval      LRDTLA = $MDYDate($Date(0))                  ?LAST ACTIVITY
     C                   Eval      LRTIME = $Now()                              ?TIME
     C                   Eval      LRUSER = $User()                             ?USER
     C                   Eval      LRUSER = 'PRTLOTINV7'                        ?USER
    ?C                   Update    RDLOTRDCLA
    ?C                   ExSr      AddPartial
     C                   LeaveSR
     C                   EndIf
    ?C     LotRDKey      ReadE     FDLOTRDCLA
     C                   EndDo
      *?   5. No Availability anywhere, Take from 999990
     C                   Eval      LOT990 = *On
    ?C     Lot990Key     Chain     FDLOTRDCLT
    ?C*                  KFld                    TRITEM                         ?Item
    ?C*                  KFld                    TRSIZE                         ?Size
    ?C*                  KFld                    DftWHSE                        ?Default Location
    ?C*                  KFld                    TRSCYM                         ?Sow Date
    ?C*                  KFld                    TRCRDT                         ?Ready Date
    ?C*                  KFld                    CUST990                        ?Customer 999990
     C                   If        %Found(FDLOTRDCLT)
     C                   Eval      LRQTOH = LRQTOH - 1
     C                   Eval      LRQTAV = LRQTAV - 1
     C                   Eval      LRDTLA = $MDYDate($Date(0))                  ?LAST ACTIVITY
     C                   Eval      LRTIME = $Now()                              ?TIME
     C                   Eval      LRUSER = $User()                             ?USER
     C                   Eval      LRUSER = 'PRTLOTINV8'                        ?USER
    ?C                   Update    RDLOTRD
     C                   Else
    ?C                   Clear                   RMINVT
    ?C     ItemKey       Chain     FMINVT
     C                   Eval      LRSTAT = 'A'                                 ?STATUS A/D/C
     C                   Eval      LRITEM = TRITEM                              ?ITEM #
     C                   Eval      LRSIZE = TRSIZE                              ?SIZE CODE
     C                   Eval      LRWHSE = *Blanks                             ?LOCATION
     C                   Eval      LRSOWD = TRSCYM                              ?SOW DATE CYMD
     C                   Eval      LRGLOC = ' '                                 ?GROW LOC. ORIG
     C                   Eval      LRPHYT = *Blank                              ?PHYTO CODE
     C                   Eval      LRCRDY = TRCRDT                              ?CURR. READY DATE
     C                   Eval      LRCPHY = *Blanks                             ?CURR PHYTO CODE
     C                   Eval      LRCLOC = *Blanks                             ?LOC. CURR
     C                   Eval      LRCODE = 'A'                                 ?CODE A/H/R/S/T
     C                   Eval      LRCUST = 999990                              ?RESERV. CUST #
     C                   Eval      LRAREA = *Blanks                             ?AREA
     C                   Eval      LRCOMP = 1                                   ?COMPANY NO
     C                   Eval      LRQTOH = -1                                  ?QTY O/H
     C                   Eval      LRDTLA = $MDYDate($Date(0))                  ?LAST ACTIVITY
     C                   Eval      LRTIME = $Now()                              ?TIME
     C                   Eval      LRUSER = $User()                             ?USER
     C                   Eval      LRUSER = 'PRTLOTINV9'                        ?USER
     C                   Eval      LRALPH = IMLOOK                              ?ALPHA SEARCH
     C                   Eval      LRPRCL = IMPCL1                              ?PRODUCT CLASS
     C                   Eval      LRQTAL = *Zero                               ?QTY ALOC
     C                   Eval      LRDESC = IMDES1                              ?DESCRIPTION
     C                   Eval      LRQTCM = *Zero                               ?QTY COMIT
     C                   Eval      LRQTSL = *Zero                               ?QTY SOLD
     C                   Eval      LRQADJ = *Zero                               ?QTY ADJ
     C                   Eval      LRQTAV = -1                                  ?QTY AVAIL
    ?C                   Write     RDLOTRD
     C                   EndIf
    ?C                   ExSr      AddPartial
     C                   EndIf
     C                   EndIf
     C                   EndIf

     C                   Eval      TRCNTD = 'P'

     C                   EndSr


     ?*   ................................................
     ?*   :      P_to_A  - Make Lot from a Partial Flat  :
     ?*   :..............................................:

     C     P_to_A        BegSr

    ?C     Lot997Key     Chain     FDLOTRDCLT
     C                   If        not %Found(FDLOTRDCLT)
      *?                 Do Absolutely Nothing

     C                   Else

     C                   Eval      LRQTOH -= 1
     C                   Eval      LRQTAV -= 1
     C                   Eval      Allocated997 = *Off
     C                   If        LRQTAL <> *Zero
     C                   Eval      Allocated997 = *On
     C                   EndIf
    ?C                   Update    RDLOTRD                                      Update997
    ?C                   Clear                   RMINVT
    ?C     ItemKey       Chain     FMINVT
      *?
    ?C     Lot990Key     Chain     FDLOTRDCLT                                   Chain990
    ?C*                  KFld                    TRITEM                         ?Item
    ?C*                  KFld                    TRSIZE                         ?Size
    ?C*                  KFld                    DftWHSE                        ?Default Location
    ?C*                  KFld                    TRSCYM                         ?Sow Date
    ?C*                  KFld                    TRCRDT                         ?Ready Date
    ?C*                  KFld                    CUST990                        ?Customer 999990
     C                   If        %Found(FDLOTRDCLT) and LRQTOH < 0
     C                   Eval      LRQTOH += 1
     C                   Eval      LRQTAV += 1
    ?C                   Update    RDLOTRD                                      Update990
     C                   Else
     C                   If        Allocated997 = *On
      *?                 If the 997 Record is allocated, write a 990 record
     C                   Eval      LRSTAT = 'A'                                 ?STATUS A/D/C
     C                   Eval      LRITEM = TRITEM                              ?ITEM #
     C                   Eval      LRSIZE = TRSIZE                              ?SIZE CODE
     C                   Eval      LRWHSE = *Blanks                             ?LOCATION
     C                   Eval      LRSOWD = TRSCYM                              ?SOW DATE CYMD
     C                   Eval      LRGLOC = ' '                                 ?GROW LOC. ORIG
     C                   Eval      LRPHYT = *Blank                              ?PHYTO CODE
     C                   Eval      LRCRDY = TRCRDT                              ?CURR. READY DATE
     C                   Eval      LRCPHY = *Blanks                             ?CURR PHYTO CODE
     C                   Eval      LRCLOC = *Blanks                             ?LOC. CURR
     C                   Eval      LRCODE = 'A'                                 ?CODE A/H/R/S/T
     C                   Eval      LRCUST = 999990                              ?RESERV. CUST #
     C                   Eval      LRAREA = *Blanks                             ?AREA
     C                   Eval      LRCOMP = 1                                   ?COMPANY NO
     C                   Eval      LRQTOH = 1                                   ?QTY O/H
     C                   Eval      LRDTLA = $MDYDate($Date(0))                  ?LAST ACTIVITY
     C                   Eval      LRTIME = $Now()                              ?TIME
     C                   Eval      LRUSER = $User()                             ?USER
     C                   Eval      LRUSER = 'PRTLOTINV3'                        ?USER
     C                   Eval      LRALPH = IMLOOK                              ?ALPHA SEARCH
     C                   Eval      LRPRCL = IMPCL1                              ?PRODUCT CLASS
     C                   Eval      LRQTAL = Allocated                           ?QTY ALOC
     C                   Eval      LRDESC = IMDES1                              ?DESCRIPTION
     C                   Eval      LRQTCM = *Zero                               ?QTY COMIT
     C                   Eval      LRQTSL = *Zero                               ?QTY SOLD
     C                   Eval      LRQADJ = *Zero                               ?QTY ADJ
     C                   Eval      LRQTAV = 1                                   ?QTY AVAIL
    ?C                   Write     RDLOTRD                                       Write990
     C                   Else
      *?            Else if the 997 Record is not allocated, write/update a Cust: 000 record
    ?C     Lot000Key     Chain     FDLOTRDCLT                                    Chain000
     C                   If        %Found(FDLOTRDCLT)
     C                   Eval      LRQTOH = LRQTOH + 1
     C                   Eval      LRQTAL = LRQTAL + Allocated
     C                   Eval      LRQTAV = LRQTOH - LRQTAL
     C                   Eval      LRDTLA = $MDYDate($Date(0))                  ?LAST ACTIVITY
     C                   Eval      LRTIME = $Now()                              ?TIME
     C                   Eval      LRUSER = $User()                             ?USER
     C                   Eval      LRUSER = 'PRTLOTINV2'                        ?USER
    ?C                   Update    RDLOTRD                                       Update000
     C                   Else
     C                   Eval      LRSTAT = 'A'                                 ?STATUS A/D/C
     C                   Eval      LRITEM = TRITEM                              ?ITEM #
     C                   Eval      LRSIZE = TRSIZE                              ?SIZE CODE
     C                   Eval      LRWHSE = *Blanks                             ?LOCATION
     C                   Eval      LRSOWD = TRSCYM                              ?SOW DATE CYMD
     C                   Eval      LRGLOC = ' '                                 ?GROW LOC. ORIG
     C                   Eval      LRPHYT = *Blank                              ?PHYTO CODE
     C                   Eval      LRCRDY = TRCRDT                              ?CURR. READY DATE
     C                   Eval      LRCPHY = *Blanks                             ?CURR PHYTO CODE
     C                   Eval      LRCLOC = *Blanks                             ?LOC. CURR
     C                   Eval      LRCODE = 'A'                                 ?CODE A/H/R/S/T
     C                   Eval      LRCUST = *Zero                               ?RESERV. CUST #
     C                   Eval      LRAREA = *Blanks                             ?AREA
     C                   Eval      LRCOMP = 1                                   ?COMPANY NO
     C                   Eval      LRQTOH = 1                                   ?QTY O/H
     C                   Eval      LRDTLA = $MDYDate($Date(0))                  ?LAST ACTIVITY
     C                   Eval      LRTIME = $Now()                              ?TIME
     C                   Eval      LRUSER = $User()                             ?USER
     C                   Eval      LRUSER = 'PRTLOTINV3'                        ?USER
     C                   Eval      LRALPH = IMLOOK                              ?ALPHA SEARCH
     C                   Eval      LRPRCL = IMPCL1                              ?PRODUCT CLASS
     C                   Eval      LRQTAL = Allocated                           ?QTY ALOC
     C                   Eval      LRDESC = IMDES1                              ?DESCRIPTION
     C                   Eval      LRQTCM = *Zero                               ?QTY COMIT
     C                   Eval      LRQTSL = *Zero                               ?QTY SOLD
     C                   Eval      LRQADJ = *Zero                               ?QTY ADJ
     C                   Eval      LRQTAV = LRQTOH - Allocated                  ?QTY AVAIL
    ?C                   Write     RDLOTRD                                       Write000
     C                   EndIf

     C                   EndIf
     C                   EndIf
     C                   EndIf

     C                   Eval      TRCNTD = 'Y'

     C                   EndSr


     ?*   ................................................
     ?*   :      AddPartial - Write Partial Record + 1   :
     ?*   :..............................................:

     C     AddPartial    BegSr

    ?C     Lot997Key     Chain     FDLOTRDCLT
     C                   Eval      LRQTOH = LRQTOH + 1
     C                   Eval      LRQTAV = LRQTAV + 1
     C                   Eval      LRCUST = 999997
     C                   Eval      LRDTLA = $MDYDate($Date(0))
     C                   Eval      LRTIME = $Now()
     C                   Eval      LRUSER = $User()
     C                   Eval      LRUSER = 'PRTLOTINVa'                         ?USER
     C*                  If        LOT990
     C*                  Eval      LRGLOC = '997'
     C*                  Else
     C*                  Eval      LRGLOC = '   '
     C*                  EndIf
     C                   If        %Found(FDLOTRDCLT)
    ?C                   Update    RDLOTRD
     C                   Else
     C                   Eval      LRSTAT = 'A'
     C                   Eval      LRQTOH = 1
     C                   Eval      LRQTAV = 1
     C                   Eval      LRQTAL = *Zero
    ?C                   Write     RDLOTRD
     C                   EndIf

     C                   EndSr


     ?*   ................................................
     ?*   :      ReduceAlloc - Reduce FALITEM allocation :
     ?*   :..............................................:

     C     ReduceAlloc   BegSr

     C                   Eval      AIORD# = LRCUST                               999999 or 999998
     C                   Eval      AIOSEQ = *Zero                                Always *Zero
    ?C     FALITEMKey    Chain     FALITEML2
     C                   If        %Found(FALITEML2) and AIQTOA > 0
     C                   Eval      AIQTOA = AIQTOA - 1
     C                   Eval      AIDTLA = $MDYDate($Date(0))
     C                   Eval      AITIME = $Now()
     C                   Eval      AIUSER = 'PRTLOTINVb'
    ?C                   Update    RALITEM
     C                   EndIf

    ?C     LotKey        Chain     FDLOT
     C                   If        %Found(FDLOT)
     C                   Eval      LDQTAL -= 1
     C                   Eval      LDQTAV += 1
     C                   Update    RDLOT
     C                   EndIf
     C                   EndSr

     ?*   ................................................
     ?*   :      DeltTray - Delete a Tray                :
     ?*   :..............................................:

     C     DeltTray      BegSr
      *                    Fake a full loss tray for RMVLOTINV
     C                   Eval      SaveTRSTAT = TRSTAT
     C                   Eval      TRSTAT = 'X'
     C                   Eval      TRCNTD = 'Y'
     C                   Update    RTRAY
     C                   Call      'RMVLOTINV'
     C                   Parm      TrayTag#      StartTag#
     C                   Parm      TrayTag#      EndTag#
     C     TrayTag#      Chain     FTRAY
     C                   Eval      TRSTAT = SaveTRSTAT
     C                   EndSr



     ?*   ................................................
     ?*   :      P_to_D     - Write Partial Record - 1   :
     ?*   :..............................................:

     C     P_to_D        BegSr

    ?C     Lot997Key     Chain     FDLOTRDCLT
     C                   If        %Found(FDLOTRDCLT)
     C                   Eval      LRQTOH = LRQTOH - 1
     C                   Eval      LRQTAV = LRQTAV - 1
     C                   Eval      LRDTLA = $MDYDate($Date(0))                  ?LAST ACTIVITY
     C                   Eval      LRTIME = $Now()                              ?TIME
     C                   Eval      LRUSER = $User()                             ?USER
     C                   Eval      LRUSER = 'PRTLOTINVc'                        ?USER
    ?C                   Update    RDLOTRD
     C                   EndIf

    ?C     LotKey        Chain     FDLOT
     C                   If        %Found(FDLOT)
     C                   Eval      LDQTOH -= 1
     C                   Eval      LDQTAV -= 1
     C                   Update    RDLOT
     C                   EndIf

     C                   Eval      TRCNTD = 'N'

     C                   EndSr


     ?*   ................................................
     ?*   :      *InzSr - Initialization Subroutine      :
     ?*   :..............................................:

     C     *InzSr        BegSr

    ?C     *Entry        PList
    ?C                   Parm                    TrayTag#

    ?C     AllocKey      KList
    ?C                   KFld                    FixerOrder                     ?Order Number 999999
    ?C                   KFld                    FixerSeq#                      ?Order SEQ#      000
    ?C                   KFld                    TRITEM                         ?Item
    ?C                   KFld                    TRSIZE                         ?Size
    ?C                   KFld                    TRSCYM                         ?Sow Date
    ?C                   KFld                    DftWHSE                        ?Warehouse
    ?C                   KFld                    CUST999                        ?Customer     999999
    ?C                   KFld                    TRCRDT                         ?Ready Date
    ?C     FALITEMKey    KList
    ?C                   KFld                    AIORD#                          999999 or 999998
    ?C                   KFld                    AIOSEQ                          Always *Zero
    ?C                   KFld                    LRITEM                          ITEM
    ?C                   KFld                    LRSIZE                          SIZE
    ?C                   KFld                    LRSOWD                          SOW Date
    ?C                   KFld                    LRGLOC                          *Always Blank
    ?C                   KFld                    LRCUST                          999999 or 999998
    ?C                   KFld                    LRCRDY                          Current Ready Date
    ?C     ItemKey       KList
    ?C                   KFld                    TRITEM
    ?C                   KFld                    TRSIZE
    ?C     ItemLot       KList
    ?C                   KFld                    TRITEM
    ?C                   KFld                    TRSIZE
    ?C                   KFld                    TRCRDT
    ?C     Lot000Key     KList
    ?C                   KFld                    TRITEM                         ?Item
    ?C                   KFld                    TRSIZE                         ?Size
    ?C                   KFld                    DftWHSE                        ?Default Location
    ?C                   KFld                    TRSCYM                         ?Sow Date
    ?C                   KFld                    TRCRDT                         ?Ready Date
    ?C                   KFld                    CUST000                        ?Customer 000000
    ?C     Lot990Key     KList
    ?C                   KFld                    TRITEM                         ?Item
    ?C                   KFld                    TRSIZE                         ?Size
    ?C                   KFld                    DftWHSE                        ?Default Location
    ?C                   KFld                    TRSCYM                         ?Sow Date
    ?C                   KFld                    TRCRDT                         ?Ready Date
    ?C                   KFld                    CUST990                        ?Customer 999990
    ?C     Lot997Key     KList
    ?C                   KFld                    TRITEM                         ?Item
    ?C                   KFld                    TRSIZE                         ?Size
    ?C                   KFld                    DftWHSE                        ?Default Location
    ?C                   KFld                    TRSCYM                         ?Sow Date
    ?C                   KFld                    TRCRDT                         ?Ready Date
    ?C                   KFld                    CUST997                        ?Customer 999997
    ?C     Lot998Key     KList
    ?C                   KFld                    TRITEM                         ?Item
    ?C                   KFld                    TRSIZE                         ?Size
    ?C                   KFld                    DftWHSE                        ?Default Location
    ?C                   KFld                    TRSCYM                         ?Sow Date
    ?C                   KFld                    TRCRDT                         ?Ready Date
    ?C                   KFld                    CUST998                        ?Customer 999998
    ?C     Lot999Key     KList
    ?C                   KFld                    TRITEM                         ?Item
    ?C                   KFld                    TRSIZE                         ?Size
    ?C                   KFld                    DftWHSE                        ?Default Location
    ?C                   KFld                    TRSCYM                         ?Sow Date
    ?C                   KFld                    TRCRDT                         ?Ready Date
    ?C                   KFld                    CUST999                        ?Customer 999999
    ?C     LotRDKey      KList
    ?C                   KFld                    TRITEM                         ?Item
    ?C                   KFld                    TRSIZE                         ?Size
    ?C                   KFld                    DftWHSE                        ?Default Location
    ?C                   KFld                    TRSCYM                         ?Sow Date
    ?C                   KFld                    TRCRDT                         ?Ready Date
     C     LotKey        KList
     C                   KFld                    LRITEM
     C                   KFld                    LRSIZE
     C                   KFld                    LRWHSE
     C                   KFld                    LRSOWD
     C                   KFld                    LDGLOC                         Always *Blank
     C                   KFld                    LRCRDY

     C                   EndSr
