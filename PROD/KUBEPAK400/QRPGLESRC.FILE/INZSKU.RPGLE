    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Initialize SKU File                                :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Oct. 2008            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? :  *INZSR   -?Initialization Subroutine                     ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :          ?                                                ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :   Every Kube Pak Item (FMINVT) is assigned a UNIQUE       ?:
      *? :   5 digit SKU#.  The SKU# is used in the creation of      ?:
      *? :   UPC Bar Codes.                                          ?:
      *? :          ?                                                ?:
      *? :      This program's basic functions is to assign the      ?:
      *? :      initial set of SKU# to all current FMINVT records    ?:
      *? :............................................................:
      *
     FFMINVT    IP   E           K DISK

    ?C                   Call      'CRTSKU'
    ?C                   Parm                    IMITEM
    ?C                   Parm                    IMSIZE
    ?C                   Parm                    IMDES1
    ?C                   Parm                    SKU_to_Use        5 0

