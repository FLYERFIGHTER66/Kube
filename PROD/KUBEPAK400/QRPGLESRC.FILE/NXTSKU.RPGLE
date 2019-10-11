    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         GET NEXT AVAILBLE SKU#                             :?
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
      *? :      This program's basic functions are:                  ?:
      *? :        - ?Retrieve the next available SKU# from           ?:
      *? :          ?the UPC control file (FMUPCCTL)                 ?:
      *? :        - ?Validate it's uniquness (it could be            ?:
      *? :          ?a reserved UPC written to the UPC file          ?:
      *? :          ?at creation)                                    ?:
      *? :        - ?Increment it,                                   ?:
      *? :        - ?Write the new value to FMUPCCTL                 ?:
      *? :        - ?Pass the SKU# back to the calling program       ?:
      *? :    ====================================================   ?:
      *? :    !!!  THIS PROGRAM MUST BE USED TO ACCESS SKU#'s  !!!   ?:
      *? :    ====================================================   ?:
      *? :       This program is written to be fault tolerant.       ?:
      *? :       It will check the number retrieved from the         ?:
      *? :       control file to verify that it is available and     ?:
      *? :       if it is not, it will increment the SKU# until      ?:
      *? :       a good one is found.  Likewise when publishing      ?:
      *? :       the next available SKU, the program will ensure     ?:
      *? :       a valid unused SKU prior to writing back to the      :
      *? :       file.  By being this fault tolerant, this same      ?:
      *? :       program could be used to "find" available SKU's     ?:
      *? :       should we ever reach the end of the available       ?:
      *? :       SKU range.                                          ?:
      *? :............................................................:
      *
     FFMUPCCTL  UF   E           K DISK
     FFMUPCSKU  IF   E           K DISK

      *? Field Definitions
     D   SKU_to_Use    S                   Like(CONXTSKU#)                      ?Current User ID

    ?C     01            Chain     FMUPCCTL
    ?C                   DoU       not %Equal(FMUPCSKU)                            ?
    ?C     CONXTSKU#     SetLL     FMUPCSKU
     C                   If        %Equal(FMUPCSKU)
     C                   Eval      CONXTSKU# = CONXTSKU# + 1
     C                   Iter
     C                   EndIf
    ?C                   EndDo
     C                   Eval      SKU_to_Use = CONXTSKU#
     C                   Eval      CONXTSKU# = CONXTSKU# + 1
    ?C                   DoU       not %Equal(FMUPCSKU)                            ?
    ?C     CONXTSKU#     SetLL     FMUPCSKU
     C                   If        %Equal(FMUPCSKU)
     C                   Eval      CONXTSKU# = CONXTSKU# + 1
     C                   Iter
     C                   EndIf
    ?C                   EndDo
    ?C                   Update    RMUPCCTL
     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *ENTRY        PList
    ?C                   Parm                    SKU_to_Use
    ?C                   Parm                    COUPCPREF
    ?C                   Parm                    COUPCMANF

    ?C                   EndSr                                                  ?
