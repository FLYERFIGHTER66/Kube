    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:     Return Order's Ship Date (Date Wanted)                 :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Nov. 2015            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program determins the Ship Date for an             ?:
      *? : order passed in.                                          ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : Int   Date  ?-Change Description                     ?  ?:
      *? :  WJB 11/16/15  ?Program creation...                       ?:
      *? :  xxx __/__/__  ?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :............................................................:

     ?*   ..................................................................
     ?*   :  $OrdShpDat                                           function :
     ?*   :................................................................:

     D #OrdShpDat      PR                  ExtPgm('#OrdShpDat')
     D  #Order                        6P 0
     D  #ShipDate                     6P 0
     D #OrdShpDat      PI
     D  #Order                        6P 0
     D  #ShipDate                     6P 0

    ? /Free

    ?   Exec SQL   Select  OHDTCN
                   into    :#ShipDate
                   from    FHORDR
                   Where   OHORD# = :#Order ;
    ?
    ?     Return;
    ?
      /End-Free
