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

     FFMCARTS   UF A E           K DISK    UsrOpn                               ?Carts Master
     FFCARTTX   O  A E           K DISK    UsrOpn                               ?Cart Transactions

      *? Function Prototypes
    ?D/Copy QFunctDefn,$AllocCart
    ?D/Copy QFunctDefn,$User
    ?D/Copy QFunctDefn,$TimeStamp

     ?*   ..................................................................
     ?*   :  $AllocCart                                           function :
     ?*   :................................................................:

     P $AllocCart      B                   Export
     D $AllocCart      PI              Z
     D  #CART                              const like(CMCART)
     D  #STAT                              const like(CMSTAT)
     D  #LLOC                              const like(CMLLOC)
     D  #PROG                              const like(CMPROG)

    ?C                   Open      FMCARTS
    ?C                   Open      FCARTTX

     C                   Eval      CMCART = #CART                               ?Cart Number
     C                   Eval      CXCART = #CART                               ?Cart Number
    ?C     CMCART        Chain     FMCARTS
      *? Cart Status
     C                   Eval      CXOLDS = CMSTAT                              ?CART STATUS
     C                   Eval      CMSTAT = #STAT                               ?CART STATUS
     C                   Eval      CXNEWS = CMSTAT                              ?CART STATUS
      *? Cart Location
     C                   Eval      CXOLDL = CMLLOC                              ?LAST KNOWN LOCATION
     C                   Eval      CMLLOC = #LLOC                               ?LAST KNOWN LOCATION
     C                   Eval      CXNEWL = CMLLOC                              ?LAST KNOWN LOCATION
      *? Cart Last Updated
     C                   Eval      CMPROG = #PROG                               ?Last Program
     C                   Eval      CXPROG = CMPROG                              ?Last Program
     C                   Eval      CMUSER = $User()                             ?Last User
     C                   Eval      CXUSER = CMUSER                              ?Last User
     C                   Eval      CMTIME = $TimeStamp()                        ?Change Timestamp
     C                   Eval      CXTIME = CMTIME                              ?Change Timestamp
     C                   If        %Found(FMCARTS)
    ?C                   Update    RMCARTS
     C                   Else
     C                   Eval      CMTYPE = '*UnKnown'                          ?CART TYPE
     C                   Eval      CMNOTE = 'Undefined Cart created in Fixing'  ?CART NOTE
    ?C                   Write     RMCARTS
     C                   EndIf
    ?C                   Write     RCARTTX

    ?C                   Close     FMCARTS
    ?C                   Close     FCARTTX

     C                   Return    CMTIME

     P   $AllocCart    E
