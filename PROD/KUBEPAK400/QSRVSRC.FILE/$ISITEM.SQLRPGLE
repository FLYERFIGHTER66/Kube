    ?H/COPY QFunctDefn,@CopyRight
    ?H DatFmt(*usa)
    ?H NoMain
      *??:````````````````````````````````````````````````````````````:?
      *??:     Determine if Item Size is Valid                        :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Oct. 2005            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program determins if the ITEM/SIZE combination     ?:
      *? : passed to it is a valid item and return a true indicator  ?:
      *? : if it is.                                                 ?:
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
    ?D/Copy QFunctDefn,$isItem

     ?*   ..................................................................
     ?*   :  $isItem                                              function :
     ?*   :................................................................:

     P $isItem         B                   Export
     D $isItem         PI              N
     D  #Item                        12A   const
     D  #Size                         3A   const

    ?C     ItemKey       KList
    ?C                   KFld                    #Item
    ?C                   KFld                    #Size
    ?C                   Open      FMINVT
    ?C     ItemKey       Chain     FMINVT
    ?C                   Close     FMINVT
     C                   Return    %Found(FMINVT) and IMSTAT = 'A'

     P   $isItem       E
