    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *?                                                              ?
      *??|                                                            |?
      *??|            Delete Spec Orders   (DLTSPCORD)                |?
      *?|                                                            |?

      *? :````````````````````````````````````````````````````````````:
      *? : Created:  March, 2006          ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :  Program Description?                                    ?:
      *? : This program balances FDLOT to FDLOTRD                     :
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

      *? Order Details (FIORDR)
     FFIORDRLOT IF   E           K DISK
      *? Tray Records  (FTRAY)
     FFTRAYD    IF   E           K DISK
      *? Lot Master File (FDLOT)
     FFDLOTL    UF A E           K DISK
      *? Lot Ready date (FDLOTRD)
     FFDLOTRDR  UF   E           K DISK
     FFDLOTRDC  UF A E           K DISK    Rename(RDLOTRD:RDLOTRDC)
      *? Item Allocations (FALITEM)
     FFALITEMRO UF   E           K DISK
     FFALITEML  UF A E           K DISK    Rename(RALITEM:RALITEML)

      *? Function Prototypes
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Now

      *? Field Definitions
    ?D Need            S             11s 1
    ?D ThisWeek        S                   Like(LDCRDY)

      *? Indicators

     ?*   ................................................
     ?*   :   Main Calcs                                 :
     ?*   :..............................................:

      *?   Process all Available Inventory Allocated to Customers
    ?C     ThisWeek      SetLL     FDLOTL
    ?C                   Read      FDLOTL

    ?C                   DoW       not %EOF(FDLOTL)
     C                   If        LDSOWD <> 0
     C                   ExSr      ClrFDLOT
     C                   ExSr      ClrFDLOTRD
     C                   ExSr      ClrFALITEM
     C                   ExSr      GetOrders
     C                   ExSr      FixAllocRD
     C                   Eval      LDDTLA = $MDYDate($Date(0))
     C                   Eval      LDTIME = $Now()
     C                   Eval      LDUSER = 'BALLOTINV'
    ?C                   Update    RDLOT
     C                   EndIf
    ?C                   Read      FDLOTL
    ?C                   EndDo

     C* TEMP OUT         Call      'DLCLOTINV'
     C* TEMP OUT         Call      'BALLOTINV2'

     C                   Eval      *InLr = *On


     ?*   ................................................
     ?*   :      ClrFDLOT - Clear FDLOT                  :
     ?*   :..............................................:

     C     ClrFDLOT      BegSr

     C                   Eval      LDQTOH = *Zero
     C                   Eval      LDSOWN = *Zero
     C                   Eval      LDQFIX = *Zero
     C                   Eval      LDQDMP = *Zero
     C                   Eval      LDQTAL = *Zero

    ?C     ThisLOTtr     SetLL     FTRAYD
    ?C     ThisLOTtr     ReadE     FTRAYD
    ?C                   DoW       not %EOF(FTRAYD)
     C                   If        TRCRDT = LDCRDY
     C                   Eval      LDSOWN = LDSOWN + 1
    ?C                   Select
    ?C                   When      TRSTAT = 'D'
     C                   Eval      LDSOWN = LDSOWN - 1
    ?C                   When      TRSTAT = 'F' or
    ?C                             TRSTAT = 'P'
     C                   Eval      LDQFIX = LDQFIX + 1
    ?C                   When      TRSTAT = 'M' or
    ?C                             TRSTAT = 'B'
     C                   Eval      LDQDMP = LDQDMP + 1
    ?C                   Other
     C                   Eval      LDQTOH = LDQTOH + 1
    ?C                   EndSl
     C                   EndIf
    ?C     ThisLOTtr     ReadE     FTRAYD
    ?C                   EndDo

     C                   Eval      LDQTAL = *Zero
     C                   Eval      LDQTAV = LDQTOH

     C                   EndSr

     ?*   ................................................
     ?*   :      ClrFDLOTRD - Clear FDLOTRD              :
     ?*   :..............................................:

     C     ClrFDLOTRD    BegSr

    ?C     ThisLOT       SetLL     FDLOTRDR
    ?C     ThisLOT       ReadE     FDLOTRDR

    ?C                   DoW       not %EOF(FDLOTRDR)
     C                   Eval      LRQTAL = *Zero
     C                   Eval      LRQTAV = LRQTOH
    ?C                   Update    RDLOTRD
    ?C     ThisLOT       ReadE     FDLOTRDR
    ?C                   EndDo

     C                   EndSr

     ?*   ................................................
     ?*   :      ClrFALITEM - Clear FALITEM              :
     ?*   :..............................................:

     C     ClrFALITEM    BegSr

     ?*   Clear everything except Ready Bay and Fixer Allocations
    ?C     ThisLOT       SetLL     FALITEMRO
    ?C     ThisLOT       ReadE     FALITEMRO

    ?C                   DoW       not %EOF(FALITEMRO)
     C                   If        AIGLOC <> 'R' and
WJB  C*                            AIORD# <> 999999
WJB  C                             AIORD# <  999990
     C                   Eval      AIQTOA = *Zero
    ?C                   Update    RALITEM
     C                   EndIf
    ?C     ThisLOT       ReadE     FALITEMRO
    ?C                   EndDo

     C                   EndSr

     ?*   ................................................
     ?*   :      GetOrders- Sum up Lot RD info           :
     ?*   :..............................................:

     C     GetOrders     BegSr

    ?C     ThisLOTtr     SetLL     FIORDRLOT
    ?C     ThisLOTtr     ReadE     FIORDRLOT

    ?C                   DoW       not %EOF(FIORDRLOT)
     C                   Eval      Need = OIQORD - OIQSHP

      *?Update FDLOT
    ?C                   ExSr      UpdFDLOT
      *?Update FDLOTRD
    ?C                   ExSr      UpdFDLOTRD
      *?Update FALITEM
    ?C                   ExSr      UpdFALITEM

    ?C     ThisLOTtr     ReadE     FIORDRLOT
    ?C                   EndDo

     C                   EndSr


     ?*   ................................................
     ?*   :      UpdFDLOT - Update FDLOT & FDLOTRD       :
     ?*   :..............................................:

     C     UpdFDLOT      BegSr

     C                   Eval      LDQTAL = LDQTAL + Need
     C                   Eval      LDQTAV = LDQTAV - Need

     C                   EndSr

     ?*   ................................................
     ?*   :      UpdFDLOTRD - Update  FDLOTRD            :
     ?*   :..............................................:

     C     UpdFDLOTRD    BegSr

     C                   Clear                   RDLOTRD

      *?   Update or Write the FDLOTRD file record
    ?C     ThisLOTRD     Chain     FDLOTRDC
     C                   If        %Found(FDLOTRDC)
     C                   Eval      LRQTAL = LRQTAL + Need
     C                   Eval      LRQTAV = LRQTAV - Need
    ?C                   Update    RDLOTRDC
     C                   Else
     C                   Eval      LRSTAT = 'A'                                 ?STATUS A/D/C
     C                   Eval      LRITEM = OIITEM                              ?ITEM #
     C                   Eval      LRSIZE = OISIZE                              ?SIZE CODE
     C                   Eval      LRWHSE = ' '                                 ?LOCATION
     C                   Eval      LRSOWD = OISOW                               ?SOW DATE CYMD
     C                   Eval      LRGLOC = ' '                                 ?GROW LOC. ORIG
     C                   Eval      LRPHYT = ' '                                 ?PHYTO CODE
     C                   Eval      LRCRDY = OIRVDT                              ?CURR. READY DATE C
     C                   Eval      LRCPHY = ' '                                 ?CURR PHYTO CODE
     C                   Eval      LRCLOC = ' '                                 ?LOC. CURR
     C                   Eval      LRCODE = 'A'                                 ?CODE A/H/R/S/T
     C                   Eval      LRCUST = OICUST                              ?RESERV. CUST #
     C                   Eval      LRAREA = ' '                                 ?AREA
     C                   Eval      LRCOMP = 1                                   ?COMPANY NO
     C                   Eval      LRQTOH = 0                                   ?QTY O/H
     C                   Eval      LRDTLA = $MDYDATE($DATE(0))                  ?LAST ACTIVITY DATE
     C                   Eval      LRTIME = $NOW()                              ?TIME
     C                   Eval      LRUSER = $USER()                             ?USER
     C                   Eval      LRALPH = OIITMA                              ?ALPHA SEARCH
     C                   Eval      LRPRCL = OIPRCL                              ?PRODUCT CLASS
     C                   Eval      LRQTAL = Need                                ?QTY ALOC
     C                   Eval      LRDESC = OIDES1                              ?DESCRIPTION
     C                   Eval      LRQTCM = 0                                   ?QTY COMIT
     C                   Eval      LRQTSL = 0                                   ?QTY SOLD
     C                   Eval      LRQADJ = 0                                   ?QTY ADJ
     C                   Eval      LRQTAV = -Need                               ?QTY AVAIL
    ?C                   Write     RDLOTRDC
     C                   EndIf

     C                   EndSr

     ?*   ................................................
     ?*   :      UpdFALITEM - Update  FALITEM            :
     ?*   :..............................................:

     C     UpdFALITEM    BegSr

     C                   Clear                   RALITEM
      *?   Update or Write the FDLOTRD file record
    ?C     ThisLOTAL     Chain     FALITEML
     C                   If        %Found(FALITEML)
     C                   Eval      AIQTOA = AIQTOA + Need
    ?C                   Update    RALITEML
     C                   Else
     C                   Eval      AIORD# = OIORD#                              ?ORDER NUMBER
     C                   Eval      AIOSEQ = OISEQ#                              ?ORDER SEQ #
     C                   Eval      AISHPD = OIRVDT                              ?SHIP DATE CYMD
     C                   Eval      AISTAT = 'A'                                 ?STATUS A/D/C
     C                   Eval      AIITEM = OIITEM                              ?ITEM #
     C                   Eval      AISIZE = OISIZE                              ?SIZE CODE
     C                   Eval      AIWHSE = ' '                                 ?LOCATION
     C                   Eval      AISOWD = OISOW                               ?SOW DATE CYMD
     C                   Eval      AIGLOC = ' '                                 ?GROW LOC. ORIG
     C                   Eval      AIPHYT = OIPHYT                              ?PHYTO CODE
     C                   Eval      AICRDY = OIRVDT                              ?CURR READY DATE
     C                   Eval      AICUST = OICUST                              ?RESERV. CUST #
     C                   Eval      AICOMP = 1                                   ?COMPANY NO
     C                   Eval      AIQTOA = Need                                ?QTY ALLOC
     C                   Eval      AIDTLA = $MDYDate($Date(0))                  ?LAST ACTIVITY DATE
     C                   Eval      AITIME = $Now()                              ?TIME
     C                   Eval      AIUSER = $User                               ?USER
     C                   Eval      AIPRCL = OIPRCL                              ?PRODUCT CLASS
    ?C                   Write     RALITEML
     C                   EndIf

     C                   EndSr

     ?*   ................................................
     ?*   :      FixAllocRD - Fix FDLOTRD allocations    :
     ?*   :..............................................:

     C     FixAllocRD    BegSr

      *?   Process all Available Inventory Allocated to Customers
    ?C     ThisLOT       SetLL     FDLOTRDR
    ?C     ThisLOT       ReadE     FDLOTRDR

    ?C                   DoW       not %EOF(FDLOTRDR)
     C*                  If        LRQTAL = *Zero
     C*                  Eval      LRQTAV = LRQTOH
    ?C*                  Update    RDLOTRD
    ?C     ThisLOT       ReadE     FDLOTRDR
    ?C                   EndDo

     C                   EndSr

     ?*   ................................................
     ?*   :      *InzSr - Initialization Subroutine      :
     ?*   :..............................................:

     C     *InzSr        BegSr

    ?C     ThisLOT       KList
    ?C                   KFld                    LDITEM                         ?Item
    ?C                   KFld                    LDSIZE                         ?Size
    ?C                   KFld                    LDCRDY                         ?Current Ready

    ?C     ThisLOTtr     KList
    ?C                   KFld                    LDCRDY                         ?Current Ready
    ?C                   KFld                    LDITEM                         ?Item
    ?C                   KFld                    LDSIZE                         ?Size

    ?C     ThisLOTRD     KList
    ?C                   KFld                    OICUST                         ?Customer
    ?C                   KFld                    OIITEM                         ?Item
    ?C                   KFld                    OISIZE                         ?Size
    ?C                   KFld                    OIRVDT                         ?Current Ready

    ?C     ThisLOTAL     KList
    ?C                   KFld                    OIORD#                         ?Order Number
    ?C                   KFld                    OISEQ#                         ?Order Sequence
    ?C                   KFld                    OIITEM                         ?Item
    ?C                   KFld                    OISIZE                         ?Size

     C                   Eval      ThisWeek = $Date7($AddDate(
     C                                        $Monday($Date(0):'SAT'):14))

     C                   EndSr
