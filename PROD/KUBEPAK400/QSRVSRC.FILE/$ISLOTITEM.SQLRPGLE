    ?H/COPY QFunctDefn,@CopyRight
    ?H DatFmt(*usa)
    ?H NoMain
      *??:````````````````````````````````````````````````````````````:?
      *??:     Determine if Item Size is a Lot Control Item           :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Oct. 2005            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program determins if the ITEM/SIZE combination     ?:
      *? : passed to it is a valid Lot Control Item and returns      ?:
      *? : a true indicator if it is.                                 :
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
      *? :  WJB 10/28/05  ?Program creation...                       ?:
      *? :  xxx __/__/__  ?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :............................................................:

     FFMINVT    IF   E           K DISK    UsrOpn

      *? Function Prototypes
    ?D/Copy QFunctDefn,$isLotItem

     ?*   ..................................................................
     ?*   :  $isLotItem                                           function :
     ?*   :................................................................:

     P $isLotItem      B                   Export
     D $isLotItem      PI              N
     D  #Item                        12A   const
     D  #Size                         3A   const

     D  LotItem        S               N   Inz(*Off)

    ?C     ItemKey       KList
    ?C                   KFld                    #Item
    ?C                   KFld                    #Size
    ?C                   Open      FMINVT
    ?C     ItemKey       Chain     FMINVT
    ?C                   Close     FMINVT
     C                   If        %Found(FMINVT) and
     C                             IMSTAT='A' and
     C                             IMLOTC='Y'
     C                   Eval      LotItem = *On
     C                   EndIf

     C                   Return    LotItem

     P   $isLotItem    E
