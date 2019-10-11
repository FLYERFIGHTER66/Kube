    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *?                                                              ?
      *??|                                                            |?
      *??|            Fix Lot Inventory (Mark it Fixed)               |?
      *?|                                                            |?

      *? :````````````````````````````````````````````````````````````:
      *? : Created:  February, 2006       ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :  Program Description?                                    ?:
      *? : This program look at all the tags in a lot and if they are :
      *? : scanned into fixing, it marks the lot as fixed.           ?:
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

     FFDLOTNFIX UF   E           K DISK                                         ?Lots Not Fixed
     FFTRAYLOT  IF   E           K DISK                                         ?Tray Master
     FFTRAYFIXEDIF   E           K DISK                                         ?Fixed Trays

      *? Function Prototypes
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Now

      *? Field Definitions
    ?D  ThreeWeeks     S              7S 0

      *? Indicators
    ?D  allFixed       S               N                                        ?All Trays are Fixed
    ?D  anyFixed       S               N                                        ?Any Tray is Fixed

     ?*   ................................................
     ?*   :   Main Calcs                                 :
     ?*   :..............................................:

      *?   Process all Available Inventory Allocated to Customers
    ?C     *LoVal        SetLL     FDLOTNFIX
    ?C                   Read      FDLOTNFIX

    ?C                   DoW       not %EOF(FDLOTNFIX)
     C                   Eval      AnyFixed = *Off
     C                   Eval      AllFixed = *On
      *?   Read through "ACTIVE" all trays in the Lot to check if they're fixed.
    ?C     TrayKey       SetLL     FTRAYLOT
    ?C     TrayKey       ReadE     FTRAYLOT
    ?C                   DoW       not %EOF(FTRAYLOT)
     C                   If        TRSTAT <> 'D'
    ?C     TRTAG#        SetLL     FTRAYFIXED
      *?   If any Tags are found, set on AnyFixed
     C                   If        %Equal(FTRAYFIXED)
     C                   Eval      AnyFixed = *On
      *?   If any Tags are not found, set off AllFixed
     C                   Else
     C                   Eval      AllFixed = *Off
     C                   EndIf
     C                   EndIf
    ?C     TrayKey       ReadE     FTRAYLOT
    ?C                   EndDo
      *?   If all trays are fixed mark as Fixed = 'Y'
    ?C                   Select
    ?C                   When      LDFIXD = 'H'                                 |H=Hold Fixers
     C*                  Leave it alone
    ?C                   When      allFixed and AnyFixed
     C                   Eval      LDFIXD = 'Y'                                 |Y=Completely Fixed
    ?C                   Update    RDLOT
    ?C                   When      anyFixed
     C                   Eval      LDFIXD = 'P'                                 |P=Partially Fixed
    ?C                   Update    RDLOT
    ?C                   When      LDCRDY < ThreeWeeks
     C                   Eval      LDFIXD = 'X'                                 ?X=eXclude from list
    ?C                   Update    RDLOT
    ?C                   EndSl

    ?C                   Read      FDLOTNFIX
    ?C                   EndDo

     C                   Eval      *InLr = *On


     ?*   ................................................
     ?*   :      *InzSr - Initialization Subroutine      :
     ?*   :..............................................:

     C     *InzSr        BegSr

    ?C     TrayKey       KList
    ?C                   KFld                    LDITEM                         ?Item
    ?C                   KFld                    LDSIZE                         ?Size
    ?C                   KFld                    LDSOWD                         ?Sow Date
    ?C                   KFld                    LDCRDY                         ?Ready Date

     C                   Eval      ThreeWeeks = $Date7($AddDate($Date(0):-21))

     C                   EndSr
