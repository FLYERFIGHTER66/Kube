    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *??:````````````````````````````````````````````````````````````:?
      *??:  Update Default Move Destination Percentages               :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Jan. 2005            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program recalculates the Percent Used for the      ?:
      *? : default move destinations.                                ?:
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

     FFMOVDFT   IF   E           K DISK    Prefix(A_)
     FFMOVDFTUS UF   E           K DISK    Prefix(B_) Rename(RMOVDFT:MOVDFTUS)

      *? Function Prototypes

      *? Data Structures

      *? Field Definitions
     D  Hold_Item      S                   Like(A_DFITEM)
     D  Hold_Size      S                   Like(A_DFSIZE)
     D  Key_Item       S                   Like(A_DFITEM)
     D  Key_Size       S                   Like(A_DFSIZE)
     D  Item_Moves     S              9S 0

    ? /Eject
      *?  ...........................................................
      *?  :              C A L C U L A T I O N S                    :
      *?  :.........................................................:

    ?C     *LoVal        SetLL     FMOVDFT
    ?C                   Read      FMOVDFT
     C                   Eval      Hold_Item  = A_DFITEM
     C                   Eval      Hold_Size  = A_DFSIZE
     C*                  Eval      Item_Moves = A_DFUSED
     C                   DoW       not %EOF(FMOVDFT)
     C                   If        Hold_Item <> A_DFITEM or
     C                             Hold_Size <> A_DFSIZE
     C                   Eval      Key_Item = Hold_Item
     C                   Eval      Key_Size = Hold_Size
     C                   Eval      Hold_Item  = A_DFITEM
     C                   Eval      Hold_Size  = A_DFSIZE
     C                   ExSr      Updates
     C                   EndIf
     C                   If        A_DFDSID <> 99
     C                   Eval      Item_Moves = Item_Moves + A_DFUSED
     C                   EndIf
    ?C                   Read      FMOVDFT
     C                   EndDo
     C                   Eval      Key_Item = Hold_Item
     C                   Eval      Key_Size = Hold_Size
     C                   ExSr      Updates                                      |Last Rcd Update

     C                   Eval      *InLR = *On


    ? /Eject
      *?  ...........................................................
      *?  :      Updates  - Update the Chemical Application File    :
      *?  :.........................................................:

     C     Updates       BegSr

    ?C     DftLocKey     SetLL     FMOVDFTUS
    ?C     DftLocKey     ReadE     FMOVDFTUS
     C                   DoW       not %EOF(FMOVDFTUS)
     C                   If        B_DFDSID <> 99
     C                   Eval      B_DFPCTU = (B_DFUSED / Item_Moves) * 100
     C                   Else
     C                   Eval      B_DFPCTU = 0
     C                   Eval      B_DFUSED = 0
     C                   EndIf
    ?C                   Update    MOVDFTUS
    ?C     DftLocKey     ReadE     FMOVDFTUS
     C                   EndDo
     C                   Eval      Item_Moves = *Zero

     C                   EndSr

    ? /Eject
      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

    ?C     DftLocKey     KLIST
    ?C                   KFLD                    Key_Item
    ?C                   KFLD                    Key_Size

     C                   EndSR

